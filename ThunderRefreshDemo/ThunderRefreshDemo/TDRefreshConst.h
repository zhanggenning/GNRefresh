//
//  TDRefreshConst.h
//  ThunderRefreshDemo
//
//  Created by zhanggenning on 16/3/3.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

// 运行时objc_msgSend
#define TDRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define TDRefreshMsgTarget(target) (__bridge void *)(target)

// 常量
UIKIT_EXTERN const CGFloat TDRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat TDRefreshFooterHeight;
UIKIT_EXTERN const CGFloat TDRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat TDRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const TDRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const TDRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const TDRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const TDRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const TDRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const TDRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const TDRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const TDRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const TDRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const TDRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const TDRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const TDRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const TDRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const TDRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const TDRefreshBackFooterNoMoreDataText;

// 状态检查
#define TDRefreshCheckState \
TDRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];