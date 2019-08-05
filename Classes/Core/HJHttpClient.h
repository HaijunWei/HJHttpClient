//
//  HJHttpClient.h
//
//  Created by Haijun on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import "HJHttpRequest.h"
#import "HJHttpTask.h"
#import "HJHttpResponse.h"
#import "HJHttpRequestGroup.h"
#import "HJHttpResponseDecoder+Protocol.h"
@class HJHttpClient;

NS_ASSUME_NONNULL_BEGIN

extern NSErrorDomain const HJHttpClientDomain;

typedef void(^HJHttpClientSingleSuccessBlock)(HJHttpResponse *rep);
typedef void(^HJHttpClientSuccessBlock)(NSArray<HJHttpResponse *> *reps);
typedef void(^HJHttpClientFailureBlock)(NSError *error);

typedef NS_ENUM(NSInteger, HJHttpClientErrorCode) {
    /* 验证响应值失败 */
    HJHttpClientErrorCodeVerifyFailure = 100,
};

@protocol HJHttpClientDelegate <NSObject>

@optional
/// 执行请求之前调用，可在此方法附加额外参数
- (HJHttpRequest *)httpClient:(HJHttpClient *)client prepareRequest:(HJHttpRequest *)request;
/// 执行请求之前调用，可在此方法中给请求头附加参数
- (NSMutableURLRequest *)httpClient:(HJHttpClient *)client prepareURLRequest:(NSMutableURLRequest *)request;
/// 检验响应数据，如果未通过返回错误信息描述（NSError 或者 NSString），通过返回nil
- (id)httpClient:(HJHttpClient *)client verifyResponse:(HJHttpResponse *)response forRequest:(HJHttpRequest *)request;
/// 请求发生错误，可自定义错误信息
- (NSError *)httpClient:(HJHttpClient *)client request:(HJHttpRequest *)request didReceiveError:(NSError *)error;

@end

@interface HJHttpClient : NSObject

+ (instancetype)shared;

@property (nonatomic, weak) id<HJHttpClientDelegate> delegate;
/// 是否打印日志，默认 = YES
@property (nonatomic, assign) BOOL isPrintLog;
/// 在错误的时候是否打印响应值，默认 = YES
@property (nonatomic, assign) BOOL isPrintResponseOnError;
/// BaseURL
@property (nonatomic, strong) NSURL *baseURL;
/// 请求超时时间，默认 = 15s
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/// 响应值解析器
@property (nonatomic, strong) id<HJHttpResponseDecoder> responseDecoder;

+ (HJHttpTask *)enqueue:(HJHttpRequest *)req
                success:(HJHttpClientSingleSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure;

+ (HJHttpTask *)enqueueGroup:(HJHttpRequestGroup *)group
                     success:(HJHttpClientSuccessBlock)success
                     failure:(HJHttpClientFailureBlock)failure;

- (HJHttpTask *)enqueue:(HJHttpRequest *)req
                success:(HJHttpClientSingleSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure;

- (HJHttpTask *)enqueueGroup:(HJHttpRequestGroup *)group
                     success:(HJHttpClientSuccessBlock)success
                     failure:(HJHttpClientFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
