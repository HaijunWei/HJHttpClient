//
//  HJHttpActivityIndicator.h
//
//  Created by Haijun on 2019/5/10.
//

#import <UIKit/UIKit.h>
#import "HJHttpTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHttpActivityIndicator : NSObject <HJHttpTaskObserver>

@property (nonatomic, weak) UIView *hudView;

@end

@interface HJHttpTask (HJIndicator)

/// 在指定view上显示hud
- (void)attachHUDTo:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
