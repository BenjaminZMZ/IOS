//
//  SearchResultsSingerVC.m
//  数字版权交易系统
//
//  Created by 李剑 on 17/3/15.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import "SearchResultsSingerVC.h"
#import "LJTabPagerVC.h"
#import "SingerEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FPSTableView.h"

@interface SearchResultsSingerVC () <UITableViewDelegate, UITableViewDataSource, LJTabPagerVCDelegate>

@property (nonatomic) FPSTableView *tableView;
@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) UIImage *placeholderImage;

@end

@implementation SearchResultsSingerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)search {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *baseUrl = @"https://itunes.apple.com/search?media=music&entity=musicArtist&term=";
    NSString *searchString = [baseUrl stringByAppendingString:self.searchTerm];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [defaultSession dataTaskWithURL:[NSURL URLWithString:searchString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        if (error != nil) {
            
        } else if (((NSHTTPURLResponse *)response).statusCode == 200){
            [self updateSearchResults: data];
        }
    }];
    [task resume];
}

- (void)updateSearchResults:(NSData *)data {
    [self.searchResults removeAllObjects];
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", responseDic);
    NSArray *singerArray = responseDic[@"results"];
    for (NSDictionary *singerDic in singerArray) {
        SingerEntity *singer = [[SingerEntity alloc] init];
        singer.singerName = singerDic[@"artistName"];
        singer.singerDetailUrl = singerDic[@"artistLinkUrl"];
        [self.searchResults addObject:singer];
    }
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, -[LJTabPagerVC pagerTabBarHeight])];
    });
}

#pragma mark - LJTabPagerVCDelegate

- (void)hasBeenSelectedAndShown {
    [self search];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingerCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SingerCell"];
    }
    SingerEntity *singer = (SingerEntity *)self.searchResults[indexPath.row];
    cell.textLabel.text = singer.singerName;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString: singer.singerAvatarUrl] placeholderImage:self.placeholderImage];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITableViewDelegate


#pragma mark - Accessor Methods

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[FPSTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setContentInset:UIEdgeInsetsMake([LJTabPagerVC pagerTabBarHeight], 0, 0, 0)];
    }
    return _tableView;
}

- (UIImage *)placeholderImage {
    if (_placeholderImage == nil) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0);
        _placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _placeholderImage;
}


- (NSMutableArray *)searchResults {
    if (_searchResults == nil) {
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
}

@end
