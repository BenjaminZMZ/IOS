//
//  MusicEntity.h
//  Ting
//
//  Created by Aufree on 11/13/15.
//  Copyright © 2015 Ting. All rights reserved.
//

#import "BaseEntity.h"

typedef void(^GetMusicUrlComletionBlock)();
typedef void(^GetPicUrlComletionBlock)(NSString *picurl);

@interface MusicEntity : NSObject
@property (nonatomic) NSNumber *musicId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *filePath;

- (instancetype)initWithMusicId:(NSNumber *)musicId name:(NSString *)name  artistName:(NSString *)artistName albumName:(NSString *)albumName;

- (void)getMusicUrlWithCompletionBlock:(GetMusicUrlComletionBlock)completionBlock;
- (void)getPicUrlWithCompletionBlock:(GetPicUrlComletionBlock)completionBlock;
@end
