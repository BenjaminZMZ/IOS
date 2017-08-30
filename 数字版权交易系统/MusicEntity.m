//
//  MusicEntity.m
//  Ting
//
//  Created by Aufree on 11/13/15.
//  Copyright © 2015 Ting. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MusicEntity.h"
extern NSString *MUSIC_API_HOST;
@implementation MusicEntity

- (instancetype)initWithMusicId:(NSNumber *)musicId name:(NSString *)name  artistName:(NSString *)artistName albumName:(NSString *)albumName {
    self = [super init];
    if (self != nil) {
        self.musicId = musicId;
        self.name = name;
        self.artistName = artistName;
        self.albumName = albumName;
    }
    return self;
}

- (void)getMusicUrlWithCompletionBlock:(GetMusicUrlComletionBlock)completionBlock {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *musicurlTask = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@music/url?id=%@", MUSIC_API_HOST, self.musicId]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (error != nil) {
            ;
        } else if (((NSHTTPURLResponse *)response).statusCode == 200){
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.musicUrl = response[@"data"][0][@"url"];
            dispatch_async(dispatch_get_main_queue(), completionBlock);
        }
    }];
    [musicurlTask resume];
}
- (void)getPicUrlWithCompletionBlock:(GetPicUrlComletionBlock)completionBlock {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *picurlTask = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@song/detail?ids=%@", MUSIC_API_HOST, self.musicId]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (error != nil) {
            ;
        } else if (((NSHTTPURLResponse *)response).statusCode == 200){
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.picUrl = response[@"songs"][0][@"al"][@"picUrl"];
            //completionBlock();
            NSString *imgurl = [self.picUrl copy];
            dispatch_async(dispatch_get_main_queue(), ^(){
                completionBlock(imgurl);
            });
        }
    }];
    [picurlTask resume];
}
@end
