//
//  SearchResultsBaseVC.h
//  数字版权交易系统
//
//  Created by 李剑 on 17/3/15.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsBaseVC : UIViewController

@property (nonatomic, copy) NSString *searchTerm;
- (void)search;

@end
