//
//  XZViewController.m
//  sildeShow
//
//  Created by wzz on 15/11/24.
//  Copyright © 2015年 wzz. All rights reserved.
//

#import "XZViewController.h"

@interface XZViewController ()
@property(nonatomic,weak)UIImageView *bkgView;

@property(nonatomic,weak)UIView *coverView;

@property(nonatomic,weak)UIImageView *fView;

@property(nonatomic,assign)CGPoint prePoint;
@end

@implementation XZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupSubView {
    
    UIImageView *bgkView = [[UIImageView alloc] init];
    bgkView.frame = self.view.bounds;
    [self.view addSubview:bgkView];
    bgkView.image = [UIImage imageNamed:@"1.png"];
    self.bkgView = bgkView;
    
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = self.view.bounds;
    self.coverView = coverView;
    coverView.clipsToBounds = YES;
    [self.view addSubview:coverView];
    
    
    UIImageView *fView = [[UIImageView alloc] init];
    fView.frame = self.view.bounds;
    fView.userInteractionEnabled = YES;
    fView.image = [UIImage imageNamed:@"2.png"];
    self.fView = fView;
//    fView.clipsToBounds = YES;
    [coverView addSubview:fView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 记录上一个点
    UITouch *touch = [touches anyObject];
    self.prePoint = [touch locationInView:self.view];

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    // 获取当前触摸的点
    CGPoint point = [touch locationInView:self.view];

    // 如果有上一个点
    
    CGFloat offerset = point.x - self.prePoint.x;

    // 判断是从右往左，还是从左往右 delta < 0表示往左边拖动
    
    if (offerset < 0 && self.coverView.frame.origin.x > 0) {
        
        self.coverView.frame = [self changFrameX:self.coverView.frame WithoffesetX:offerset];
        
    } else {
        self.coverView.frame = [self changFrameW:self.coverView.frame WithOffersetW:offerset];
    }
    
    if (self.coverView.frame.size.width > self.view.frame.size.width) {
        CGFloat width = self.coverView.frame.size.width - self.view.frame.size.width;
        CGRect rect = self.coverView.frame;
        rect.size.width = self.view.frame.size.width;
        self.coverView.frame = rect;
        //移动
       self.coverView.frame = [self changFrameX:self.coverView.frame WithoffesetX:width];
    }
    // 设置当前点为上一个带你
    self.prePoint = point;
    
    // 判断显示上一张图片还是下一张图片
//    NSLog(@"%lf",self.coverView.frame.origin.x);
    if (self.coverView.frame.origin.x > 0) {
        //显示上一张
        self.bkgView.image = [UIImage imageNamed:@"4.png"];
        
        // 移动背景view的origin.x
        self.bkgView.frame =[self changFrameX:self.bkgView.frame WithoffesetXTWO: - self.view.frame.size.width * 0.5 + self.coverView.frame.origin.x * 0.5];
    } else if (self.coverView.frame.size.width < self.view.frame.size.width) {
        
        // 显示下一张
        self.bkgView.image = [UIImage imageNamed:@"3.png"];
        // 移动背景view的origin.x
        self.bkgView.frame = [self changFrameX:self.bkgView.frame WithoffesetXTWO:self.view.frame.size.width * 0.5 - (self.view.frame.size.width - self.coverView.frame.size.width) * 0.5];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 判断frame.width 是否小于屏幕宽度，小于就做动画回去
    if (self.coverView.frame.size.width < self.view.frame.size.width) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = self.view.frame;
            rect.size.width = self.view.frame.size.width;
            self.coverView.frame = rect;
        }];
    }
    
    if (self.coverView.frame.origin.x > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.coverView.frame;
            frame.origin.x = 0;
            self.coverView.frame = frame;
        }];
    }
    
}

- (CGRect)changFrameX:(CGRect)frame WithoffesetXTWO:(CGFloat)offerset {
    
    
    return CGRectMake(offerset, frame.origin.y, frame.size.width, frame.size.height);
}

- (CGRect)changFrameX:(CGRect)frame WithoffesetX:(CGFloat)offerset {
    
    frame.origin.x += offerset;
    return frame;
}

- (CGRect)changFrameW:(CGRect)frame WithOffersetW:(CGFloat)offset {
    
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + offset, frame.size.height);
}


@end
