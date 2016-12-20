//
//  NSObject+Theme.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/10.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "NSObject+Theme.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic) NSMutableDictionary *pickers;

@end

@implementation NSObject (Theme)

- (LJThemeManager *)themeManager
{
    return [LJThemeManager sharedManager];
}

- (NSMutableDictionary *)pickers
{
    NSMutableDictionary *pickers = objc_getAssociatedObject(self, @selector(pickers));
    if (!pickers)
    {
        pickers = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(pickers), pickers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ThemeChangingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme) name:ThemeChangingNotification object:nil];
    return pickers;
}

- (void)updateTheme
{
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, LJColorPicker _Nonnull picker, BOOL * _Nonnull stop){
        id result = picker(self.themeManager.currentTheme);
        SEL sel = NSSelectorFromString(selector);
        [UIView animateWithDuration:ThemeChangingAnimationDuration animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:sel withObject:result];
#pragma clang diagnostic pop
        }];
    }];
}

@end
