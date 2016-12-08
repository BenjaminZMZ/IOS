//
//  RecordPageViewController.h
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/6.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UIPageViewController

@property (nonatomic) NSInteger index;

- (void)setCoverWithURL:(NSURL *)url;
- (void)startRotating;
- (void)stopRotating;

@end
