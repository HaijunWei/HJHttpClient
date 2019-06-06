//
//  HJHttpActivityIndicator.m
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHttpActivityIndicator.h"

@interface HJHttpActivityIndicator ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HJHttpActivityIndicator

#pragma mark - Class Property

static HJHttpActivityConfigHUDBlock _configHUDBlock = nil;

+ (void)setConfigHUDBlock:(HJHttpActivityConfigHUDBlock)configHUDBlock {
    _configHUDBlock = configHUDBlock;
}

+ (HJHttpActivityConfigHUDBlock)configHUDBlock {
    return _configHUDBlock;
}

#pragma mark - HJHttpTaskObserver

- (void)taskDidUpdateState:(HJHttpTaskState)state progress:(double)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case HJHttpTaskStateNotRunning:
                [self.hud hideAnimated:YES];
                break;
            case HJHttpTaskStateLoading:
                self.hud.mode = MBProgressHUDModeIndeterminate;
                break;
            case HJHttpTaskStateProgress:
                self.hud.mode = MBProgressHUDModeDeterminate;
                self.hud.progress = progress;
                self.hud.detailsLabel.text = @"上传中...";
                break;
        }
    });
}

#pragma mark - Getter

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.hudView];
        _hud.removeFromSuperViewOnHide = YES;
        [self.hudView addSubview:_hud];
        [self.hud showAnimated:YES];
        if (_configHUDBlock) { _configHUDBlock(_hud); }
    }
    return _hud;
}

@end

@implementation HJHttpTask (HJIndicator)

- (void)attachHUDTo:(UIView *)view {
    if (!view) { return; }
    HJHttpActivityIndicator *indicator = [HJHttpActivityIndicator new];
    indicator.hudView = view;
    [self addObserver:indicator isWeakify:NO];
}

@end
