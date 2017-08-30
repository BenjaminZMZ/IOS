//
//  MusicSearchResultsVC.m
//  数字版权交易系统
//
//  Created by 李剑 on 17/3/2.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import "MusicSearchResultsVC.h"
#import "SearchResultsSongVC.h"
#import "SearchResultsSingerVC.h"
#import "MusicSearchResultsVCsource.h"

@interface MusicSearchResultsVC ()

@property (nonatomic) MusicSearchResultsVCsource *msrVcsSource;

@end

@implementation MusicSearchResultsVC
@synthesize msrVcsSource = _msrVcsSource;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _msrVcsSource = [[MusicSearchResultsVCsource alloc] init];
        self.vcsSource = _msrVcsSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

#pragma mark - Accessor Methods

- (void)setSearchTerm:(NSString *)searchTerm {
    _searchTerm = searchTerm;
    if ([self.vcsSource respondsToSelector:@selector(setSearchTerm:)]) {
        [self.vcsSource performSelector:@selector(setSearchTerm:) withObject:searchTerm];
    }
}

@end
