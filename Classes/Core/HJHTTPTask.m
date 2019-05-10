//
//  HJHTTPTask.m
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHTTPTask.h"
#import <objc/runtime.h>

@interface _HJHTTPWeakContainer : NSObject

@property (nonatomic, weak, readonly) id object;

- (instancetype)initWithObject:(id)object;

@end

@implementation _HJHTTPWeakContainer

- (instancetype)initWithObject:(id)object {
    if (self = [super init]) {
        _object = object;
    }
    return self;
}

@end

@interface NSObject (HJHTTPTask)

@property (nonatomic, strong) NSMutableArray *hj_httpTasks;

@end

@implementation NSObject (HJHTTPTask)

static char kHTTPTasks;

- (void)setHj_httpTasks:(NSMutableArray *)hj_httpTasks {
    objc_setAssociatedObject(self, &kHTTPTasks, hj_httpTasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)hj_httpTasks {
    NSMutableArray *httpTasks = objc_getAssociatedObject(self, &kHTTPTasks);
    if (!httpTasks) {
        httpTasks = [NSMutableArray new];
        [self setHj_httpTasks:httpTasks];
    }
    return httpTasks;
}

@end

@interface HJHTTPTask ()

@property (nonatomic, assign, readwrite) HJHTTPTaskState state;
@property (nonatomic, assign, readwrite) double progress;
@property (nonatomic, strong) NSMutableArray *observers;
@property (nonatomic, strong) NSMutableArray<id<HJHTTPTaskCancelable>> *tasks;

@end

@implementation HJHTTPTask

#pragma mark - Public

- (void)attachTo:(NSObject *)object {
    [self removeFromContainer];
    [object.hj_httpTasks addObject:self];
    __weak typeof(object) weakObject = object;
    self.removeFromContainerBlock = ^(HJHTTPTask * _Nonnull task) {
        [weakObject.hj_httpTasks removeObject:task];
    };
}

- (void)cancel {
    for (id<HJHTTPTaskCancelable> task in self.tasks) {
        [task cancel];
    }
    self.state = HJHTTPTaskStateNotRunning;
}

- (void)removeFromContainer {
    if (self.removeFromContainerBlock) {
        self.removeFromContainerBlock(self);
    }
}

#pragma mark - SubTask

- (void)addSubtask:(id<HJHTTPTaskCancelable>)task {
    [self.tasks addObject:task];
}

- (void)removeSubtask:(id<HJHTTPTaskCancelable>)task {
    [self.tasks removeObject:task];
}

#pragma mark - Observer

- (void)addObserver:(id<HJHTTPTaskObserver>)observer {
    [self addObserver:observer isWeakify:YES];
}

- (void)addObserver:(id<HJHTTPTaskObserver>)observer isWeakify:(BOOL)isWeakify {
    if (isWeakify) {
        _HJHTTPWeakContainer *weakContainer = [[_HJHTTPWeakContainer alloc] initWithObject:observer];
        [self.observers addObject:weakContainer];
    } else {
        [self.observers addObject:observer];
    }
    [observer taskDidUpdateState:self.state progress:self.progress];
}

- (void)removeObserver:(id<HJHTTPTaskObserver>)observer {
    [self.observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[_HJHTTPWeakContainer class]]) {
            _HJHTTPWeakContainer *weakContainer = obj;
            if (weakContainer.object == observer) { [self.observers removeObject:obj]; }
        } else {
            if (obj == observer) { [self.observers removeObject:obj]; }
        }
    }];
}

- (void)noticeObservers {
    for (id obj in self.observers) {
        if ([obj isKindOfClass:[_HJHTTPWeakContainer class]]) {
            _HJHTTPWeakContainer *weakContainer = obj;
            [(id<HJHTTPTaskObserver>)(weakContainer.object) taskDidUpdateState:self.state progress:self.progress];
        } else {
            [(id<HJHTTPTaskObserver>)obj taskDidUpdateState:self.state progress:self.progress];
        }
    }
}

#pragma mark - Override

- (instancetype)init {
    if (self = [super init]) {
        _tasks = [NSMutableArray array];
        _observers = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [self cancel];
}

#pragma mark - Setter

- (void)setState:(HJHTTPTaskState)state {
    _state = state;
    [self noticeObservers];
}

- (void)setProgress:(double)progress {
    _progress = progress;
    [self noticeObservers];
}

@end
