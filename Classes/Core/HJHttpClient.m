//
//  HJHttpClient.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHttpClient.h"
#import "HJHttpTask+Private.h"
#import "HJHttpRequestGroup+Private.h"
#import <AFNetworking/AFNetworking.h>

#define HJNetWatingLog(FORMAT, ...) \
printf("--------------------------------------\n☕️ %s\n\n",    \
[[NSString stringWithFormat:(FORMAT), ##__VA_ARGS__] UTF8String]);

#define HJNetSuccessLog(FORMAT, ...) \
printf("--------------------------------------\n🎉 %s\n\n",    \
[[NSString stringWithFormat:(FORMAT), ##__VA_ARGS__] UTF8String]);

#define HJNetErrorLog(FORMAT, ...) \
printf("--------------------------------------\n❌ %s\n\n",    \
[[NSString stringWithFormat:(FORMAT), ##__VA_ARGS__] UTF8String]);

NSErrorDomain const HJHttpClientDomain = @"com.haijunwei.httpclient";

@interface HJHttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@property (nonatomic, strong) AFJSONRequestSerializer *jsonRequestSerializer;
@property (nonatomic, strong) NSMutableArray<HJHttpTask *> *tasks;

@end

@implementation HJHttpClient

+ (instancetype)shared {
    static id object;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [self new];
    });
    return object;
}

#pragma mark - 单例便利方法

+ (HJHttpTask *)enqueue:(HJHttpRequest *)req
                success:(HJHttpClientSingleSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure {
    return [[self shared] enqueue:req success:success failure:failure];
}

+ (HJHttpTask *)enqueueGroup:(HJHttpRequestGroup *)group
                     success:(HJHttpClientSuccessBlock)success
                     failure:(HJHttpClientFailureBlock)failure {
    return [[self shared] enqueueGroup:group success:success failure:failure];
}

#pragma mark - 发起请求

- (HJHttpTask *)enqueue:(HJHttpRequest *)req
                success:(HJHttpClientSingleSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure {
    HJHttpRequestGroup *group = [HJHttpRequestGroup new];
    [group add:req];
    return [self enqueueGroup:group success:^(NSArray<HJHttpResponse *> * _Nonnull reps) {
        if (success) { success(reps.firstObject); }
    } failure:failure];
}

- (HJHttpTask *)enqueueGroup:(HJHttpRequestGroup *)group
                     success:(HJHttpClientSuccessBlock)success
                     failure:(HJHttpClientFailureBlock)failure {
    HJHttpTask *httpTask = [HJHttpTask new];
    httpTask.state = HJHttpTaskStateNotRunning;
    [self enqueueRequests:group.requests repArray:nil task:httpTask success:success failure:failure];
    [self.tasks addObject:httpTask];
    __weak typeof(self) weakSelf = self;
    httpTask.removeFromContainerBlock = ^(HJHttpTask * _Nonnull task) {
        [weakSelf.tasks removeObject:task];
    };
    return httpTask;
    
}

#pragma mark - 核心方法

/// 执行请求，组合响应值
- (void)enqueueRequests:(NSArray *)reqArray
               repArray:(NSMutableArray *)repArray
                   task:(HJHttpTask *)task
                success:(HJHttpClientSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure {
    NSMutableArray *reqArrayM = [reqArray mutableCopy];
    NSMutableArray *subReqArray = [reqArrayM.firstObject mutableCopy];
    
    for (int i = 0; i < subReqArray.count; i++) {
        // 创建有依赖关系的请求
        if (![subReqArray[i] isKindOfClass:[HJHttpRequest class]]) {
            HJHttpRequestLazyAddBlock block = subReqArray[i];
            subReqArray[i] = block(repArray);
        }
    }
    __weak typeof(task) weakTask = task;
    [self enqueueRequests:subReqArray mainTask:task success:^(NSArray *reps) {
        // 拼接所有响应值
        NSMutableArray *resultReps = repArray;
        if (!resultReps) { resultReps = [NSMutableArray new]; }
        [resultReps addObjectsFromArray:reps];
        
        if (reqArrayM.count > 1) {
            // 执行下一组请求
            [reqArrayM removeObjectAtIndex:0];
            [self enqueueRequests:reqArrayM repArray:resultReps task:weakTask success:success failure:failure];
            return;
        }
        weakTask.state = HJHttpTaskStateNotRunning;
        [weakTask removeFromContainer];
        if (success) { success(resultReps); }
    } failure:^(NSError * _Nonnull error) {
        weakTask.state = HJHttpTaskStateNotRunning;
        [weakTask removeFromContainer];
        if (failure) { failure(error); }
    }];
}

/// 执行请求集合
- (void)enqueueRequests:(NSArray<HJHttpRequest *> *)reqs
               mainTask:(HJHttpTask *)mainTask
                success:(HJHttpClientSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure {
    NSMutableArray *repsArrayM = [NSMutableArray new];
    for (int i = 0; i < reqs.count; i++) {
        [repsArrayM addObject:[NSNull null]];
    }
    __weak typeof(mainTask) weakMainTask = mainTask;
    __block NSError *resultError = nil;
    dispatch_group_t group = dispatch_group_create();
    // 只有一个请求并且是上传文件，可获取进度
    if (reqs.count == 1 && [(HJHttpRequest *)reqs.firstObject files]) {
        weakMainTask.progress = 0;
        weakMainTask.state = HJHttpTaskStateProgress;
    } else {
        weakMainTask.state = HJHttpTaskStateLoading;
    }
    for (int i = 0; i < reqs.count; i++) {
        dispatch_group_enter(group);
        HJHttpTask *task = [self enqueueRequest:reqs[i] uploadProgress:^(NSProgress *uploadProgress) {
            if (weakMainTask.state == HJHttpTaskStateProgress) {
                weakMainTask.progress = uploadProgress.fractionCompleted;
            }
        } success:^(id  _Nonnull rep) {
            repsArrayM[i] = rep;
            dispatch_group_leave(group);
        } failure:^(NSError * _Nonnull error) {
            if (!resultError) {
                resultError = error;
                // 一个请求出错，取消全部
                [weakMainTask cancel];
            }
            dispatch_group_leave(group);
        }];
        [weakMainTask addSubtask:task];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (resultError) { failure(resultError); }
        else { success(repsArrayM); }
    });
}

/// 执行单个请求
- (HJHttpTask *)enqueueRequest:(HJHttpRequest *)req
                uploadProgress:(void(^)(NSProgress *uploadProgress))uploadProgress
                       success:(HJHttpClientSuccessBlock)success
                       failure:(HJHttpClientFailureBlock)failure {
    [self willExecuteRequest:req];
    NSMutableURLRequest *urlRequest = [self createURLRequest:req];
    if ([self.delegate respondsToSelector:@selector(httpClient:prepareURLRequest:)]) {
        urlRequest = [self.delegate httpClient:self prepareURLRequest:urlRequest];
    }
    void (^handleCallback)(id response) = ^(id response){
        if ([response isKindOfClass:[NSError class]]) {
            // 网络回调在子线程，错误处理很多时候需要操作UI，切到主线程回调
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *e = [self request:req didError:response];
                failure(e ? : response);
            });
        } else {
            [self request:req didSucess:response];
            success(response);
        }
    };
    NSURLSessionDataTask * task = [self.httpManager dataTaskWithRequest:urlRequest uploadProgress:uploadProgress downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        id resultObject = [self.responseDecoder request:req didGetURLResponse:(NSHTTPURLResponse *)response
                                           responseData:responseObject
                                                  error:error];
        if ([resultObject isKindOfClass:[NSError class]]) {
            handleCallback(resultObject);
        } else {
            NSError *error = [self verifyResponse:resultObject forRequest:req];
            handleCallback(error ? : resultObject);
        }
    }];
    [task resume];
    HJHttpTask *httpTask = [HJHttpTask new];
    [httpTask addSubtask:task];
    return httpTask;
}

/// 将要执行请求
- (void)willExecuteRequest:(HJHttpRequest *)req {
    if (self.isPrintLog) {
        HJNetWatingLog(@"%@，%@，%@", [self methodNameWithRequest:req], req.path, req.params ? : @"{\n}");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(httpClient:prepareRequest:)]) {
            [self.delegate httpClient:self prepareRequest:req];
        }
    });
}

/// 请求成功回调
- (void)request:(HJHttpRequest *)req didSucess:(HJHttpResponse *)rep {
    if (self.isPrintLog) {
        HJNetSuccessLog(@"%@，%@，%@", [self methodNameWithRequest:req], req.path, rep.data);
    }
}

/// 验证响应值
- (NSError *)verifyResponse:(HJHttpResponse *)rep forRequest:(HJHttpRequest *)req {
    id error;
    if ([self.delegate respondsToSelector:@selector(httpClient:verifyResponse:forRequest:)]) {
        error = [self.delegate httpClient:self verifyResponse:rep forRequest:req];
    }
    if ([error isKindOfClass:[NSString class]]) {
        error = [NSError errorWithDomain:HJHttpClientDomain
                                    code:rep.code
                                userInfo:@{NSLocalizedDescriptionKey:error}];
    }
    if (error && self.isPrintResponseOnError && self.isPrintLog) {
        HJNetErrorLog(@"%@, %@, %@", [self methodNameWithRequest:req], req.path, [[NSString alloc] initWithData:rep.rawData encoding:NSUTF8StringEncoding]);
    }
    return error;
}

/// 请求发生错误
- (NSError *)request:(HJHttpRequest *)req didError:(NSError *)error {
    if (self.isPrintLog) {
        HJNetErrorLog(@"%@, %@, %@", [self methodNameWithRequest:req], req.path, error.localizedDescription);
    }
    __block NSError *nError = nil;
    if ([self.delegate respondsToSelector:@selector(httpClient:request:didReceiveError:)]) {
        nError = [self.delegate httpClient:self request:req didReceiveError:error];
    }
    return nError;
}

#pragma mark - Helpers

/// 创建请求
- (NSMutableURLRequest *)createURLRequest:(HJHttpRequest *)request {
    NSError *error;
    NSMutableURLRequest *urlRequest;
    NSString *method = [self methodNameWithRequest:request];
    NSString *urlString = [[NSURL URLWithString:request.path relativeToURL:self.baseURL] absoluteString];
    AFHTTPRequestSerializer *requestSerializer;
    switch (request.contentType) {
        case HJHttpContentTypeFormData:
            requestSerializer = self.httpRequestSerializer;
            break;
        case HJHttpContentTypeJSON:
            requestSerializer = self.jsonRequestSerializer;
            break;
    }
    if (request.files) {
        urlRequest = [requestSerializer multipartFormRequestWithMethod:method URLString:urlString parameters:request.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (HJHttpRequestFormFile *file in request.files) {
                [formData appendPartWithFileData:file.data name:file.name fileName:file.fileName mimeType:file.mineType];
            }
        } error:&error];
    } else {
        urlRequest = [requestSerializer requestWithMethod:method URLString:urlString parameters:request.params error:&error];
    }
    NSAssert(error == nil, @"创建请求失败");
    if (request.timeoutInterval > 0) {
        urlRequest.timeoutInterval = request.timeoutInterval;
    } else {
        urlRequest.timeoutInterval = self.timeoutInterval;
    }
    if (request.headerFields) {
        [request.headerFields.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [urlRequest setValue:request.headerFields[obj] forHTTPHeaderField:obj];
        }];
    }
    return urlRequest;
}

/// 获取指定Requet请求方式名称
- (NSString *)methodNameWithRequest:(HJHttpRequest *)request {
    switch (request.method) {
        case HJHttpMethodGET: return @"GET";
        case HJHttpMethodPOST: return @"POST";
        case HJHttpMethodPUT: return @"PUT";
        case HJHttpMethodDELETE: return @"DELETE";
    }
}

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        _isPrintLog = YES;
        _isPrintResponseOnError = YES;
        _timeoutInterval = 15;
        _tasks = [NSMutableArray new];
        _httpManager = [AFHTTPSessionManager manager];
        _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _httpManager.completionQueue = dispatch_get_global_queue(0, 0);
    }
    return self;
}

#pragma mark - Getter

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer new];
    }
    return _httpRequestSerializer;
}

- (AFJSONRequestSerializer *)jsonRequestSerializer {
    if (!_jsonRequestSerializer) {
        _jsonRequestSerializer = [AFJSONRequestSerializer new];
    }
    return _jsonRequestSerializer;
}

@end
