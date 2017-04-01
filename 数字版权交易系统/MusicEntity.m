//
//  MusicEntity.m
//  Ting
//
//  Created by Aufree on 11/13/15.
//  Copyright © 2015 Ting. All rights reserved.
//

#import "MusicEntity.h"

@implementation MusicEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"musicId" : @"id",
             @"name" : @"title",
             @"cover" : @"pic",
             @"artistName" : @"artist",
             @"musicUrl" : @"music_url",
             @"fileName" : @"file_name"
             };
}

- (instancetype)initWithMusicId:(NSNumber *)musicId name:(NSString *)name musicUrl:(NSString *)musicUrl cover:(NSString *)cover thumbnailCover: (NSString *)thumbnailCover artistName:(NSString *)artistName fileName:(NSString *)fileName isFavorited:(BOOL)isFavorited {
    self = [super init];
    if (self != nil) {
        self.musicId = musicId;
        self.name = name;
        self.musicUrl = musicUrl;
        self.cover = cover;
        self.thumbnailCover = thumbnailCover;
        self.artistName = artistName;
        self.fileName = fileName;
        self.isFavorited = isFavorited;
    }
    return self;
}

@end
