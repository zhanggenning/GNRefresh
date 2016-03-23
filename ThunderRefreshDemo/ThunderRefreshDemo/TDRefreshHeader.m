//
//  TDRefreshHeader.m
//  ThunderRefreshDemo
//
//  Created by zhanggenning on 16/3/3.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "TDRefreshHeader.h"
#import "TDRefreshConst.h"

#import "UIView+Extension.h"
#import "UIScrollView+Extension.h"

@interface TDRefreshHeader ()
@property (assign, nonatomic) CGFloat insetTDelta;
@end

@implementation TDRefreshHeader
#pragma mark - 构造方法
+ (instancetype)headerWithRefreshingBlock:(TDRefreshComponentRefreshingBlock)refreshingBlock
{
    TDRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    TDRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置key
    self.lastUpdatedTimeKey = TDRefreshHeaderLastUpdatedTimeKey;
    
    // 设置高度
    self.mj_h = TDRefreshHeaderHeight;
    
    // 设置结束停留
    self.needStayWhenEndRefresh = NO;
    self.stayHeight = 30.0;
    self.stayDuration = 3.0;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 在刷新的refreshing状态
    if (self.state == TDRefreshStateRefreshing)
    {
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = MAX(- self.scrollView.mj_offsetY, _scrollViewOriginalInset.top);
        insetT = MIN(self.mj_h + _scrollViewOriginalInset.top, insetT);
        self.scrollView.mj_insetT = insetT;
        
        if (_needStayWhenEndRefresh)
        {
            self.insetTDelta = -(self.scrollView.mj_insetT - _stayHeight - _scrollViewOriginalInset.top);
        }
        else
        {
            self.insetTDelta =  - (insetT - _scrollViewOriginalInset.top);
        }
        
        NSLog(@"%f, %f, %f, %f", insetT, _scrollViewOriginalInset.top, -self.scrollView.mj_offsetY, self.insetTDelta);
        
        return;
    }
    else if (self.state == TDRefreshStateIdle && self.scrollView.mj_insetT != _scrollViewOriginalInset.top)
    {
        if (self.scrollView.isDragging && -self.scrollView.mj_offsetY != self.scrollView.mj_insetT) //拖拽中
        {
            [self doStopStayWhenEndRefresh];
            [[self class] cancelPreviousPerformRequestsWithTarget:self];
            
            if (-self.scrollView.mj_offsetY > self.scrollView.mj_insetT) //向下拽
            {
                CGFloat temp = self.scrollView.mj_insetT;
                self.scrollView.mj_insetT = _scrollViewOriginalInset.top;
                self.scrollView.mj_offsetY = -temp;
                self.insetTDelta = 0;
            }
            else //向上推
            {
                [self resetScrollViewInset]; //直接回去
            }
        }
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;

    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    
    if (self.scrollView.isDragging) // 如果正在拖拽
    {
        self.pullingPercent = pullingPercent;
        if (self.state == TDRefreshStateIdle && offsetY < normal2pullingOffsetY)
        {
            // 转为即将刷新状态
            self.state = TDRefreshStatePulling;
        }
        else if (self.state == TDRefreshStatePulling && offsetY >= normal2pullingOffsetY)
        {
            // 转为普通状态
            self.state = TDRefreshStateIdle;
        }
    }
    else if (self.state == TDRefreshStatePulling) // 即将刷新 && 手松开
    {
        // 开始刷新
        [self beginRefreshing];
    }
    else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)setState:(TDRefreshState)state
{
    TDRefreshCheckState
    
    // 根据状态做事情
    if (state == TDRefreshStateIdle)
    {
        if (oldState != TDRefreshStateRefreshing) return;
        
        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 恢复inset和offset
//        [UIView animateWithDuration:TDRefreshSlowAnimationDuration animations:^{
//            self.scrollView.mj_insetT += self.insetTDelta;
//            
//            // 自动调整透明度
//            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            self.pullingPercent = 0.0;
//        }];
        
        self.scrollView.scrollEnabled = NO;
        [UIView animateWithDuration:TDRefreshSlowAnimationDuration animations:^{
            self.scrollView.mj_insetT += self.insetTDelta;
            self.scrollView.mj_offsetY = (-self.scrollView.mj_insetT);
        } completion:^(BOOL finished) {
            self.scrollView.scrollEnabled = YES;
            if (self.scrollView.mj_insetT != 0)
            {
                [self doStartStayWhenEndRefresh];
                
                [self performSelector:@selector(resetScrollViewInset) withObject:nil afterDelay:_stayDuration];
            }
        }];
        
    }
    else if (state == TDRefreshStateRefreshing)
    {
        [UIView animateWithDuration:TDRefreshFastAnimationDuration animations:^{
            // 增加滚动区域
            CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
            self.scrollView.mj_insetT = top;
            
            // 设置滚动位置
            self.scrollView.mj_offsetY = - top;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}

- (void)resetScrollViewInset
{
    self.scrollView.scrollEnabled = NO;
    [UIView animateWithDuration:TDRefreshFastAnimationDuration animations:^{
        self.scrollView.mj_insetT = _scrollViewOriginalInset.top;
        self.scrollView.mj_offsetY = -self.scrollView.mj_insetT;
    } completion:^(BOOL finished) {
        self.scrollView.scrollEnabled = YES;
        self.insetTDelta = 0;
        [self doStopStayWhenEndRefresh];
    }];
}

#pragma mark - 子类继承
- (void)doStartStayWhenEndRefresh {};
- (void)doStopStayWhenEndRefresh {};

#pragma mark - 公共方法
- (void)endRefreshing
{
    if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super endRefreshing];
        });
    } else {
        [super endRefreshing];
    }
}

- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}

@end
