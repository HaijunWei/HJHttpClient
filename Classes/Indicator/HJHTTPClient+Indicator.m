//
//  HJHTTPClient+Indicator.m
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHTTPClient+Indicator.h"

@implementation HJHTTPClient (Indicator)

+ (HJHTTPTask *)enqueue:(HJHTTPRequest *)req
                hudView:(UIView *)hudView
                success:(HJHTTPClientSingleSuccessBlock)success
                failure:(HJHTTPClientFailureBlock)failure {
    HJHTTPTask *task = [self enqueue:req success:success failure:failure];
    [task attachHUDTo:hudView];
    return task;
}

+ (HJHTTPTask *)enqueueGroup:(HJHTTPRequestGroup *)group
                     hudView:(UIView *)hudView
                     success:(HJHTTPClientSuccessBlock)success
                     failure:(HJHTTPClientFailureBlock)failure {
    HJHTTPTask *task = [self enqueueGroup:group success:success failure:failure];
    [task attachHUDTo:hudView];
    return task;
}

@end
