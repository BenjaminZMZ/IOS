//
//  MusicEntity.h
//  Ting
//
//  Created by Aufree on 11/13/15.
//  Copyright © 2015 Ting. All rights reserved.
//

#import "BaseEntity.h"

@interface MusicEntity : BaseEntity
@property (nonatomic, copy) NSNumber *musicId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *thumbnailCover;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) BOOL isFavorited;

- (instancetype)initWithMusicId: (NSNumber *)musicId name: (NSString *)name musicUrl: (NSString *)musicUrl cover: (NSString *)cover thumbnailCover: (NSString *)thumbnailCover artistName: (NSString *)artistName fileName: (NSString *)fileName isFavorited: (BOOL)isFavorited;
@end
