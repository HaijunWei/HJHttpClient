//
//  HJHTTPClient.h
//
//  Created by Haijun on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import "HJHTTPRequest.h"
#import "HJHTTPTask.h"
#import "HJHTTPResponse.h"
#import "HJHTTPRequestGroup.h"
#import "HJHTTPResponseDecoder.h"
@class HJHTTPClient;

NS_ASSUME_NONNULL_BEGIN

typedef void(^HJHTTPClientSuccessBlock)(id rep);
typedef void(^HJHTTPClientFailureBlock)(NSError *error);

@protocol HJHTTPClientDelegate <NSObject>

@optional
/// 执行请求之前调用，可在此方法附加额外参数
- (HJHTTPRequest *)httpClient:(HJHTTPClient *)client prepareRequest:(HJHTTPRequest *)request;
/// 执行请求之前调用，可在此方法中给请求头附加参数
- (NSMutableURLRequest *)httpClient:(HJHTTPClient *)client prepareURLRequest:(NSMutableURLRequest *)request;
/// 请求发生错误，可自定义错误信息
- (NSError *)httpClient:(HJHTTPClient *)client request:(HJHTTPRequest *)request didReceiveError:(NSError *)error;

@end

@interface HJHTTPClient : NSObject

+ (instancetype)shared;

@property (nonatomic, weak) id<HJHTTPClientDelegate> delegate;
/// 是否打印日志，默认 = YES
@property (nonatomic, assign) BOOL isPrintLog;
/// BaseURL
@property (nonatomic, strong) NSURL *baseURL;
/// 请求超时时间，默认 = 15s
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/// 响应值解析器
@property (nonatomic, strong) id<HJHTTPResponseDecoder> responseDecoder;

+ (HJHTTPTask *)enqueue:(id)req
                success:(HJHTTPClientSuccessBlock)success
                failure:(HJHTTPClientFailureBlock)failure;

+ (HJHTTPTask *)enqueueGroup:(void(^)(HJHTTPRequestGroup *group))block
                     success:(HJHTTPClientSuccessBlock)success
                     failure:(HJHTTPClientFailureBlock)failure;

- (HJHTTPTask *)enqueue:(id)req
                success:(HJHTTPClientSuccessBlock)success
                failure:(HJHTTPClientFailureBlock)failure;

- (HJHTTPTask *)enqueueGroup:(void(^)(HJHTTPRequestGroup *group))block
                     success:(HJHTTPClientSuccessBlock)success
                     failure:(HJHTTPClientFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
