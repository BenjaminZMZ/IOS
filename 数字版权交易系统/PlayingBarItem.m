//
//  PlayingBarItem.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/27.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "PlayingBarItem.h"

@implementation PlayingBarItem

+ (instancetype)playingBarItem
{
    PlayingBarItem *playingBarItem;
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 6; i++)
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"cm2_topbar_icn_playing%d", i]]];
    for (int i = 5; i > 1; i--)
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"cm2_topbar_icn_playing%d", i]]];
    
    UIImageView *playingBarItemView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_topbar_icn_playing1"]];
    playingBarItemView.animationImages = [NSArray arrayWithArray:imageArray];
    playingBarItemView.animationDuration = 0.8;
    
    playingBarItem = [[PlayingBarItem alloc] initWithCustomView:playingBarItemView];
    [playingBarItemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:playingBarItem action:@selector(playingItemTapped)]];
    [playingBarItemView startAnimating];
    return playingBarItem;
}

+ (instancetype)sharedInstance
{
    static PlayingBarItem *playingBarItem;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 6; i++)
            [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"cm2_topbar_icn_playing%d", i]]];
        for (int i = 5; i > 1; i--)
            [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"cm2_topbar_icn_playing%d", i]]];
        
        UIImageView *playingBarItemView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_topbar_icn_playing1"]];
        playingBarItemView.animationImages = [NSArray arrayWithArray:imageArray];
        playingBarItemView.animationDuration = 0.8;
        [playingBarItemView startAnimating];
        
        playingBarItem = [[PlayingBarItem alloc] initWithCustomView:playingBarItemView];
        [playingBarItemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:playingBarItem action:@selector(playingItemTapped)]];
    });
    
    return playingBarItem;
}

- (void)playingItemTapped
{
    NSLog(@"playingItemTapped");
    [self.delegate playingBarItemTapped];
}

@end
