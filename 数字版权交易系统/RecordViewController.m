//
//  RecordPageViewController.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/6.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordView.h"
#import "Masonry.h"
#import "UIView+FrameProcessor.h"

@interface RecordViewController ()

@property (nonatomic) RecordView *recordView;

@end
#define offsetY3 -140
@implementation RecordViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configureViews
{
    [self.view addSubview:self.recordView];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_top).with.offset((self.view.height - 64 + offsetY3)/2 + 64);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCoverWithURL:(NSURL *)url
{
    [self.recordView setCoverWithURL:url];
}

- (void)startRotating
{
    [self.recordView startRotating];
}

- (void)stopRotating
{
    [self.recordView stopRotating];
}

#pragma mark Accessor Methods
- (RecordView *)recordView
{
    if (_recordView == nil)
    {
        _recordView = [[RecordView alloc] initWithFrame:CGRectMake(0, 0, 238, 238)];
    }
    return _recordView;
}

@end
