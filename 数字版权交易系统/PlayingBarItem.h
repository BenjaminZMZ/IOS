//
//  PlayingBarItem.h
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/27.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayingBarItemDelegate <NSObject>

- (void)playingBarItemTapped;

@end

@interface PlayingBarItem : UIBarButtonItem

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<PlayingBarItemDelegate> delegate;

+ (instancetype)playingBarItem;

@end
