//
//  HJHttpClient+Indicator.m
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHttpClient+Indicator.h"

@implementation HJHttpClient (Indicator)

+ (HJHttpTask *)enqueue:(HJHttpRequest *)req
                hudView:(UIView *)hudView
                success:(HJHttpClientSingleSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure {
    HJHttpTask *task = [self enqueue:req success:success failure:failure];
    [task attachHUDTo:hudView];
    return task;
}

+ (HJHttpTask *)enqueueGroup:(HJHttpRequestGroup *)group
                     hudView:(UIView *)hudView
                     success:(HJHttpClientSuccessBlock)success
                     failure:(HJHttpClientFailureBlock)failure {
    HJHttpTask *task = [self enqueueGroup:group success:success failure:failure];
    [task attachHUDTo:hudView];
    return task;
}

- (HJHttpTask *)enqueue:(HJHttpRequest *)req
                hudView:(UIView * _Nullable)hudView
                success:(HJHttpClientSingleSuccessBlock)success
                failure:(HJHttpClientFailureBlock)failure {
    HJHttpTask *task = [self enqueue:req success:success failure:failure];
    [task attachTo:hudView];
    return task;
}

- (HJHttpTask *)enqueueGroup:(HJHttpRequestGroup *)group
                     hudView:(UIView * _Nullable)hudView
                     success:(HJHttpClientSuccessBlock)success
                     failure:(HJHttpClientFailureBlock)failure {
    HJHttpTask *task = [self enqueueGroup:group success:success failure:failure];
    [task attachHUDTo:hudView];
    return task;
}

@end
