//
//  PlayAllTableViewCell.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/1.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "PlayAllTableViewCell.h"
#import "Macro.h"
#import "Masonry.h"

@interface PlayAllTableViewCell ()

@property (nonatomic) UIImageView *playIconImageView;
@property (nonatomic) UILabel *playAllLabel;
@property (nonatomic) UILabel *songNumLabel;
@property (nonatomic) UIButton *editButton;

@end

@implementation PlayAllTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
        [self configureViews];
    return self;
}

- (void)configureViews
{
    [self.contentView addSubview:self.playIconImageView];
    [self.playIconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_left).with.offset(DISTANCE_CELL_LEFT);
    }];
    [self.contentView addSubview:self.playAllLabel];
    [self.playAllLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.playIconImageView.mas_centerX).with.offset(DISTANCE_CELL_LEFT);
    }];
    [self.contentView addSubview:self.songNumLabel];
    [self.songNumLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.playAllLabel.mas_right);
    }];
    [self.contentView addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
}

#pragma mark - Accessor Methods
- (UIImageView *)playIconImageView
{
    if (_playIconImageView == nil)
    {
        _playIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_list_icn_play"]];
    }
    return _playIconImageView;
}

- (UILabel *)playAllLabel
{
    if (_playAllLabel == nil)
    {
        _playAllLabel = [[UILabel alloc] init];
        _playAllLabel.font = [UIFont systemFontOfSize:16];
        _playAllLabel.text = @"播放全部";
        [_playAllLabel sizeToFit];
    }
    return _playAllLabel;
}

- (UILabel *)songNumLabel
{
    if (_songNumLabel == nil)
    {
        _songNumLabel = [[UILabel alloc] init];
        _songNumLabel.font = [UIFont systemFontOfSize:13];
        _songNumLabel.textColor = FONT_COLOR_GREY;
        _songNumLabel.backgroundColor = [UIColor clearColor];
    }
    return _songNumLabel;
}

- (UIButton *)editButton
{
    if (_editButton == nil)
    {
        _editButton = [[UIButton alloc] init];
        [_editButton setImage:[UIImage imageNamed:@"cm2_list_icn_multi"] forState:UIControlStateNormal];
    }
    return _editButton;
}

- (void)setSongNumber:(NSInteger)songNumber
{
    _songNumber = songNumber;
    NSString *string = [NSString stringWithFormat:@"(共%ld首)", (long)songNumber];
    self.songNumLabel.text = string;
    [self.songNumLabel sizeToFit];
}

@end
