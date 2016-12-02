//
//  AccountViewController.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/25.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "AccountViewController.h"
#import "PlayingViewController.h"
#import "PlayingBarItem.h"
#import "FakeNavigationBar.h"
#import "AccountHeaderViewFlowLayout.h"
#import "HeaderCollectionViewCell.h"
#import "CategoryCollectionViewCell.h"
#import "Masonry.h"
#import "UIView+FrameProcessor.h"

#import "Macro.h"

#define HeaderViewHeight 140
#define LastFooterHeight 250
static NSString * const HeaderCollectionViewCellReuseIdentifier = @"HeaderCollectionViewCellReuseIdentifier";
static NSString * const CategoryCollectionViewCellReuseIdentifier = @"CategoryCollectionViewCellReuseIdentifier";

@interface AccountViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PlayingBarItemDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UICollectionView *headerView;

@property (nonatomic) FakeNavigationBar *fakeBar;

@end

@implementation AccountViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s", __FUNCTION__);
    //self.navigationItem.rightBarButtonItem = [PlayingBarItem sharedInstance];
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    self.fakeBar.fakeRightBarButtonItem = nil;
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    [PlayingBarItem sharedInstance].delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __FUNCTION__);
    [self configureNavigationBar];
    [self.view addSubview:self.tableView];
    self.tableView.y = kNavigationBarHeight + kStatusBarHeight;
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kStatusBarHeight);
//    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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


- (void)configureNavigationBar
{
//    self.navigationController.navigationBar.barTintColor = THEME_COLOR_RED;
//    self.navigationController.navigationBar.tintColor = NAVBAR_TINT_COLOR;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationItem.title = @"帐号";
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NAVBAR_TINT_COLOR, NSForegroundColorAttributeName, nil];
//    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.fakeBar.fakeBarTintColor = THEME_COLOR_RED;
    self.fakeBar.tintColor = NAVBAR_TINT_COLOR;
    self.fakeBar.fakeTranslucent = NO;
    self.fakeBar.fakeTitle = @"帐号";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NAVBAR_TINT_COLOR, NSForegroundColorAttributeName, nil];
    self.fakeBar.fakeTitleTextAttributes = dict;
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.fakeBar];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
        return 2;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_time"];
        cell.textLabel.text = @"我的消息";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_time"];
        cell.textLabel.text = @"夜间模式";
        cell.accessoryView = [[UISwitch alloc] init];
    }
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_time"];
        cell.textLabel.text = @"定时关闭";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_time"];
        cell.textLabel.text = @"成为歌手";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 3 && indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_time"];
        cell.textLabel.text = @"关于";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //cell.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);

    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 10;
    return 8;
    //return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3)
        return 5;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = ((UICollectionViewFlowLayout *)collectionViewLayout).itemSize;
    if (indexPath.section == 0)
        size = CGSizeMake(kScreenWidth, HeaderViewHeight - size.height);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        HeaderCollectionViewCell *headerCell = (HeaderCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HeaderCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        headerCell.userName = @"紫电清霜";
        return headerCell;
    }
    CategoryCollectionViewCell *categoryCell = (CategoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CategoryCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    switch (indexPath.item) {
        case 0:
            categoryCell.text = @"动态";
            categoryCell.detailText = @"0";
            break;
        case 1:
            categoryCell.text = @"关注";
            categoryCell.detailText = @"5";
            break;
        case 2:
            categoryCell.text = @"粉丝";
            categoryCell.detailText = @"3";
            break;
        case 3:
            categoryCell.text = nil;
            categoryCell.detailText = @"我的资料";
            break;
        default:
            break;
    }
    return categoryCell;
}

#pragma mark - Accessor Methods
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.sectionFooterHeight = 1;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        UIView *footerView = [[UIView alloc] init];
        //footerView.backgroundColor = [UIColor blueColor];
        //_tableView.tableFooterView = footerView;
        //_tableView.backgroundColor = backgroundColorWhite;
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (UICollectionView *)headerView
{
    if (_headerView == nil)
    {
        _headerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderViewHeight) collectionViewLayout:[[AccountHeaderViewFlowLayout alloc] init]];
        [_headerView registerClass:[HeaderCollectionViewCell class] forCellWithReuseIdentifier:HeaderCollectionViewCellReuseIdentifier];
        [_headerView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:CategoryCollectionViewCellReuseIdentifier];
        _headerView.delegate = self;
        _headerView.dataSource = self;
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _headerView;
}

- (FakeNavigationBar *)fakeBar
{
    if (_fakeBar == nil)
    {
        _fakeBar = [[FakeNavigationBar alloc] init];
    }
    
    return _fakeBar;
}

#pragma mark - PlayingBarItemDelegate
- (void)playingBarItemTapped
{
    PlayingViewController *playingVC = [PlayingViewController sharedInstance];
    if (playingVC.musicEntities.count == 0) return;
    playingVC.hidesBottomBarWhenPushed = YES;
    playingVC.dontReloadMusic = YES;
    [self.navigationController pushViewController:playingVC animated:YES];
}

@end
