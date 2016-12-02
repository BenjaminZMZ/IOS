//
//  CategoryCollectionViewCell.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/28.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "CategoryCollectionViewCell.h"
#import "UIView+FrameProcessor.h"
#import "Macro.h"

#import "Masonry.h"

@interface CategoryCollectionViewCell ()

@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UILabel *detailTextLabel;

@end

@implementation CategoryCollectionViewCell

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
    [self.contentView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    [self.contentView addSubview:self.detailTextLabel];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
}

#pragma mark - Accessor Methods
- (UILabel *)textLabel
{
    if (_textLabel == nil)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textColor = FONT_COLOR_GREY;

    }
    
    return _textLabel;
}

- (UILabel *)detailTextLabel
{
    if (_detailTextLabel == nil)
    {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.backgroundColor = [UIColor clearColor];
        _detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return _detailTextLabel;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
    if (text == nil)
    {
        UIImageView *pencil = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_set_icn_edit"]];
        [self.textLabel addSubview:pencil];
        CGPoint center = [self.contentView convertPoint:self.textLabel.center toView:self.textLabel];
        center.y -= pencil.height / 2;
        pencil.center = center;
        //self.textLabel.size = [UIImage imageNamed:@"cm2_set_icn_edit"].size;
        NSLog(@"%@", NSStringFromCGSize([UIImage imageNamed:@"cm2_set_icn_edit"].size));
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        [self.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.contentView.mas_centerY).with.offset(2);
        }];
    }
}

- (void)setDetailText:(NSString *)detailText
{
    _detailText = detailText;
    self.detailTextLabel.text = detailText;
    [self.detailTextLabel sizeToFit];
}

@end
