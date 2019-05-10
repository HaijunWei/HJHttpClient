//
//  HJHTTPRequestGroup.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHTTPRequestGroup.h"

@interface HJHTTPRequestGroup ()

@property (nonatomic, strong) NSMutableArray *reqs;

@end

@implementation HJHTTPRequestGroup

- (instancetype)init {
    if (self = [super init]) {
        self.reqs = [NSMutableArray new];
    }
    return self;
}

- (void)add:(HJHTTPRequest *)req {
    [self.reqs addObject:req];
}

- (void)lazyAdd:(HJHTTPRequestLazyAddBlock)block {
    [self.reqs addObject:block];
}

- (NSArray *)requests {
    NSMutableArray *reqs = [NSMutableArray new];
    NSMutableArray *subReqs = nil;
    // 将请求分组
    for (id api in self.reqs) {
        if ([api isKindOfClass:[HJHTTPRequest class]]) {
            if (subReqs == nil) {
                subReqs = [NSMutableArray new];
                [reqs addObject:subReqs];
            }
            [subReqs addObject:api];
        } else {
            subReqs = [NSMutableArray new];
            [subReqs addObject:api];
            [reqs addObject:subReqs];
            subReqs = nil;
        }
    }
    return reqs;
}

@end
