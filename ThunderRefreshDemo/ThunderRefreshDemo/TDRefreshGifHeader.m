//
//  TDRefreshGifHeader.m
//  ThunderRefreshDemo
//
//  Created by zhanggenning on 16/3/4.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "TDRefreshGifHeader.h"
#import "TDRefreshConst.h"

#import "UIView+Extension.h"

@interface TDRefreshGifHeader ()
{
    __unsafe_unretained UIImageView *_gifView;
}

/* 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;

/* 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation TDRefreshGifHeader

#pragma mark - 控件
- (UIImageView *)gifView
{
    if (!_gifView)
    {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(TDRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(TDRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 父类方法
- (void)prepare
{
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:TDRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:TDRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:TDRefreshStateRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    //布局状态标签
    CGFloat stateLabelH = 20;
    CGFloat stateLabelY = self.mj_h - stateLabelH - 5;
    self.stateLabel.frame = CGRectMake(0, stateLabelY, self.mj_w, stateLabelH);
    
    //布局gif动画
    CGFloat gifViewY = 5;
    CGFloat gifHeight = self.mj_h - self.stateLabel.mj_h - 5 - gifViewY;
    CGFloat gifWidht = gifHeight;
    self.gifView.frame = CGRectMake(0, gifViewY, gifWidht, gifHeight);
    
    CGPoint tempCenter = self.gifView.center;
    tempCenter.x = self.mj_w / 2;
    self.gifView.center = tempCenter;
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    NSArray *images = self.stateImages[@(TDRefreshStateIdle)];
    if (self.state != TDRefreshStateIdle || images.count == 0) return;
    
    //停止动画
    [self.gifView stopAnimating];
    
    //设置当前需要显示的图片
    NSUInteger index = images.count * pullingPercent;
    if (index >= images.count)
    {
        index = images.count - 1;
    }
    self.gifView.image = images[index];
}

- (void)setState:(TDRefreshState)state
{
    TDRefreshCheckState
    
    // 根据状态做事情
    if (state == TDRefreshStatePulling || state == TDRefreshStateRefreshing)
    {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) // 单张图片
        {
            self.gifView.image = [images lastObject];
        }
        else // 多张图片
        {
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    }
    else if (state == TDRefreshStateIdle)
    {
        [self.gifView stopAnimating];
    }
}
@end
