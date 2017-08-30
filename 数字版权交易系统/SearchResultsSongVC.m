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

#define TABBAR_HEIGHT 49

const NSString *MUSIC_API_HOST = @"http://116.196.100.188:3000/";

@interface SearchResultsSongVC () <LJTabPagerVCDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *searchResults;

@property (nonatomic) UIImage *placeholderImage;

@end

@implementation SearchResultsSongVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.tableView}]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResults: (NSData *)data {
    [self.searchResults removeAllObjects];
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *songsArray = response[@"result"][@"songs"];
    NSLog(@"%@", songsArray);
    for (NSDictionary *songDic in songsArray) {
        NSNumber *musicId = songDic[@"id"];
        NSString *name = songDic[@"name"];
        NSString *artists = [self artistsNameFromArray: songDic[@"artists"]];
        NSString *albumName = songDic[@"album"][@"name"];
        [self.searchResults addObject:[[MusicEntity alloc] initWithMusicId:musicId name:name artistName:artists albumName:albumName]];
    }
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.tableView reloadData];
        //[self.tableView setContentOffset:CGPointMake(0, -[LJTabPagerVC pagerTabBarHeight])];
        //[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:5];
    });
}

- (NSString *)artistsNameFromArray:(NSArray *)array {
    NSMutableString *artistsName = [@"" mutableCopy];
    for (NSDictionary *dic in array) {
        if ([array indexOfObject:dic] != array.count-1)
            [artistsName appendFormat:@"%@//", dic[@"name"]];
        else
            [artistsName appendFormat:@"%@", dic[@"name"]];
    }
    return [NSString stringWithString:artistsName];
}

#pragma mark - LJTabPagerVCDelegate
- (void)hasBeenSelectedAndShown:(NSNumber *)firstShown {
    BOOL _firstShown = [firstShown boolValue];
    if (_firstShown && self.searchTerm != nil)
        [self search];
}

- (void)search {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *searchString = [NSString stringWithFormat:@"%@search?keywords=%@&limit=20&type=1&offset=0", MUSIC_API_HOST, self.searchTerm];
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
    MusicEntity *music = self.searchResults[indexPath.row];
    cell.textLabel.text = music.name;
    NSString *artists = music.artistName;
    NSString *album = music.albumName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", artists, album];
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
        NSLog(@"*****%@", NSStringFromCGRect(self.view.frame));
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setContentInset:UIEdgeInsetsMake([LJTabPagerVC pagerTabBarHeight], 0, TABBAR_HEIGHT, 0)];
        _tableView.delaysContentTouches = NO;
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
