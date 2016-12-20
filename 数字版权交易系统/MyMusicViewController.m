//
//  MyMusicViewController.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/25.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "MyMusicViewController.h"
#import "PlayingViewController.h"
#import "FakeNavigationBar.h"
#import "PlayingBarItem.h"
#import "Macro.h"
#import "UIView+FrameProcessor.h"
#import "MusicEntity.h"

#import "MusicListViewController.h"

#import "CategoryTableViewCell.h"

#import "LJThemeSwitcher.h"

@interface MyMusicViewController ()<PlayingBarItemDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) FakeNavigationBar *fakeBar;
@property (nonatomic) UITableView *tableView;

@end

static NSString * const CategoryTableViewCellIdentifier = @"CategoryTableViewCellIdentifier";

@implementation MyMusicViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"%s", __FUNCTION__);
//    if (self.navigationItem.rightBarButtonItem)
//        NSLog(@"%@", [self.navigationItem.rightBarButtonItem class]);
//    self.navigationItem.rightBarButtonItem = nil;
//    self.navigationItem.rightBarButtonItem = [PlayingBarItem sharedInstance];
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    self.fakeBar.fakeRightBarButtonItem = nil;
    self.fakeBar.fakeRightBarButtonItem = [PlayingBarItem sharedInstance];
    [PlayingBarItem sharedInstance].delegate = self;
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __FUNCTION__);
    //self.view.bkColorPicker = colorPickerWithColors([UIColor whiteColor], [UIColor blackColor]);
    [self configureNavigationBar];
    [self.view addSubview:self.tableView];
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


- (void)configureNavigationBar
{
//    self.navigationController.navigationBar.barTintColor = THEME_COLOR_RED;
//    self.navigationController.navigationBar.tintColor = NAVBAR_TINT_COLOR;
//    self.navigationController.navigationBar.translucent = NO;
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NAVBAR_TINT_COLOR, NSForegroundColorAttributeName, nil];
//    self.navigationController.navigationBar.titleTextAttributes = dict;
//    self.navigationItem.title = @"我的音乐";
    
    self.fakeBar.fakeBarTintColor = THEME_COLOR_RED;
    self.fakeBar.fakeTintColor = NAVBAR_TINT_COLOR;
    self.fakeBar.fakeTranslucent = NO;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NAVBAR_TINT_COLOR, NSForegroundColorAttributeName, nil];
    self.fakeBar.fakeTitleTextAttributes = dict;
    self.fakeBar.fakeTitle = @"我的音乐";
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.fakeBar];
}

- (NSDictionary *)dictionaryWithContentsOfJSONString:(NSString *)fileLocation
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
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

#pragma mark - Tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 4;
    if (section == 1)
        return 0;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CategoryTableViewCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
                [cell configureWithIcon:[UIImage imageNamed:@"cm2_list_icn_dld_new"] title:@"下载音乐" number:@"0"];
                break;
            case 1:
                [cell configureWithIcon:[UIImage imageNamed:@"cm2_list_icn_recent_new"] title:@"最近播放" number:@"0"];
                break;
            case 2:
                [cell configureWithIcon:[UIImage imageNamed:@"cm2_list_icn_ipod_new"] title:@"本地音乐" number:@"3"];
                break;
            case 3:
                [cell configureWithIcon:[UIImage imageNamed:@"cm2_list_icn_artists_new"] title:@"我的歌手" number:@"0"];
                break;
            default:
             break;
        }
        return cell;
    }
    if (indexPath.section == 1)
    {
        
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - Tableview datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 50;
    if (indexPath.section == 1)
        return 60;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return 0;
}

#pragma mark - Tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicListViewController *musicListVC = [[MusicListViewController alloc] init];
    musicListVC.hidesBottomBarWhenPushed = YES;
    musicListVC.title = @"本地音乐";
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 2:
            {
                NSDictionary *dict = [self dictionaryWithContentsOfJSONString:@"music_list.json"];
                musicListVC.musicEntities = [MusicEntity arrayOfEntitiesFromArray:dict[@"data"]].mutableCopy;
            }
                break;
                
            default:
                break;
        }
    }
    [self.navigationController pushViewController:musicListVC animated:YES];

}

#pragma mark - Accessor Methods
- (FakeNavigationBar *)fakeBar
{
    if (_fakeBar == nil)
    {
        _fakeBar = [[FakeNavigationBar alloc] init];
    }
    
    return _fakeBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, kScreenWidth, self.view.height - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
        [_tableView registerClass:[CategoryTableViewCell class] forCellReuseIdentifier:CategoryTableViewCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    }
    
    return _tableView;
}

@end
