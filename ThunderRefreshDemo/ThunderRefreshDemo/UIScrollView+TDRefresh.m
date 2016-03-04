//
//  UIScrollView+TDRefresh.m
//  ThunderRefreshDemo
//
//  Created by zhanggenning on 16/3/3.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "UIScrollView+TDRefresh.h"
#import <objc/runtime.h>
#import "TDRefreshHeader.h"
#import "TDRefreshFooter.h"
#import "TDRefreshNormalHeader.h"
#import "TDRefreshGifHeader.h"
#import "TDRefreshNormalFooter.h"

@implementation NSObject (MJRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (TDRefresh)
#pragma mark - header
static const char TDRefreshHeaderKey = '\0';
- (void)setHeader:(TDRefreshHeader *)header
{
    if (header != self.header) {
        // 删除旧的，添加新的
        [self.header removeFromSuperview];
        [self insertSubview:header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"header"]; // KVO
        objc_setAssociatedObject(self, &TDRefreshHeaderKey,
                                 header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"header"]; // KVO
    }
}

- (TDRefreshHeader *)header
{
    return objc_getAssociatedObject(self, &TDRefreshHeaderKey);
}

#pragma mark - footer
static const char TDRefreshFooterKey = '\0';
- (void)setFooter:(TDRefreshFooter *)footer
{
    if (footer != self.footer) {
        // 删除旧的，添加新的
        [self.footer removeFromSuperview];
        [self addSubview:footer];
        
        // 存储新的
        [self willChangeValueForKey:@"footer"]; // KVO
        objc_setAssociatedObject(self, &TDRefreshFooterKey,
                                 footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"footer"]; // KVO
    }
}

- (TDRefreshFooter *)footer
{
    return objc_getAssociatedObject(self, &TDRefreshFooterKey);
}

#pragma mark - headerIsAdded
static const char TDRefreshHeaderAddedKey = '\0';
- (BOOL)headerIsAdded
{
    return [objc_getAssociatedObject(self, &TDRefreshHeaderAddedKey) boolValue];
}

- (void)setHeaderIsAdded:(BOOL)headerIsAdded
{
    [self willChangeValueForKey:@"TDRefreshHeaderAddedKey"];
    objc_setAssociatedObject(self, &TDRefreshHeaderAddedKey,
                             @(headerIsAdded),
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"TDRefreshHeaderAddedKey"];
}

#pragma mark - footerIsAdded
static const char TDRefreshFooterAddedKey = '\0';
- (BOOL)footerIsAdded
{
    return [objc_getAssociatedObject(self, &TDRefreshFooterAddedKey) boolValue];
}

- (void)setFooterIsAdded:(BOOL)footerIsAdded
{
    [self willChangeValueForKey:@"TDRefreshFooterAddedKey"];
    objc_setAssociatedObject(self, &TDRefreshFooterAddedKey,
                             @(footerIsAdded),
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"TDRefreshFooterAddedKey"];
}


#pragma mark -- header相关接口
- (void)addHeaderWithCallback:(void (^)())callback
{
    if (!self.header)
    {
        self.header = [TDRefreshGifHeader headerWithRefreshingBlock:callback];
    }
    self.headerIsAdded = YES;
}

- (void)addHeaderWithTarget:(id)target action:(SEL)action
{
    if (!self.header)
    {
        self.header = [TDRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    }
    self.headerIsAdded = YES;
}

- (void)removeHeader
{
    [self.header removeFromSuperview];
    self.header = nil;
    
    self.headerIsAdded = NO;
}

- (void)headerBeginRefreshing
{
    [self.header beginRefreshing];
}


- (void)headerEndRefreshing
{
    [self.header endRefreshing];
}

- (void)setHeaderHidden:(BOOL)hidden
{
    self.header.hidden = hidden;
}

- (BOOL)isHeaderHidden
{
    return self.header.isHidden;
}

- (BOOL)isHeaderRefreshing
{
    return self.header.isRefreshing;
}

#pragma mark -- footer相关接口

- (void)addFooterWithCallback:(void (^)())callback
{
    if (!self.footer)
    {
        self.footer = [TDRefreshNormalFooter footerWithRefreshingBlock:callback];
    }
    self.footerIsAdded = YES;
}


- (void)addFooterWithTarget:(id)target action:(SEL)action
{
    if (!self.footer)
    {
        self.footer = [TDRefreshNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    }
    self.footerIsAdded = YES;
}


- (void)removeFooter
{
    [self.footer removeFromSuperview];
    self.footer = nil;
    
    self.footerIsAdded = NO;
}


- (void)footerBeginRefreshing
{
    [self.footer beginRefreshing];
}


- (void)footerEndRefreshing
{
    [self.footer endRefreshing];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setFooterHidden:(BOOL)hidden
{
    self.footer.hidden = hidden;
}

- (BOOL)isFooterHidden
{
    return self.footer.isHidden;
}

- (BOOL)isFooterRefreshing
{
    return self.footer.isRefreshing;
}

#pragma mark -- other
- (NSInteger)totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char TDRefreshReloadDataBlockKey = '\0';
- (void)setReloadDataBlock:(void (^)(NSInteger))reloadDataBlock
{
    [self willChangeValueForKey:@"reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &TDRefreshReloadDataBlockKey, reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))reloadDataBlock
{
    return objc_getAssociatedObject(self, &TDRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.reloadDataBlock ? : self.reloadDataBlock(self.totalDataCount);
}

@end


@implementation UITableView (MJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(td_reloadData)];
}

- (void)td_reloadData
{
    [self td_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (MJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(td_reloadData)];
}

- (void)td_reloadData
{
    [self td_reloadData];
    
    [self executeReloadDataBlock];
}
@end