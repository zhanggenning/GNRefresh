//
//  TDRefreshConst.m
//  ThunderRefreshDemo
//
//  Created by zhanggenning on 16/3/3.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import <UIKit/UIKit.h>

const CGFloat TDRefreshHeaderHeight = 80.0;
const CGFloat TDRefreshFooterHeight = 44.0;
const CGFloat TDRefreshFastAnimationDuration = 0.25;
const CGFloat TDRefreshSlowAnimationDuration = 0.4;

NSString *const TDRefreshKeyPathContentOffset = @"contentOffset";
NSString *const TDRefreshKeyPathContentInset = @"contentInset";
NSString *const TDRefreshKeyPathContentSize = @"contentSize";
NSString *const TDRefreshKeyPathPanState = @"state";

NSString *const TDRefreshHeaderLastUpdatedTimeKey = @"TDRefreshHeaderLastUpdatedTimeKey";

NSString *const TDRefreshHeaderIdleText = @"下拉可以刷新";
NSString *const TDRefreshHeaderPullingText = @"松开立即刷新";
NSString *const TDRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString *const TDRefreshAutoFooterIdleText = @"点击或上拉加载更多";
NSString *const TDRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString *const TDRefreshAutoFooterNoMoreDataText = @"已经全部加载完毕";

NSString *const TDRefreshBackFooterIdleText = @"上拉可以加载更多";
NSString *const TDRefreshBackFooterPullingText = @"松开立即加载更多";
NSString *const TDRefreshBackFooterRefreshingText = @"正在加载更多的数据...";
NSString *const TDRefreshBackFooterNoMoreDataText = @"已经全部加载完毕";
