//
//  AccountViewController.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/25.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "AccountViewController.h"
#import "Macro.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = THEME_COLOR_RED;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"帐号";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NAVBAR_TINT_COLOR, NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
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

@end
