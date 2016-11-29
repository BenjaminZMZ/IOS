//
//  AccountHeaderView.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/28.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "AccountHeaderView.h"
#import "UIView+FrameProcessor.h"

#import "Masonry.h"

@interface AccountHeaderView ()

@property (nonatomic) UIImageView *avatarImageView;
@property (nonatomic) UILabel *userNameLabel;

@end

@implementation AccountHeaderView

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
    
    }
    return self;
}

- (void)configureViews
{
    CGFloat unitLength = self.bounds.size.height * 0.66 * 0.2;
    [self addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self).with.offset(unitLength);
        make.left.equalTo(self).width.offset(unitLength);
        make.width.equalTo(@(3 * unitLength));
        make.height.equalTo(@(3 * unitLength));
    }];
    [self addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(unitLength);
    }];
}

- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil)
    {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
        CGFloat unitLength = self.bounds.size.height * 0.66 * 0.2;
        _avatarImageView.frame = CGRectMake(unitLength, unitLength, 3 * unitLength, 3 * unitLength);
        _avatarImageView.layer.cornerRadius = _avatarImageView.width / 2;
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
