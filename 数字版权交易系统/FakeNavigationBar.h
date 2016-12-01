//
//  FakeNavigationBar.h
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/30.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FakeNavigationBar : UIView

@property (nonatomic) UIBarButtonItem *fakeRightBarButtonItem;
@property (nonatomic) UIBarButtonItem *fakeLeftBarButtonItem;
@property (nonatomic) UIView *fakeTitleView;
@property (nonatomic) UIColor *fakeBackgroundColor;
@property (nonatomic) UIColor *fakeBarTintColor;
@property (nonatomic) UIColor *fakeTintColor;
@property (nonatomic) BOOL fakeTranslucent;

@property(nonatomic, copy) NSDictionary<NSString *,id> *fakeTitleTextAttributes;
@property(nonatomic, copy) NSString *fakeTitle;

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics;
- (void)setTransparent:(BOOL)isTransparent;
@end
