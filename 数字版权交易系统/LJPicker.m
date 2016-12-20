//
//  LJPicker.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/10.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "LJPicker.h"
#import "LJThemeManager.h"

@implementation LJPicker
LJColorPicker colorPickerWithColors(UIColor *color, ...)
{
    NSArray *themes = [LJThemeManager sharedManager].themes;
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:themes.count];
    [colors addObject:color];
    NSUInteger num = themes.count - 1;
    va_list colorList;
    va_start(colorList, color);
    for (NSUInteger i = 0; i < num; i++)
    {
        UIColor *color = va_arg(colorList, UIColor *);
        [colors addObject:color];
    }
    va_end(colorList);
    return ^(NSString *theme){
        NSUInteger index = [themes indexOfObject:theme];
        return colors[index];
    };
}
@end
