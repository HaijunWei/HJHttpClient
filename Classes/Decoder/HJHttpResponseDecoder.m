//
//  HJHttpResponseDecoder.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHttpResponseDecoder.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

NSErrorDomain const HJHttpResponseDecoderDomain = @"com.haijunwei.httpclient.response.decoder";

HJHttpResponseKey const HJHttpResponseCodeKey = @"code";
HJHttpResponseKey const HJHttpResponseDataKey = @"data";
HJHttpResponseKey const HJHttpResponseMessageKey = @"message";

@implementation HJHttpResponseDecoder

- (id)request:(HJHttpRequest *)req didGetURLResponse:(NSHTTPURLResponse *)response responseData:(id)responseData error:(NSError *)error {
    if (error) {
        // 如果是服务器响应错误，设置错误码为响应码
        if ([error.userInfo.allKeys containsObject:AFNetworkingOperationFailingURLResponseErrorKey]) {
            NSHTTPURLResponse *res = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            NSInteger code = res.statusCode;
            NSString *message = error.localizedDescription;
            if (responseData) { message = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; }
            return [NSError errorWithDomain:HJHttpResponseDecoderDomain code:code userInfo:@{NSLocalizedDescriptionKey:message}];
        }
        return error;
    }
    NSError *resultError;
    HJHttpResponse *httpResponse = [self generateResponse:req responseData:responseData error:&resultError];
    httpResponse.allHeaderFields = response.allHeaderFields;
    if (resultError) { return resultError; }
    return httpResponse;
}

/// 创建请求响应
- (HJHttpResponse *)generateResponse:(HJHttpRequest *)request responseData:(id)responseData error:(NSError **)error {
    HJHttpResponse *response = [HJHttpResponse new];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    jsonObject = [self willGenerateResponse:jsonObject];
    response.code = HJHttpResponseCodeNormal;
    response.data = jsonObject;
    response.rawData = responseData;
    
    // 解析{data: messsage: code:}类数据
    BOOL isNeedResponseKeyMapping = self.responseKeyMapping != nil;
    if (isNeedResponseKeyMapping && jsonObject && [jsonObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *jsonDict = jsonObject;
        for (NSString *key in self.responseKeyMapping.allKeys) {
            [response setValue:jsonDict[self.responseKeyMapping[key]] forKey:key];
        }
    } else if (!jsonObject) { /* jsonObject = nil，代表数据不是JSON数据，直接解析字符串 */
        response.data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    }
    
    BOOL isJSON = [response.data isKindOfClass:[NSArray class]] || [response.data isKindOfClass:[NSDictionary class]];
    if (!response.data || (!isJSON && request.responseDataCls != NULL)) {
        *error = [NSError errorWithDomain:HJHttpResponseDecoderDomain
                                     code:HJHttpResponseCodeDecoderFailure
                                 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"服务器响应数据与预期不符\n%@", response.data]}];
        return nil;
    }
    response.dataObject = [self deserializationWithResponseDataCls:request.responseDataCls
                                               deserializationPath:request.deserializationPath
                                                              data:response.data];
    return response;
}

#pragma mark - Public

- (id)willGenerateResponse:(id)responseObject {
    return responseObject;
}

#pragma mark - Helpers

- (id)deserializationWithResponseDataCls:(Class)cls deserializationPath:(NSString *)path data:(id)data {
    if (cls == NULL) { return nil; }
    if (path && [data isKindOfClass:[NSDictionary class]]) {
        // 跳到指定路径
        NSArray *paths = [path componentsSeparatedByString:@"."];
        for (NSString *path in paths) {
            data = data[path];
        }
    }
    if ([data isKindOfClass:[NSArray class]]) {
        return [cls mj_objectArrayWithKeyValuesArray:data];
    } else {
        return [cls mj_objectWithKeyValues:data];
    }
}

@end
