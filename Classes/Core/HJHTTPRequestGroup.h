//
//  HJHTTPRequestGroup.h
//
//  Created by Haijun on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import "HJHTTPRequest.h"
@class HJHTTPResponse;

NS_ASSUME_NONNULL_BEGIN

typedef HJHTTPRequest *_Nonnull (^HJHTTPRequestLazyAddBlock)(NSArray<HJHTTPResponse *> *reps);

@interface HJHTTPRequestGroup : NSObject

- (void)add:(HJHTTPRequest *)req;
- (void)lazyAdd:(HJHTTPRequestLazyAddBlock)block;

@end

NS_ASSUME_NONNULL_END
