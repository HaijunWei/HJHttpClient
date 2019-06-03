//
//  HJNetworkRequest.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHttpRequest.h"

@implementation HJHttpRequest

#pragma mark - 便利方法

+ (instancetype)request:(NSString *)path method:(HJHttpMethod)method {
    HJHttpRequest *req = [HJHttpRequest new];
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
