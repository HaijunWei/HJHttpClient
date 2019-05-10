//
//  HJHTTPTask+Private.h
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHTTPTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHTTPTask (Private)

@property (nonatomic, assign, readwrite) HJHTTPTaskState state;
@property (nonatomic, assign, readwrite) double progress;

@end

NS_ASSUME_NONNULL_END
