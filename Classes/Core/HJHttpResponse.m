//
//  HJHttpResponse.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHttpResponse.h"

@implementation HJHttpResponse

- (instancetype)init {
    if (self = [super init]) {
        _userInfo = [NSMutableDictionary new];
    }
    return self;
}

@end
