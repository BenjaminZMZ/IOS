//
//  Decode.m
//  数字版权交易系统
//
//  Created by 李剑 on 17/3/4.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import "Decode.h"

@interface Decode ()
@property (nonatomic) NSArray *array;
@property (nonatomic) NSString *resultString;
@end

@implementation Decode

- (instancetype)initWithArray: (NSString *)message {
    self = [super init];
    if (self != nil) {
        _array = [message componentsSeparatedByString:@","];
    }
    return self;
}

- (char)decodeWord: (NSString *)word {
    NSInteger intValue = [word integerValue];
    NSInteger random = sizeof(NSInteger) == 4 ? intValue & 0x0000FF00 : intValue & 0x000000000000FF00;
    random = random >> 8;
    NSInteger tail = sizeof(NSInteger) == 4 ? intValue & 0x000000FF : intValue & 0x00000000000000FF;
    NSInteger result = tail + random;
    result = ~result;
    result = sizeof(NSInteger) == 4 ? result & 0x000000FF : result & 0x00000000000000FF;
    char ch = (char)result;
    return ch;
}

- (NSString *)decodeString {
    for (NSString *str in self.array) {
        char ch[2];
        ch[0] = [self decodeWord:str];
        ch[1] = '\0';
        [self.resultString stringByAppendingString:[NSString stringWithCString:ch encoding:NSUTF8StringEncoding]];
    }
    NSMutableString *a = [[NSMutableString alloc] init];
    for (NSInteger i = self.resultString.length; i > 0; i--) {
        [a appendString:[self.resultString substringWithRange:NSMakeRange(i - 1, 1)]];
    }
    self.resultString = [NSString stringWithString:a];
    self.resultString = [NSString stringWithCString:self.resultString.UTF8String encoding:NSUnicodeStringEncoding];
    return self.resultString;
}

@end
