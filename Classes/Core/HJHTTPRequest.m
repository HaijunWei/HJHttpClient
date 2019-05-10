//
//  HJNetworkRequest.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHTTPRequest.h"

@implementation HJHTTPRequest

#pragma mark - 便利方法

+ (instancetype)request:(NSString *)path method:(HJHTTPMethod)method {
    HJHTTPRequest *req = [HJHTTPRequest new];
    req.path = path;
    req.method = method;
    return req;
}

#pragma mark - Override

- (instancetype)init {
    if (self = [super init]) {
        _userInfo = [NSMutableDictionary new];
    }
    return self;
}

@end
