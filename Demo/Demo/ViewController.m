//
//  ViewController.m
//  Demo
//
//  Created by Haijun on 2019/5/10.
//  Copyright © 2019 Haijun. All rights reserved.
//

#import "ViewController.h"
#import "HJHTTPResponseDecoder.h"
#import "HJHTTPClient+Indicator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 单个请求
    HJHTTPRequest *req = [HJHTTPRequest GET:@"api/path" responseDataCls:nil];
    [HJHTTPClient enqueue:req hudView:self.view success:^(HJHTTPResponse * _Nonnull rep) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    // 多个请求
    HJHTTPRequestGroup *group = [HJHTTPRequestGroup group:^(HJHTTPRequestGroup * _Nonnull g) {
        [g add:[HJHTTPRequest new]];
        [g lazyAdd:^HJHTTPRequest * _Nonnull(NSArray<HJHTTPResponse *> * _Nonnull reps) {
            return [HJHTTPRequest new];
        }];
    }];
    [HJHTTPClient enqueueGroup:group hudView:self.view success:^(NSArray<HJHTTPResponse *> * _Nonnull reps) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


@end
