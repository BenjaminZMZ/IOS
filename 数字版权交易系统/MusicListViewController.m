//
//  MusicListViewController.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/1.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicListTableViewCell.h"
#import "PlayAllTableViewCell.h"
#import "FakeNavigationBar.h"
#import "PlayingBarItem.h"
#import "PlayingViewController.h"
#import "Macro.h"

@interface MusicListViewController ()<PlayingBarItemDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) FakeNavigationBar *fakeBar;

@end

static NSString * const MusicListTableViewCellIdentifier = @"MusicListTableViewCellIdentifier";
static NSString * const PlayAllTableViewCellIdentifier = @"PlayAllTableViewCellIdentifier";

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBar];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    self.fakeBar.fakeRightBarButtonItem = nil;
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    [PlayingBarItem sharedInstance].delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
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

- (void)configureNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    self.fakeBar.fakeTitle = self.title;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cm2_topbar_icn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemTapped)];
    self.fakeBar.fakeLeftBarButtonItem = backItem;
    self.fakeBar.tintColor = NAVBAR_TINT_COLOR;
    self.fakeBar.fakeBarTintColor = THEME_COLOR_RED;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NAVBAR_TINT_COLOR, NSForegroundColorAttributeName, nil];
    self.fakeBar.fakeTitleTextAttributes = dict;
    self.fakeBar.fakeTranslucent = NO;
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    [PlayingBarItem sharedInstance].delegate = self;
    [self.view addSubview:self.fakeBar];
}

- (void)playingBarItemTapped
{
    PlayingViewController *playingVC = [PlayingViewController sharedInstance];
    if (playingVC.musicEntities.count == 0) return;
    playingVC.hidesBottomBarWhenPushed = YES;
    playingVC.dontReloadMusic = YES;
    [self.navigationController pushViewController:playingVC animated:YES];
    
    //self.tabBarController.tabBar.hidden = YES;
}

- (void)backItemTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicEntities.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        PlayAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayAllTableViewCellIdentifier];
        cell.songNumber = self.musicEntities.count;
        return cell;
    }
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicListTableViewCellIdentifier];
    [cell configureWithIndex:indexPath.row musicEntity:self.musicEntities[indexPath.row - 1]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 44;
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayingViewController *playingVC = [PlayingViewController sharedInstance];
    playingVC.dontReloadMusic = NO;
    playingVC.musicEntities = self.musicEntities;
    if (indexPath.row < 2)
        playingVC.currentIndex = 0;
    else
        playingVC.currentIndex = indexPath.row - 1;
    [self.navigationController pushViewController:playingVC animated:YES];
}

#pragma mark - Accessor Methods
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MusicListTableViewCell class] forCellReuseIdentifier:MusicListTableViewCellIdentifier];
        [_tableView registerClass:[PlayAllTableViewCell class] forCellReuseIdentifier:PlayAllTableViewCellIdentifier];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 2 * DISTANCE_CELL_LEFT, 0, 0);
    }
    
    return _tableView;
}

- (FakeNavigationBar *)fakeBar
{
    if (_fakeBar == nil)
    {
        _fakeBar = [[FakeNavigationBar alloc] init];
    }
    return _fakeBar;
}

@end
