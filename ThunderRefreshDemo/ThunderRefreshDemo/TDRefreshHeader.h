//
//  TDRefreshHeader.h
//  ThunderRefreshDemo
//
//  Created by zhanggenning on 16/3/3.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "TDRefreshComponent.h"

@interface TDRefreshHeader : TDRefreshComponent

/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(TDRefreshComponentRefreshingBlock)refreshingBlock;

/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 这个key用来存储上一次下拉刷新成功的时间 */
@property (copy, nonatomic) NSString *lastUpdatedTimeKey;

/** 上一次下拉刷新成功的时间 */
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;

/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

#pragma mark -- 结束停留相关
@property (assign, nonatomic) BOOL needStayWhenEndRefresh; //结束刷新状态时需要停留

@property (assign, nonatomic) CGFloat stayHeight; //停留时距离底边的距离

@property (assign, nonatomic) CGFloat stayDuration; //停留时间

@property (copy, nonatomic) NSString *stayMessage; //停留信息

#pragma mark  -- 子类重载
- (void)doStartStayWhenEndRefresh;
- (void)doStopStayWhenEndRefresh;


@end
