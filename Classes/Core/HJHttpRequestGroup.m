//
//  HJHttpRequestGroup.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHttpRequestGroup.h"

@interface HJHttpRequestGroup ()

@property (nonatomic, strong) NSMutableArray *reqs;

@end

@implementation HJHttpRequestGroup

#pragma mark - 便利方法

+ (instancetype)group:(void(^)(HJHttpRequestGroup *g))block {
    HJHttpRequestGroup *group = [HJHttpRequestGroup new];
    block(group);
    return group;
}

#pragma mark -

- (instancetype)init {
    if (self = [super init]) {
        self.reqs = [NSMutableArray new];
    }
    return self;
}

- (void)add:(HJHttpRequest *)req {
    [self.reqs addObject:req];
}

- (void)lazyAdd:(HJHttpRequestLazyAddBlock)block {
    [self.reqs addObject:block];
}

- (NSArray *)requests {
    NSMutableArray *reqs = [NSMutableArray new];
    NSMutableArray *subReqs = nil;
    // 将请求分组
    for (id api in self.reqs) {
        if ([api isKindOfClass:[HJHttpRequest class]]) {
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
