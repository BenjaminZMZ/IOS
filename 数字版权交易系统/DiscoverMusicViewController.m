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
#import "MusicSearchResultsVC.h"

#import "Macro.h"
#import "UIView+FrameProcessor.h"

#import "LJThemeSwitcher.h"


@interface DiscoverMusicViewController ()<PlayingBarItemDelegate, UISearchBarDelegate, LJTabPagerVCsSource>

@property (nonatomic) FakeNavigationBar *fakeBar;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UIView *shelterView;//点击搜索框弹出的视图
@property (nonatomic) UIBarButtonItem *cancelSearchItem;
@property (nonatomic) LJTabPagerVC *discoverTabPagerVC;
@property (nonatomic) MusicSearchResultsVC *searchResultsVC;
@property (nonatomic) BOOL isSearchResultsVCOn;
@property (nonatomic) BOOL shelterViewVisible;

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:self.discoverTabPagerVC];
    self.discoverTabPagerVC.view.frame = CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, self.view.width, self.view.height);
    [self.view addSubview:self.discoverTabPagerVC.view];
    self.discoverTabPagerVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.discoverTabPagerVC.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(indent)-[view]|" options:0 metrics:@{@"indent": @(kStatusBarHeight+kNavigationBarHeight)} views:@{@"view": self.discoverTabPagerVC.view}]];
    [self.discoverTabPagerVC didMoveToParentViewController:self];
    

    //NSLog(@"%s", __FUNCTION__);
    
    [self.view addSubview:self.shelterView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillLayoutSubviews
{
    //NSLog(@"%s", __FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    

    self.fakeBar.fakeTitleView = self.searchBar;
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    [PlayingBarItem sharedInstance].delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.fakeBar];
}

- (void)pushShelterView {
    [UIView animateWithDuration:0.15 animations:^(){
        self.shelterView.y -= self.shelterView.height;
    }];
    self.shelterViewVisible = YES;
}

- (void)hideShelterView {
    if (self.shelterViewVisible == NO) return;
    else {
        [UIView animateWithDuration:0.15 animations:^(){
            self.shelterView.y += self.shelterView.height;
        }];
        self.shelterViewVisible = NO;
    }
    
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

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //NSLog(@"%s", __FUNCTION__);
    self.fakeBar.fakeRightBarButtonItem = nil;
    //[self.searchBar setShowsCancelButton:YES animated:YES];
    self.fakeBar.fakeRightBarButtonItem = self.cancelSearchItem;
    [self pushShelterView];

    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __FUNCTION__);
    [self.searchBar resignFirstResponder];
    [self hideShelterView];
    [self addSearchResultsVC];
    
}

- (void)cancelItemClicked {
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    [self.searchBar resignFirstResponder];
    [self hideShelterView];
    [self removeSearchResultsVC];
    self.isSearchResultsVCOn = NO;
}

- (void) removeSearchResultsVC {
    [self.searchResultsVC willMoveToParentViewController:nil];
    [self.searchResultsVC.view removeFromSuperview];
    [self.searchResultsVC removeFromParentViewController];
    self.searchResultsVC = nil;
    self.isSearchResultsVCOn = NO;
}

- (void)addSearchResultsVC {
    NSLog(@"%@", self.searchBar.text);
    self.searchResultsVC.searchTerm = self.searchBar.text;
    if (self.isSearchResultsVCOn == NO) {
        [self addChildViewController:self.searchResultsVC];
        self.searchResultsVC.view.frame = CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, self.view.width, self.view.height-kStatusBarHeight - kNavigationBarHeight);
        self.searchResultsVC.view.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.searchResultsVC.view];
        self.searchResultsVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.searchResultsVC.view}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(indent)-[view]|" options:0 metrics:@{@"indent": @(kStatusBarHeight+kNavigationBarHeight)} views:@{@"view": self.searchResultsVC.view}]];
        [self.searchResultsVC didMoveToParentViewController:self];
        self.isSearchResultsVCOn = YES;
    } else {
        [self.searchResultsVC reloadVCsExceptSelected:NO];
    }
    
}

#pragma mark - Accessor Methods
- (FakeNavigationBar *)fakeBar
{
    if (_fakeBar == nil)
    {
        _fakeBar = [[FakeNavigationBar alloc] init];
        _fakeBar.layer.zPosition = 1000;//保证始终在最前面
    }
    
    return _fakeBar;
}

- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索音乐、歌词、电台";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIView *)shelterView {
    if (_shelterView == nil) {
        _shelterView = [[UIView alloc] initWithFrame:self.view.frame];
        _shelterView.height -= kNavigationBarHeight + kStatusBarHeight;
        _shelterView.y =  self.view.height;
        //NSLog(@"shelterView frame: %@", NSStringFromCGRect(_shelterView.frame));
        _shelterView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];

    }
    return _shelterView;
}

- (UIBarButtonItem *)cancelSearchItem {
    if (_cancelSearchItem == nil) {
        _cancelSearchItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked)];
    }
    return _cancelSearchItem;
}

- (LJTabPagerVC *)discoverTabPagerVC {
    if (_discoverTabPagerVC == nil) {
        _discoverTabPagerVC = [[LJTabPagerVC alloc] init];
        _discoverTabPagerVC.vcsSource = self;
    }
    return _discoverTabPagerVC;
}

- (MusicSearchResultsVC *)searchResultsVC {
    if (_searchResultsVC == nil) {
        _searchResultsVC = [[MusicSearchResultsVC alloc] init];
    }
    return _searchResultsVC;
}

#pragma mark - LJTabPagerVCsSource
- (NSInteger)numberOfViewControllers {
    return 4;
}

- (NSArray *)titles {
    return [NSArray arrayWithObjects:@"个性推荐", @"歌单", @"主播电台", @"排行榜", nil];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    return [[UIViewController alloc] init];
}
@end
