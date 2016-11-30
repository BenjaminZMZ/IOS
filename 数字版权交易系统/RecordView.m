//
//  RecordView.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/30.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "RecordView.h"
#import "Masonry.h"

@interface RecordView ()

@property (nonatomic) UIImageView *coverImageView;
@property (nonatomic) UIImageView *diskImageView;
@property (nonatomic) UIImageView *circleImageView;

@end

@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)configureViews
{
    [self.coverImageView addSubview:self.diskImageView];
    [self.diskImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.coverImageView.mas_centerX);
        make.centerY.equalTo(self.coverImageView.mas_centerY);
    }];
    
    [self.circleImageView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.circleImageView.mas_centerX);
        make.centerY.equalTo(self.circleImageView.mas_centerY);
    }];
    [self addSubview:self.circleImageView];
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

#pragma mark - Accessor Methods
- (UIImageView *)coverImageView
{
    if (_coverImageView == nil)
    {
        _coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_default_cover_play"]];
    }
    
    return _coverImageView;
}

- (UIImageView *)diskImageView
{
    if (_diskImageView == nil)
    {
        _diskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_disc"]];
        
    }
    return _diskImageView;
}

- (UIImageView *)circleImageView
{
    if (_circleImageView == nil)
    {
        _circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_runfm_circle"]];
    }
    
    return _circleImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
