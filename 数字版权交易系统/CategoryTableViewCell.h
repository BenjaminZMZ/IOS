//
//  CategoryTableViewCell.h
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/1.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *number;
@property (nonatomic) UIImage *iconImage;

- (void)configureWithIcon:(UIImage *)icon title:(NSString *)title number:(NSString *)number;

@end
