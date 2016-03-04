//
//  TDRefreshNormalFooter.m
//  ThunderRefreshDemo
//
//  Created by zhanggenning on 16/3/3.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "TDRefreshNormalFooter.h"
#import "UIView+Extension.h"
#import "TDRefreshConst.h"

@interface TDRefreshNormalFooter ()
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation TDRefreshNormalFooter
#pragma mark - 懒加载子控件
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}

#pragma makr - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    
    // 圈圈
    CGFloat loadingCenterX = self.mj_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        loadingCenterX -= 100;
    }
    CGFloat loadingCenterY = self.mj_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

- (void)setState:(TDRefreshState)state
{
    TDRefreshCheckState
    
    // 根据状态做事情
    if (state == TDRefreshStateNoMoreData || state == TDRefreshStateIdle)
    {
        [self.loadingView stopAnimating];
    }
    else if (state == TDRefreshStateRefreshing)
    {
        [self.loadingView startAnimating];
    }
}


@end
