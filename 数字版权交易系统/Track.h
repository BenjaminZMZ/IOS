//
//  Track.h
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/1.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"

@interface Track : NSObject<DOUAudioFile>

@property (nonatomic, strong) NSURL *audioFileURL;
@property (nonatomic, strong) NSURL *tempFileURL;
@property (nonatomic, strong) NSURL *cacheFileURL;

@end
