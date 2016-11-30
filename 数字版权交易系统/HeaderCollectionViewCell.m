//
//  HeaderCollectionViewCell.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/28.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "HeaderCollectionViewCell.h"
#import "UIView+FrameProcessor.h"

#import "Masonry.h"

@interface HeaderCollectionViewCell ()

@property (nonatomic) UIImageView *avatarImageView;
@property (nonatomic) UILabel *userNameLabel;

@end

@implementation HeaderCollectionViewCell

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
    CGFloat unitLength = self.bounds.size.height / 5;
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView).with.offset(unitLength);
        make.left.equalTo(self.contentView).with.offset(unitLength);
        make.width.equalTo(@(3 * unitLength));
        make.height.equalTo(@(3 * unitLength));
    }];
    [self.contentView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(unitLength);
    }];
}

- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil)
    {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
        CGFloat unitLength = self.bounds.size.height / 5;
        _avatarImageView.frame = CGRectMake(unitLength, unitLength, 3 * unitLength, 3 * unitLength);
        _avatarImageView.backgroundColor = [UIColor darkGrayColor];
        _avatarImageView.layer.cornerRadius = _avatarImageView.width / 2;
        _avatarImageView.clipsToBounds = YES;
    }
    
    return _avatarImageView;
}

- (UILabel *)userNameLabel
{
    if (_userNameLabel == nil)
    {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        _userNameLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _userNameLabel;
}

- (void)setAvatar:(UIImage *)avatar
{
    _avatar = avatar;
    self.avatarImageView.image = avatar;
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    _userNameLabel.text = userName;
    [_userNameLabel sizeToFit];
}

@end
