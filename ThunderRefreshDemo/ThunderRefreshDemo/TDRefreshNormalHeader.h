//
//  TDRefreshNormalHeader.h
//  ThunderRefreshDemo
//
//  Created by zhanggenning on 16/3/3.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "TDRefreshStateHeader.h"

@interface TDRefreshNormalHeader : TDRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *arrowView;

/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end
