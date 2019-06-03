//
//  HJHttpTask.m
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHttpTask.h"
#import <objc/runtime.h>

@interface _HJHttpWeakContainer : NSObject

@property (nonatomic, weak, readonly) id object;

- (instancetype)initWithObject:(id)object;

@end

@implementation _HJHttpWeakContainer

- (instancetype)initWithObject:(id)object {
    if (self = [super init]) {
        _object = object;
    }
    return self;
}

@end

@interface NSObject (HJHttpTask)

@property (nonatomic, strong) NSMutableArray *hj_httpTasks;

@end

@implementation NSObject (HJHttpTask)

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

@interface HJHttpTask ()

@property (nonatomic, assign, readwrite) HJHttpTaskState state;
@property (nonatomic, assign, readwrite) double progress;
@property (nonatomic, strong) NSMutableArray *observers;
@property (nonatomic, strong) NSMutableArray<id<HJHttpTaskCancelable>> *tasks;

@end

@implementation HJHttpTask

#pragma mark - Public

- (void)attachTo:(NSObject *)object {
    [self removeFromContainer];
    [object.hj_httpTasks addObject:self];
    __weak typeof(object) weakObject = object;
    self.removeFromContainerBlock = ^(HJHttpTask * _Nonnull task) {
        [weakObject.hj_httpTasks removeObject:task];
    };
}

- (void)cancel {
    for (id<HJHttpTaskCancelable> task in self.tasks) {
        [task cancel];
    }
    self.state = HJHttpTaskStateNotRunning;
}

- (void)removeFromContainer {
    if (self.removeFromContainerBlock) {
        self.removeFromContainerBlock(self);
    }
}

#pragma mark - SubTask

- (void)addSubtask:(id<HJHttpTaskCancelable>)task {
    [self.tasks addObject:task];
}

- (void)removeSubtask:(id<HJHttpTaskCancelable>)task {
    [self.tasks removeObject:task];
}

#pragma mark - Observer

- (void)addObserver:(id<HJHttpTaskObserver>)observer {
    [self addObserver:observer isWeakify:YES];
}

- (void)addObserver:(id<HJHttpTaskObserver>)observer isWeakify:(BOOL)isWeakify {
    if (isWeakify) {
        _HJHttpWeakContainer *weakContainer = [[_HJHttpWeakContainer alloc] initWithObject:observer];
        [self.observers addObject:weakContainer];
    } else {
        [self.observers addObject:observer];
    }
    [observer taskDidUpdateState:self.state progress:self.progress];
}

- (void)removeObserver:(id<HJHttpTaskObserver>)observer {
    [self.observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[_HJHttpWeakContainer class]]) {
            _HJHttpWeakContainer *weakContainer = obj;
            if (weakContainer.object == observer) { [self.observers removeObject:obj]; }
        } else {
            if (obj == observer) { [self.observers removeObject:obj]; }
        }
    }];
}

- (void)noticeObservers {
    for (id obj in self.observers) {
        if ([obj isKindOfClass:[_HJHttpWeakContainer class]]) {
            _HJHttpWeakContainer *weakContainer = obj;
            [(id<HJHttpTaskObserver>)(weakContainer.object) taskDidUpdateState:self.state progress:self.progress];
        } else {
            [(id<HJHttpTaskObserver>)obj taskDidUpdateState:self.state progress:self.progress];
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

- (void)setState:(HJHttpTaskState)state {
    _state = state;
    [self noticeObservers];
}

- (void)setProgress:(double)progress {
    _progress = progress;
    [self noticeObservers];
}

@end
