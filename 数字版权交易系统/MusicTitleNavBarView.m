//
//  MusicTitleNavBarView.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/5.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "MusicTitleNavBarView.h"
#import "Masonry.h"

@interface MusicTitleNavBarView ()

@property (nonatomic) UILabel *musicTitleLabel;
@property (nonatomic) UILabel *authorNameLabel;

@end

@implementation MusicTitleNavBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    [self addSubview:self.musicTitleLabel];
    [self.musicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self addSubview:self.authorNameLabel];
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.musicTitleLabel.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

#pragma mark - Accessor Methods
- (UILabel *)musicTitleLabel
{
    if (_musicTitleLabel == nil)
    {
        _musicTitleLabel.backgroundColor = [UIColor blueColor];
        _musicTitleLabel = [[UILabel alloc] init];
        _musicTitleLabel.font = [UIFont systemFontOfSize:17];
        _musicTitleLabel.textColor = [UIColor whiteColor];
        //_musicTitleLabel.backgroundColor = [UIColor clearColor];
    }
    return _musicTitleLabel;
}

- (UILabel *)authorNameLabel
{
    if (_authorNameLabel == nil)
    {
        _authorNameLabel = [[UILabel alloc] init];
        _authorNameLabel.font = [UIFont systemFontOfSize:12];
        _authorNameLabel.textColor = [UIColor whiteColor];
        _authorNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _authorNameLabel;
}

- (void)setMusicTitle:(NSString *)musicTitle
{
    _musicTitle = musicTitle;
    self.musicTitleLabel.text = musicTitle;
    [self.musicTitleLabel sizeToFit];
    [self layoutIfNeeded];
}

- (void)setAuthorName:(NSString *)authorName
{
    _authorName = authorName;
    self.authorNameLabel.text = authorName;
    [self.authorNameLabel sizeToFit];
    [self layoutIfNeeded];
}

@end
