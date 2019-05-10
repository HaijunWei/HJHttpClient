//
//  HJHTTPResponseDecoder.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHTTPResponseDecoder.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

NSErrorDomain const HJHTTPResponseDecoderDomain = @"com.haijunwei.responseDecoder";
NSInteger const HJHTTPResponseDecoderFailure = -1;
NSInteger const HJHTTPResponseDecoderNormalStatusCode = 200;

@implementation HJHTTPResponseDecoder

- (id)request:(HJHTTPRequest *)req didGetURLResponse:(NSHTTPURLResponse *)response responseData:(id)responseData error:(NSError *)error {
    if (error) {
        NSString *message = @"";
        NSInteger statusCode = HJHTTPResponseDecoderNormalStatusCode;
        // 如果是服务器响应错误，设置错误码为响应码
        if ([error.userInfo.allKeys containsObject:AFNetworkingOperationFailingURLResponseErrorKey]) {
            NSHTTPURLResponse *res = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            statusCode = res.statusCode;
            message = error.localizedDescription;
        }
        if (responseData) {
            message = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            return [NSError errorWithDomain:HJHTTPResponseDecoderDomain code:statusCode userInfo:@{NSLocalizedDescriptionKey:message}];
        }
        return error;
    }
    NSError *resultError;
    HJHTTPResponse *httpResponse = [self createResponse:req responseData:responseData error:&resultError];
    httpResponse.allHeaderFields = response.allHeaderFields;
    if (resultError) { return resultError; }
    return httpResponse;
}

/// 创建请求响应
- (HJHTTPResponse *)createResponse:(HJHTTPRequest *)request responseData:(id)responseData error:(NSError **)error {
    HJHTTPResponse *response = [HJHTTPResponse new];
    id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    response.statusCode = HJHTTPResponseDecoderNormalStatusCode;
    response.rawData = responseData;
    if (json == nil) { /* json = nil，代表数据仅仅是一段文字，直接解析字符串 */
        if (request.responseDataCls != NULL) {
            *error = [NSError errorWithDomain:HJHTTPResponseDecoderDomain
                                         code:HJHTTPResponseDecoderFailure
                                     userInfo:@{NSLocalizedDescriptionKey:@"服务器响应数据类型错误"}];
        }
        response.data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        return response;
    }
    response.data = json;
    response.dataObject = [self deserializationWithResponseDataCls:request.responseDataCls
                                               deserializationPath:request.deserializationPath
                                                              data:json];
    return response;
}

/// 反序列化数据
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
