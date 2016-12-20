//
//  LJThemeManager.h
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/10.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJPicker.h"

static NSString * const NormalTheme = @"NormalTheme";
static NSString * const NightTheme = @"NightTheme";
static NSString * const ThemeChangingNotification = @"ThemeChangingNotification";
static CGFloat const ThemeChangingAnimationDuration = 0.3;

@interface LJThemeManager : NSObject

+ (instancetype)sharedManager;
- (void)nightFalling;
- (void)dawnComming;

@property (nonatomic, copy) NSString *currentTheme;
@property (nonatomic) NSArray<NSString *> *themes;


@end
