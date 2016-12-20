//
//  LJThemeManager.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/10.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "LJThemeManager.h"

static NSString * const UserDefaultsCurrentThemeKey = @"UserDefaultsCurrentThemeKey";


@implementation LJThemeManager

+ (instancetype)sharedManager
{
    static LJThemeManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LJThemeManager alloc] init];
        NSString *theme = [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultsCurrentThemeKey];
        if (!theme)
        {
            theme = NormalTheme;
        }
        sharedInstance.currentTheme = theme;
        sharedInstance.themes = @[NormalTheme, NightTheme];
    });
    
    return sharedInstance;
}

- (void)nightFalling
{
    self.currentTheme = NightTheme;
}

- (void)dawnComming
{
    self.currentTheme = NormalTheme;
}

- (void)setCurrentTheme:(NSString *)currentTheme
{
    if (![_currentTheme isEqualToString:currentTheme])
    {
        _currentTheme = currentTheme;
        [[NSUserDefaults standardUserDefaults] setValue:currentTheme forKey:UserDefaultsCurrentThemeKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:ThemeChangingNotification object:nil];
    }
}

- (void)setThemes:(NSArray<NSString *> *)themes
{
    NSParameterAssert(themes);
    _themes = themes;
}

@end
