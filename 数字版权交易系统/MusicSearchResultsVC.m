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

@interface MusicSearchResultsVC ()

@end

@implementation MusicSearchResultsVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        SearchResultsSongVC *controller1 = [[SearchResultsSongVC alloc] init];
        controller1.title = @"单曲";
        SearchResultsSingerVC *controller2 = [[SearchResultsSingerVC alloc] init];
        controller2.title = @"歌手";
        UITableViewController *controller3 = [[UITableViewController alloc] init];
        controller3.title = @"专辑";
        UITableViewController *controller4 = [[UITableViewController alloc] init];
        controller4.title = @"歌单";
        UITableViewController *controller5 = [[UITableViewController alloc] init];
        controller5.title = @"MV";
        UITableViewController *controller6 = [[UITableViewController alloc] init];
        controller6.title = @"主播电台";
        UITableViewController *controller7 = [[UITableViewController alloc] init];
        controller7.title = @"用户";
        
        self.viewControllers = @[controller1, controller2, controller3, controller4, controller5, controller6, controller7];
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
    for (UIViewController *controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(searchTerm)]) {
            [controller setValue:self.searchTerm forKey:@"searchTerm"];
        }
    }
    SearchResultsBaseVC *selectedController = self.viewControllers[self.selectedIndex];
    [selectedController search];
}

@end
