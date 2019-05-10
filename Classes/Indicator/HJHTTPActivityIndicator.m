//
//  HJHTTPActivityIndicator.m
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHTTPActivityIndicator.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface HJHTTPActivityIndicator ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HJHTTPActivityIndicator

#pragma mark - HJHTTPTaskObserver

- (void)taskDidUpdateState:(HJHTTPTaskState)state progress:(double)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case HJHTTPTaskStateNotRunning:
                [self.hud hideAnimated:YES];
                break;
            case HJHTTPTaskStateLoading:
                self.hud.mode = MBProgressHUDModeIndeterminate;
                break;
            case HJHTTPTaskStateProgress:
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
    }
    return _hud;
}

@end

@implementation HJHTTPTask (HJIndicator)

- (void)attachHUDTo:(UIView *)view {
    HJHTTPActivityIndicator *indicator = [HJHTTPActivityIndicator new];
    indicator.hudView = view;
    [self addObserver:indicator isWeakify:NO];
}

@end
