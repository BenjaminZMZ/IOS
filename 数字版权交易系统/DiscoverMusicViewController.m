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
#import "FakeNavigationBar.h"
#import "Macro.h"

#import "LJThemeSwitcher.h"

@interface DiscoverMusicViewController ()<PlayingBarItemDelegate>

@property (nonatomic) FakeNavigationBar *fakeBar;

@end

@implementation DiscoverMusicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    self.fakeBar.fakeRightBarButtonItem = nil;
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    [PlayingBarItem sharedInstance].delegate = self;
//    NSLog(@"%s", __FUNCTION__);
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBar];
    self.view.bkColorPicker = colorPickerWithColors([UIColor whiteColor], [UIColor blackColor], [UIColor blueColor]);
    //self.view.backgroundColor = [UIColor blackColor];
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

- (void)addFakeNavigationBar
{
    UINavigationBar *fakeBar = [[UINavigationBar alloc] init];
    fakeBar.backgroundColor = [UIColor blueColor];
    fakeBar.frame = CGRectMake(0, -44, kScreenWidth, 64);
    fakeBar.layer.zPosition = 100;
    [self.view addSubview:fakeBar];
}

- (void)configureNavigationBar
{
//    self.navigationController.navigationBar.barTintColor = THEME_COLOR_RED;
//    self.navigationController.navigationBar.tintColor = NAVBAR_TINT_COLOR;
//    self.navigationController.navigationBar.translucent = NO;
//    
//    UISearchBar *searchBar = [[UISearchBar alloc] init];
//    searchBar.placeholder = @"搜索音乐、歌词、电台";
//    self.navigationItem.titleView = searchBar;
    self.fakeBar.fakeBarTintColor = THEME_COLOR_RED;
    self.fakeBar.fakeTintColor = NAVBAR_TINT_COLOR;
    self.fakeBar.fakeTranslucent = NO;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"搜索音乐、歌词、电台";
    self.fakeBar.fakeTitleView = searchBar;
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    [PlayingBarItem sharedInstance].delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.fakeBar];
}

#pragma mark - PlayingBarItemDelegate
- (void)playingBarItemTapped
{
    PlayingViewController *playingVC = [PlayingViewController sharedInstance];
    if (playingVC.musicEntities.count == 0) return;
    playingVC.hidesBottomBarWhenPushed = YES;
    playingVC.dontReloadMusic = YES;
    [self.navigationController pushViewController:playingVC animated:YES];
    
    //self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - Accessor Methods
- (FakeNavigationBar *)fakeBar
{
    if (_fakeBar == nil)
    {
//        UINavigationBar *fakeNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kNavigationBarHeight)];
//        fakeNavBar.barTintColor = THEME_COLOR_RED;
//        fakeNavBar.tintColor = NAVBAR_TINT_COLOR;
//        fakeNavBar.translucent = NO;
//        
//        UISearchBar *searchBar = [[UISearchBar alloc] init];
//        searchBar.placeholder = @"搜索音乐、歌词、电台";
//        UINavigationItem *fakeNavigationItem = [[UINavigationItem alloc] init];
//        fakeNavigationItem.titleView = searchBar;
//        fakeNavigationItem.rightBarButtonItem = [PlayingBarItem sharedInstance];
//        [PlayingBarItem sharedInstance].delegate = self;
//        
//        [fakeNavBar setItems:@[fakeNavigationItem]];
//        
//        _fakeBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight + kStatusBarHeight)];
//        _fakeBar.backgroundColor = THEME_COLOR_RED;
//        [_fakeBar addSubview:fakeNavBar];
        _fakeBar = [[FakeNavigationBar alloc] init];
    }
    
    return _fakeBar;
}

@end
