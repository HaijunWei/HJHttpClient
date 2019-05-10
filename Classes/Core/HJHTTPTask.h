//
//  HJHTTPTask.h
//
//  Created by Haijun on 2019/5/10.
//

#import <Foundation/Foundation.h>
@class HJHTTPTask;

NS_ASSUME_NONNULL_BEGIN

@protocol HJHTTPTaskCancelable <NSObject>

- (void)cancel;

@end

@interface NSURLSessionTask (HJHTTPTaskCancelable)<HJHTTPTaskCancelable>
@end

typedef NS_ENUM(NSInteger, HJHTTPTaskState) {
    /* 尚未运行 */
    HJHTTPTaskStateNotRunning,
    /* 请求数据中 */
    HJHTTPTaskStateLoading,
    /* 请求数据中，可监听进度 */
    HJHTTPTaskStateProgress,
};

@protocol HJHTTPTaskObserver <NSObject>

- (void)taskDidUpdateState:(HJHTTPTaskState)state progress:(double)progress;

@end

@interface HJHTTPTask : NSObject<HJHTTPTaskCancelable>

/// 状态
@property (nonatomic, assign, readonly) HJHTTPTaskState state;
/// 进度
@property (nonatomic, assign, readonly) double progress;
/// 从强引用容器中移除实现block
@property (nonatomic, copy) void(^removeFromContainerBlock)(HJHTTPTask *task);

/// 添加观察者，观察者对象为弱引用，observer发出通知不一定都在主线程，需根据情况使用
- (void)addObserver:(id<HJHTTPTaskObserver>)observer;

/**
 添加观察者

 @param observer 观察者
 @param isWeakify 是否弱引用
 */
- (void)addObserver:(id<HJHTTPTaskObserver>)observer isWeakify:(BOOL)isWeakify;
/// 移除观察者
- (void)removeObserver:(id<HJHTTPTaskObserver>)observer;

/// 添加子任务
- (void)addSubtask:(id<HJHTTPTaskCancelable>)task;
/// 移除子任务
- (void)removeSubtask:(id<HJHTTPTaskCancelable>)task;

/// 从强引用容器中移除
- (void)removeFromContainer;

/// 将生命周期绑定到指定对象
- (void)attachTo:(NSObject *)object;

@end

NS_ASSUME_NONNULL_END
