//
//  FakeNavigationBar.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/30.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "FakeNavigationBar.h"
#import "Macro.h"

@interface FakeNavigationBar ()

@property (nonatomic) UINavigationBar *fakeBar;
@property (nonatomic) UIView *statusView;

@end

@implementation FakeNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.alpha = 0;
        self.frame = CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight + kStatusBarHeight);
        [self addSubview:self.fakeBar];
        [self addSubview:self.statusView];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
    [self.fakeBar setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
}

- (void)setTransparent:(BOOL)isTransparent
{
    if (isTransparent)
    {
        [self.fakeBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.statusView.alpha = 0;
    }
    else
    {
        [self.fakeBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.statusView.alpha = 1;
    }
}

#pragma mark - Accessor Methods
- (UINavigationBar *)fakeBar
{
    if (_fakeBar == nil)
    {
        _fakeBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kNavigationBarHeight)];
        UINavigationItem *item = [[UINavigationItem alloc] init];
        [_fakeBar setItems:@[item]];
    }
    
    return _fakeBar;
}

- (UIView *)statusView
{
    if (_statusView == nil)
    {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarHeight)];
    }
    
    return _statusView;
}

- (void)setFakeRightBarButtonItem:(UIBarButtonItem *)fakeRightBarButtonItem
{
    _fakeRightBarButtonItem = fakeRightBarButtonItem;
    
    UINavigationItem *item = self.fakeBar.items[0];
    item.rightBarButtonItem = fakeRightBarButtonItem;
    [self.fakeBar setItems:@[item]];
}

- (void)setFakeLeftBarButtonItem:(UIBarButtonItem *)fakeLeftBarButtonItem
{
    _fakeLeftBarButtonItem = fakeLeftBarButtonItem;
    
    UINavigationItem *item = self.fakeBar.items[0];
    item.leftBarButtonItem = fakeLeftBarButtonItem;
    [self.fakeBar setItems:@[item]];
}

- (void)setFakeTitleView:(UIView *)fakeTitleView
{
    _fakeTitleView = fakeTitleView;
    
    UINavigationItem *item = self.fakeBar.items[0];
    item.titleView = fakeTitleView;
    [self.fakeBar setItems:@[item]];
}

- (void)setFakeBackgroundColor:(UIColor *)fakeBackgroundColor
{
    _fakeBackgroundColor = fakeBackgroundColor;
    
    //self.backgroundColor = fakeBackgroundColor;
    self.fakeBar.backgroundColor = fakeBackgroundColor;
    self.statusView.backgroundColor = fakeBackgroundColor;
}

- (void)setFakeTintColor:(UIColor *)fakeTintColor
{
    _fakeTintColor = fakeTintColor;
    
    self.fakeBar.tintColor = fakeTintColor;
}

- (void)setFakeBarTintColor:(UIColor *)fakeBarTintColor
{
    _fakeBarTintColor = fakeBarTintColor;
    
    self.fakeBar.barTintColor = fakeBarTintColor;
    self.statusView.backgroundColor = fakeBarTintColor;
}

- (void)setFakeTranslucent:(BOOL)fakeTranslucent
{
    _fakeTranslucent = fakeTranslucent;
    
    self.fakeBar.translucent = fakeTranslucent;
}

- (void)setFakeTitleTextAttributes:(NSDictionary<NSString *,id> *)fakeTitleTextAttributes
{
    _fakeTitleTextAttributes = fakeTitleTextAttributes;
    
    self.fakeBar.titleTextAttributes = fakeTitleTextAttributes;
}

- (void)setFakeTitle:(NSString *)fakeTitle
{
    _fakeTitle = fakeTitle;
    
    UINavigationItem *item = self.fakeBar.items[0];
    item.title = fakeTitle;
    [self.fakeBar setItems:@[item]];
}

@end
