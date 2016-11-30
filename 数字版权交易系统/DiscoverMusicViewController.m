//
//  DiscoverMusicViewController.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/25.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "DiscoverMusicViewController.h"
#import "PlayingBarItem.h"
#import "PlayingViewController.h"
#import "Macro.h"

@interface DiscoverMusicViewController ()<PlayingBarItemDelegate>

@end

@implementation DiscoverMusicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [PlayingBarItem sharedInstance];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [PlayingBarItem sharedInstance];
    [PlayingBarItem sharedInstance].delegate = self;
    NSLog(@"%s", __FUNCTION__);
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBar];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)configureNavigationBar
{
    self.navigationController.navigationBar.barTintColor = THEME_COLOR_RED;
    self.navigationController.navigationBar.tintColor = NAVBAR_TINT_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"搜索音乐、歌词、电台";
    self.navigationItem.titleView = searchBar;
    
    //self.navigationItem.rightBarButtonItem = [PlayingBarItem playingBarItem];
    //self.navigationItem.rightBarButtonItem = [PlayingBarItem sharedInstance];
}

#pragma mark - PlayingBarItemDelegate
- (void)playingBarItemTapped
{
    PlayingViewController *controller = [[PlayingViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
    //self.tabBarController.tabBar.hidden = YES;
}

@end
