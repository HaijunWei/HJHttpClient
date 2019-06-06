//
//  HJHttpActivityIndicator.h
//
//  Created by Haijun on 2019/5/10.
//

#import <UIKit/UIKit.h>
#import "HJHttpTask.h"
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HJHttpActivityConfigHUDBlock)(MBProgressHUD *hud);

@interface HJHttpActivityIndicator : NSObject <HJHttpTaskObserver>

@property (nonatomic, weak) UIView *hudView;

/// 配置HUD样式
@property (nonatomic, strong, class) HJHttpActivityConfigHUDBlock configHUDBlock;

@end

@interface HJHttpTask (HJIndicator)

/// 在指定view上显示hud
- (void)attachHUDTo:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
