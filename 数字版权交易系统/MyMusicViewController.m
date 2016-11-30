//
//  MyMusicViewController.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/25.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "MyMusicViewController.h"
#import "PlayingViewController.h"
#import "PlayingBarItem.h"
#import "Macro.h"

@interface MyMusicViewController ()<PlayingBarItemDelegate>

@end

@implementation MyMusicViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"%s", __FUNCTION__);
//    if (self.navigationItem.rightBarButtonItem)
//        NSLog(@"%@", [self.navigationItem.rightBarButtonItem class]);
//    self.navigationItem.rightBarButtonItem = nil;
//    self.navigationItem.rightBarButtonItem = [PlayingBarItem sharedInstance];
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
    NSLog(@"%s", __FUNCTION__);
    [self configureNavigationBar];
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
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NAVBAR_TINT_COLOR, NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.title = @"我的音乐";
    
    //self.navigationItem.rightBarButtonItem = [PlayingBarItem playingBarItem];
    //self.navigationItem.rightBarButtonItem = [PlayingBarItem sharedInstance];
}

#pragma mark - PlayingBarItemDelegate
- (void)playingBarItemTapped
{
    PlayingViewController *controller = [[PlayingViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
