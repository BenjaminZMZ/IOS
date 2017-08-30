//
//  SearchResultsBaseVC.m
//  数字版权交易系统
//
//  Created by 李剑 on 17/3/15.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import "SearchResultsBaseVC.h"

@interface SearchResultsBaseVC ()

@end

@implementation SearchResultsBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
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

- (void)search {
    
}

- (void)setSearchTerm:(NSString *)searchTerm {
    NSCharacterSet *expectedCharSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    _searchTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet];
}

@end
