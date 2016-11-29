//
//  DecorationView.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/28.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "DecorationView.h"
#import "Macro.h"

@implementation DecorationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backgroundColorWhite;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
