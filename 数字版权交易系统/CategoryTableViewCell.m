//
//  CategoryTableViewCell.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/1.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "UIView+FrameProcessor.h"
#import "Masonry.h"
#import "Macro.h"

@interface CategoryTableViewCell ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UILabel *numLabel;
//@property (nonatomic) UIView *accessoryImageView;

@end

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self configureViews];
//    }
//    return self;
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)configureViews
{
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_left).with.offset(30);
        make.width.equalTo(@30);
        make.width.equalTo(@30);
    }];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(15);
    }];
    [self.contentView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(5);
    }];
    
}

- (void)configureWithIcon:(UIImage *)icon title:(NSString *)title number:(NSString *)number
{
    self.iconImage = icon;
    self.title = title;
    self.number = number;
}

#pragma mark - Accessory Methods
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (void)setNumber:(NSString *)number
{
    _number = number;
    self.numLabel.text = number;
    [self.numLabel sizeToFit];
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    self.iconImageView.image = iconImage;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil)
    {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.size = CGSizeMake(30, 30);
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor clearColor];
        
    }
    return _titleLabel;
}

- (UILabel *)numLabel
{
    if (_numLabel == nil)
    {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:15];
        _numLabel.textColor = FONT_COLOR_GREY;
        _numLabel.text = @"0";
        _numLabel.backgroundColor = [UIColor clearColor];
        [_numLabel sizeToFit];
    }
    return _numLabel;
}

@end
