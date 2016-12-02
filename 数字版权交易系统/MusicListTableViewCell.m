//
//  MusicListTableViewCell.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/1.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import "UIView+FrameProcessor.h"
#import "Masonry.h"
#import "Macro.h"

@interface MusicListTableViewCell ()

@property (nonatomic) UILabel *indexLabel;
@property (nonatomic) UIImageView *speakerImageView;
@property (nonatomic) UILabel *musicTitleLabel;
@property (nonatomic) UILabel *authorNameLabel;
@property (nonatomic) UIButton *menuButton;

@end

@implementation MusicListTableViewCell

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
    {
        [self configureViews];
    }
    return self;
}

- (void)configureViews
{
    //float distance = 15;
    [self.contentView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_left).with.offset(DISTANCE_CELL_LEFT);
    }];
    [self.contentView addSubview:self.speakerImageView];
    [self.speakerImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_left).with.offset(DISTANCE_CELL_LEFT);
    }];
    float offset = 2;
    [self.contentView addSubview:self.musicTitleLabel];
    [self.musicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_centerY).with.offset(offset);
        make.left.equalTo(self.indexLabel.mas_centerX).with.offset(DISTANCE_CELL_LEFT);
    }];
    [self.contentView addSubview:self.authorNameLabel];
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_centerY).with.offset(offset);
        make.left.equalTo(self.indexLabel.mas_centerX).with.offset(DISTANCE_CELL_LEFT);
    }];
    
    [self.contentView addSubview:self.menuButton];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.speakerImageView.hidden = YES;
    self.indexLabel.hidden = NO;
}

- (void)setSpeakerViewHidden:(BOOL)hidden
{
    if (hidden)
    {
        self.indexLabel.hidden = NO;
        self.speakerImageView.hidden = YES;
    }
    else
    {
        self.indexLabel.hidden = YES;
        self.speakerImageView.hidden = NO;
    }
}

- (void)configureWithIndex:(NSInteger)index musicEntity:(MusicEntity *)musicEntity
{
    self.index = index;
    self.musicEntity = musicEntity;
}

#pragma mark - Accessor Methods
- (UILabel *)indexLabel
{
    if (_indexLabel == nil)
    {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:18];
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = FONT_COLOR_GREY;
        //_indexLabel.size = CGSizeMake(19, 19);
    }
    return _indexLabel;
}

- (UIImageView *)speakerImageView
{
    if (_speakerImageView == nil)
    {
        _speakerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_vol_btn_speaker"]];
        _speakerImageView.hidden = YES;
    }
    return _speakerImageView;
}

- (UILabel *)musicTitleLabel
{
    if (_musicTitleLabel == nil)
    {
        _musicTitleLabel = [[UILabel alloc] init];
        _musicTitleLabel.font = [UIFont systemFontOfSize:16];
        _musicTitleLabel.backgroundColor = [UIColor clearColor];
    }
    return _musicTitleLabel;
}

- (UILabel *)authorNameLabel
{
    if (_authorNameLabel == nil)
    {
        _authorNameLabel = [[UILabel alloc] init];
        _authorNameLabel.font = [UIFont systemFontOfSize:12];
        _authorNameLabel.textColor = FONT_COLOR_GREY;
        _authorNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _authorNameLabel;
}

- (UIButton *)menuButton
{
    if (_menuButton == nil)
    {
        _menuButton = [[UIButton alloc] init];
        [_menuButton setImage:[UIImage imageNamed:@"cm2_list_btn_more"] forState:UIControlStateNormal];
        _menuButton.size = CGSizeMake(26, 21);
    }
    return _menuButton;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)index];
    [self.indexLabel sizeToFit];
}

- (void)setMusicTitle:(NSString *)musicTitle
{
    _musicTitle = musicTitle;
    self.musicTitleLabel.text = musicTitle;
    [self.musicTitleLabel sizeToFit];
}

- (void)setMusicAuthor:(NSString *)musicAuthor
{
    _musicAuthor = musicAuthor;
    self.authorNameLabel.text = musicAuthor;
    [self.authorNameLabel sizeToFit];
}

- (void)setMusicEntity:(MusicEntity *)musicEntity
{
    _musicEntity = musicEntity;
    self.musicTitle = musicEntity.name;
    self.musicAuthor = musicEntity.artistName;
}

@end
