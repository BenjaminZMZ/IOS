//
//  PlayingViewController.h
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/29.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOUAudioStreamer.h"

@interface PlayingViewController : UIViewController

@property (nonatomic) DOUAudioStreamer *streamer;
@property (nonatomic) NSMutableArray *musicEntities;
@property (nonatomic) BOOL dontReloadMusic;
@property (nonatomic) NSInteger currentIndex;

+ (instancetype)sharedInstance;

@end
