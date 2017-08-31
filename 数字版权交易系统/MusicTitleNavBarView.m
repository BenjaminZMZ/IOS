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
        make.width.equalTo(@200);
    }];
    [self addSubview:self.authorNameLabel];
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.musicTitleLabel.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@200);
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
        _musicTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _musicTitleLabel.textAlignment = NSTextAlignmentCenter;
        _musicTitleLabel.clipsToBounds = YES;
        
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
        _authorNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _authorNameLabel.textAlignment = NSTextAlignmentCenter;
        _authorNameLabel.clipsToBounds = YES;
    }
    return _authorNameLabel;
}

- (void)setMusicTitle:(NSString *)musicTitle
{
    _musicTitle = musicTitle;
    if (musicTitle.length > 12) {
        musicTitle = [NSString stringWithFormat:@"%@...", [musicTitle substringToIndex:12]];
    }
    self.musicTitleLabel.text = musicTitle;
    //[self.musicTitleLabel sizeToFit];
    //[self layoutIfNeeded];
}

- (void)setAuthorName:(NSString *)authorName
{
    _authorName = authorName;
    if (authorName.length > 12) {
        authorName = [NSString stringWithFormat:@"%@...", [authorName substringToIndex:12]];
    }
    self.authorNameLabel.text = authorName;
    //[self.authorNameLabel sizeToFit];
    //[self layoutIfNeeded];
}

@end
