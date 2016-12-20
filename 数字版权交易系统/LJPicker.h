//
//  LJPicker.h
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/10.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef UIColor *(^LJColorPicker)(NSString *);
typedef UIImage *(^LJImagePicker)(NSString *);

LJColorPicker colorPickerWithColors(UIColor *color, ...);
@interface LJPicker : NSObject

@end
