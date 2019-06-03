//
//  HJHttpTask+Private.h
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHttpTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHttpTask (Private)

@property (nonatomic, assign, readwrite) HJHttpTaskState state;
@property (nonatomic, assign, readwrite) double progress;

@end

NS_ASSUME_NONNULL_END
