//
//  GCDTimer.m
//  XYGCDTimer
//
//  Created by Mac on 2020/3/4.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer()

@property (nonatomic,assign)NSInteger timeInterval;
@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, copy) void(^block)(NSInteger timerNum);
@property (nonatomic) BOOL isRunning;
@end

@implementation GCDTimer

- (instancetype)initWithTimeInterval:(NSInteger) TimeInterval block:(void (^)(NSInteger timerNum))block{
    if (self == [super init]) {
        
        self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        self.queue = dispatch_queue_create("com.tz.cn.cooci", 0);
        self.isRunning = YES;
        self.timeInterval = TimeInterval;
        self.block = block;
        
        // 保存代码块 ---> 异步 dispatch_source_set_event_handler()
        // 设置取消回调 dispatch_source_set_cancel_handler(dispatch_source_t source,dispatch_block_t _Nullable handler)
        // 封装我们需要回调的触发函数 -- 响应
        
        dispatch_source_set_event_handler(self.source, ^{
          //  NSUInteger value = dispatch_source_get_data(self.source); // 取回来值 1 响应式
            self.timeInterval -= 1;
            if ( self.timeInterval == 0) {
                [self supend];
            }
            block(self.timeInterval);
        });
        
        dispatch_resume(self.source);
        
        dispatch_source_set_cancel_handler(self.source, ^{
            NSLog(@"---- %d",__LINE__);
        });
    }
    return self;
}


// 开始
- (void)start{
    dispatch_async(self.queue, ^{
        if (!self.isRunning) {
            NSLog(@"暂停下载");
            return ;
        }
        dispatch_source_set_timer(self.source, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 0);
    });
}

// 继续
- (void)Continue{
    dispatch_resume(self.source);
    dispatch_resume(self.queue);
    self.isRunning = YES;
}

// 暂停
- (void)supend{
    dispatch_suspend(self.source);
    dispatch_suspend(self.queue);// mainqueue 挂起
    self.isRunning = NO;
    
}

@end

 

@interface BYTimer ()

@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic) BOOL isRunning;
@property (copy, nonatomic) NSTimer *timer;

@property (copy, nonatomic)  void(^complateBlock)(BYTimer *timer);

@property (assign, nonatomic) NSTimeInterval timeInterval;

@end
@implementation BYTimer

+(BYTimer *_Nullable)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^_Nullable)(BYTimer * _Nullable timer))block{

    BYTimer *timer = [[self alloc]init];
    timer.isRunning     = NO;
    timer.timeInterval = timeInterval;
    timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_main_queue());

    uint64_t interval = (uint64_t)(timeInterval * NSEC_PER_SEC);
    dispatch_source_set_timer(timer.source, DISPATCH_TIME_NOW, interval, 0);

    dispatch_source_set_event_handler(timer.source, ^{

        if (block) {
            block(timer);
        }
    });

    return timer;
}

/// 开始/暂停
-(void)resume{
    if (self.isRunning) {//开始
        self.isRunning = NO;
        dispatch_suspend(self.source);
    }else{//暂停
        self.isRunning = YES;
        dispatch_resume(self.source);
    }
}

-(void)cancel{//取消

    if (!self.isRunning) {
        dispatch_resume(self.source);
    }
    dispatch_source_cancel(self.source);
}

@end

