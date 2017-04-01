//
//  SearchResultsSongVC.m
//  数字版权交易系统
//
//  Created by 李剑 on 17/3/3.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import "SearchResultsSongVC.h"
#import "LJTabPagerVC.h"
#import "PlayingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FPSTableView.h"

#import "MusicEntity.h"

@interface SearchResultsSongVC () <LJTabPagerVCDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) FPSTableView *tableView;
@property (nonatomic) NSMutableArray *searchResults;

@property (nonatomic) UIImage *placeholderImage;

@end

@implementation SearchResultsSongVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResults: (NSData *)data {
    [self.searchResults removeAllObjects];
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *songsArray = response[@"results"];
    NSLog(@"%@", songsArray);
    for (NSDictionary *songDic in songsArray) {
        //NSNumber *musicId = songDic[@"trackId"];
        NSString *previewUrl = songDic[@"previewUrl"];
        NSString *name = songDic[@"trackName"];
        NSString *artist = songDic[@"artistName"];
        NSString *thumbnailCover = songDic[@"artworkUrl30"];
        NSString *cover = songDic[@"artworkUrl100"];
        [self.searchResults addObject:[[MusicEntity alloc] initWithMusicId:@0 name:name musicUrl:previewUrl cover:cover thumbnailCover:thumbnailCover artistName:artist fileName:nil isFavorited:NO]];
    }
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, -[LJTabPagerVC pagerTabBarHeight])];
    });
}

#pragma mark - LJTabPagerVCDelegate
- (void)hasBeenSelectedAndShown {
    NSLog(@"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊%s", __FUNCTION__);
    if (self.searchTerm != nil) {
        [self search];
    }
}

- (void)search {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *searchString = @"https://itunes.apple.com/search?media=music&entity=song&term=";
    searchString = [searchString stringByAppendingString:self.searchTerm];
    NSURL *url = [NSURL URLWithString:searchString];
    //NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/search?media=music&entity=song&term=swift"];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^(){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"error" message:@"Something went wrong!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^(){
                
            }];
        } else if (((NSHTTPURLResponse *)response).statusCode == 200){
            [self updateSearchResults: data];
        }
    }];
    [dataTask resume];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = ((MusicEntity *)self.searchResults[indexPath.row]).name;
    cell.detailTextLabel.text = ((MusicEntity *)self.searchResults[indexPath.row]).artistName;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:((MusicEntity *)self.searchResults[indexPath.row]).thumbnailCover] placeholderImage:self.placeholderImage];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayingViewController *playingVC = [PlayingViewController sharedInstance];
    playingVC.musicEntities = self.searchResults;
    playingVC.dontReloadMusic = NO;
    playingVC.currentIndex = indexPath.row;
    playingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playingVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - Accessor Methods
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[FPSTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];_tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setContentInset:UIEdgeInsetsMake([LJTabPagerVC pagerTabBarHeight], 0, 0, 0)];
    }
    return _tableView;
}

- (NSMutableArray *)searchResults {
    if (_searchResults == nil) {
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
}

- (UIImage *)placeholderImage {
    if (_placeholderImage == nil) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, [UIScreen mainScreen].scale);
        _placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _placeholderImage;
}



@end
