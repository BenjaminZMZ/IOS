//
//  MusicSearchResultsVCsource.h
//  数字版权交易系统
//
//  Created by 李剑 on 2017/8/27.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJTabPagerVC.h"

@interface MusicSearchResultsVCsource : NSObject <LJTabPagerVCsSource>
@property (nonatomic, copy) NSString *searchTerm;
@end
