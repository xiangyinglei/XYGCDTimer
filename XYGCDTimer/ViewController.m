//
//  ViewController.m
//  XYGCDTimer
//
//  Created by Mac on 2020/3/4.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"
#import "GCDTimer.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic)GCDTimer *gcdTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GCDTimer *gcdTimer = [[GCDTimer alloc]initWithTimeInterval:60 block:^(NSInteger timerNum) {
        [self.button setTitle:[NSString stringWithFormat:@"倒计时：%ld 秒",timerNum] forState:UIControlStateNormal];
    }];
    self.gcdTimer = gcdTimer;
    
//    [BYTimer timerWithTimeInterval:60 block:^(BYTimer *timer) {
//
//    }];
}

// 开始
- (IBAction)beginBtnClick:(UIButton *)sender {
    
    [self.gcdTimer start];
}

// 暂停
- (IBAction)supendClick:(UIButton *)sender {
      [self.gcdTimer supend];
}

// 继续
- (IBAction)continueClick:(UIButton *)sender {
         [self.gcdTimer Continue];
}




@end
