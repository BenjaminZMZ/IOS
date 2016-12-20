//
//  UIView+Theme.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/10.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "UIView+Theme.h"
#import <objc/runtime.h>
#import "NSObject+Theme.h"

@interface UIView ()

@property (nonatomic) NSMutableDictionary *pickers;

@end

@implementation UIView (Theme)

- (LJColorPicker)bkColorPicker
{
    return objc_getAssociatedObject(self, @selector(bkColorPicker));
}

- (void)setBkColorPicker:(LJColorPicker)bkColorPicker
{
    objc_setAssociatedObject(self, @selector(bkColorPicker), bkColorPicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.backgroundColor = bkColorPicker(self.themeManager.currentTheme);
    [self.pickers setValue:[bkColorPicker copy] forKey:@"setBackgroundColor:"];
}

@end
