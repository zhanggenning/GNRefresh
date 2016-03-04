//
//  TDRefreshStateFooter.m
//  ThunderRefreshDemo
//
//  Created by zhanggenning on 16/3/3.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "TDRefreshStateFooter.h"
#import "TDRefreshConst.h"

#import "UIView+Extension.h"
#import "UIScrollView+Extension.h"

@interface TDRefreshStateFooter ()
{
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation TDRefreshStateFooter
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(TDRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 私有方法
- (void)stateLabelClick
{
    if (self.state == TDRefreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    [self setTitle:TDRefreshAutoFooterIdleText forState:TDRefreshStateIdle];
    [self setTitle:TDRefreshAutoFooterRefreshingText forState:TDRefreshStateRefreshing];
    [self setTitle:TDRefreshAutoFooterNoMoreDataText forState:TDRefreshStateNoMoreData];
    
    // 监听label
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(TDRefreshState)state
{
    TDRefreshCheckState
    
    if (self.isRefreshingTitleHidden && state == TDRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}

@end
