//
//  ViewController.m
//  Demo
//
//  Created by Haijun on 2019/5/10.
//  Copyright © 2019 Haijun. All rights reserved.
//

#import "ViewController.h"
#import "HJHttpResponseDecoder.h"
#import "HJHttpClient+Indicator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 单个请求
    HJHttpRequest *req = [HJHttpRequest GET:@"api/path" responseDataCls:nil];
    [HJHttpClient enqueue:req hudView:self.view success:^(HJHttpResponse * _Nonnull rep) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    // 多个请求
    HJHttpRequestGroup *group = [HJHttpRequestGroup group:^(HJHttpRequestGroup * _Nonnull g) {
        [g add:[HJHttpRequest new]];
        [g lazyAdd:^HJHttpRequest * _Nonnull(NSArray<HJHttpResponse *> * _Nonnull reps) {
            return [HJHttpRequest new];
        }];
    }];
    [HJHttpClient enqueueGroup:group hudView:self.view success:^(NSArray<HJHttpResponse *> * _Nonnull reps) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


@end
