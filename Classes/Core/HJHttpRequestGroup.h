//
//  HJHttpRequestGroup.h
//
//  Created by Haijun on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import "HJHttpRequest.h"
@class HJHttpResponse;

NS_ASSUME_NONNULL_BEGIN

typedef HJHttpRequest *_Nonnull (^HJHttpRequestLazyAddBlock)(NSArray<HJHttpResponse *> *reps);

@interface HJHttpRequestGroup : NSObject

+ (instancetype)group:(void(^)(HJHttpRequestGroup *g))block;

- (void)add:(HJHttpRequest *)req;
- (void)lazyAdd:(HJHttpRequestLazyAddBlock)block;

@end

NS_ASSUME_NONNULL_END
