//
//  GCDTimer.h
//  XYGCDTimer
//
//  Created by Mac on 2020/3/4.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDTimer : NSObject

// 开始
- (void)start;
// 暂停
- (void)supend;
// 继续
- (void)Continue;

- (instancetype)initWithTimeInterval:(NSInteger) TimeInterval block:(void (^)(NSInteger timerNum))block ;
 
@end

NS_ASSUME_NONNULL_END

@interface BYTimer : NSObject

+(BYTimer *_Nullable)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^_Nullable)(BYTimer * _Nullable timer))block;

/// 开始
-(void)resume;

/// 取消定时器
-(void)cancel;

@end
