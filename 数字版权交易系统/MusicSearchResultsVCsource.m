//
//  MusicSearchResultsVCsource.m
//  数字版权交易系统
//
//  Created by 李剑 on 2017/8/27.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import "MusicSearchResultsVCsource.h"
#import "SearchResultsSongVC.h"
#import "SearchResultsSingerVC.h"

@implementation MusicSearchResultsVCsource

- (NSInteger)numberOfViewControllers {
    return 7;
}

- (NSArray *)titles {
    NSArray *titles = [NSArray arrayWithObjects:@"单曲", @"歌手", @"专辑", @"歌单", @"MV", @"主播电台", @"用户", nil];
    return titles;
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    SearchResultsBaseVC *viewController;
    if (index == 0){
        viewController = [[SearchResultsSongVC alloc] init];
    } else if (index == 1) {
        viewController = [[SearchResultsSingerVC alloc] init];
    } else {
        viewController = [[SearchResultsBaseVC alloc] init];
    }
    viewController.searchTerm = self.searchTerm;
    return viewController;
}

@end
