//
//  HJHttpClient+Indicator.h
//
//  Created by Haijun on 2019/5/10.
//

#import <UIKit/UIKit.h>
#import "HJHttpClient.h"
#import "HJHttpActivityIndicator.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHttpClient (Indicator)

+ (HJHttpTask *)enqueue:(HJHttpRequest *)req
                hudView:(UIView * _Nullable)hudView
                success:(HJHttpClientSingleSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure;

+ (HJHttpTask *)enqueueGroup:(HJHttpRequestGroup *)group
                     hudView:(UIView * _Nullable)hudView
                     success:(HJHttpClientSuccessBlock)success
                     failure:(HJHttpClientFailureBlock)failure;

- (HJHttpTask *)enqueue:(HJHttpRequest *)req
                hudView:(UIView * _Nullable)hudView
                success:(HJHttpClientSingleSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure;

- (HJHttpTask *)enqueueGroup:(HJHttpRequestGroup *)group
                     hudView:(UIView * _Nullable)hudView
                     success:(HJHttpClientSuccessBlock)success
                     failure:(HJHttpClientFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
