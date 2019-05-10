//
//  HJHTTPClient+Indicator.h
//
//  Created by Haijun on 2019/5/10.
//

#import <UIKit/UIKit.h>
#import "HJHTTPClient.h"
#import "HJHTTPActivityIndicator.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHTTPClient (Indicator)

+ (HJHTTPTask *)enqueue:(HJHTTPRequest *)req
                hudView:(UIView * _Nullable)hudView
                success:(HJHTTPClientSingleSuccessBlock)success
                failure:(HJHTTPClientFailureBlock)failure;

+ (HJHTTPTask *)enqueueGroup:(HJHTTPRequestGroup *)group
                     hudView:(UIView * _Nullable)hudView
                     success:(HJHTTPClientSuccessBlock)success
                     failure:(HJHTTPClientFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
