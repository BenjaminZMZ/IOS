//
//  Decode.h
//  数字版权交易系统
//
//  Created by 李剑 on 17/3/4.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Decode : NSObject
- (instancetype)initWithArray: (NSString *)message;
- (NSString *)decodeString;
@end
