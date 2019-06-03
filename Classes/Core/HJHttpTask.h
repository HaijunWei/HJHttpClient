//
//  HJHttpTask.h
//
//  Created by Haijun on 2019/5/10.
//

#import <Foundation/Foundation.h>
@class HJHttpTask;

NS_ASSUME_NONNULL_BEGIN

@protocol HJHttpTaskCancelable <NSObject>

- (void)cancel;

@end

@interface NSURLSessionTask (HJHttpTaskCancelable)<HJHttpTaskCancelable>
@end

typedef NS_ENUM(NSInteger, HJHttpTaskState) {
    /* 尚未运行 */
    HJHttpTaskStateNotRunning,
    /* 请求数据中 */
    HJHttpTaskStateLoading,
    /* 请求数据中，可监听进度 */
    HJHttpTaskStateProgress,
};

@protocol HJHttpTaskObserver <NSObject>

- (void)taskDidUpdateState:(HJHttpTaskState)state progress:(double)progress;

@end

@interface HJHttpTask : NSObject<HJHttpTaskCancelable>

/// 状态
@property (nonatomic, assign, readonly) HJHttpTaskState state;
/// 进度
@property (nonatomic, assign, readonly) double progress;
/// 从强引用容器中移除实现block
@property (nonatomic, copy) void(^removeFromContainerBlock)(HJHttpTask *task);

/// 添加观察者，观察者对象为弱引用，observer发出通知不一定都在主线程，需根据情况使用
- (void)addObserver:(id<HJHttpTaskObserver>)observer;

/**
 添加观察者

 @param observer 观察者
 @param isWeakify 是否弱引用
 */
- (void)addObserver:(id<HJHttpTaskObserver>)observer isWeakify:(BOOL)isWeakify;
/// 移除观察者
- (void)removeObserver:(id<HJHttpTaskObserver>)observer;

/// 添加子任务
- (void)addSubtask:(id<HJHttpTaskCancelable>)task;
/// 移除子任务
- (void)removeSubtask:(id<HJHttpTaskCancelable>)task;

/// 从强引用容器中移除
- (void)removeFromContainer;

/// 将生命周期绑定到指定对象
- (void)attachTo:(NSObject *)object;

@end

NS_ASSUME_NONNULL_END
