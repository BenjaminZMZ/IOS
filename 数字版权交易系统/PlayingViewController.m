//
//  PlayingViewController.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/29.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "PlayingViewController.h"
#import "Masonry.h"
#import "UIView+FrameProcessor.h"
#import "Macro.h"

@interface PlayingViewController ()

@property (nonatomic) UIImageView *recordImageView;
@property (nonatomic) UIButton *loveButton;
@property (nonatomic) UIButton *downloadButton;
@property (nonatomic) UIButton *commentButton;
@property (nonatomic) UIButton *moreButton;
@property (nonatomic) UILabel *beginTimeLabel;
@property (nonatomic) UILabel *endTimeLabel;
@property (nonatomic) UISlider *musicSlider;
@property (nonatomic) UIButton *tooglePlayModeButton;
@property (nonatomic) UIButton *previousMusicButton;
@property (nonatomic) UIButton *nextMusicButton;
@property (nonatomic) UIButton *tooglePlayPauseButton;
@property (nonatomic) UIButton *musicListButton;

@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIVisualEffectView *visualEffectView;

@end

#define offsetY1 -30
#define offsetY2 -80
#define offsetY3 -120

@implementation PlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s", __FUNCTION__);
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.navigationController.tabBarController.tabBar.hidden = YES;
//    NSLog(@"%d", self.navigationController.tabBarController.tabBar.hidden);
//    self.navigationController.tabBarController.tabBar.hidden = NO;
    NSLog(@"%s", __FUNCTION__);
}

- (void)configureViews
{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backgroundImageView];
    //[self.view addSubview:self.visualEffectView];
    //[self.view addSubview:self.recordImageView];
    
    [self.view addSubview:self.loveButton];
    [self.view addSubview:self.downloadButton];
    [self.view addSubview:self.commentButton];
    [self.view addSubview:self.moreButton];
    float space = (self.view.width - 4 * 40) / 5.0;
    NSLog(@"space: %f", space);
    NSLog(@"kScreenWidth: %f", kScreenWidth);
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loveButton]-[downloadButton]-[commentButton]-[moreButton]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"loveButton": self.downloadButton, @"downloadButton": self.downloadButton, @"commentButton": self.commentButton, @"moreButton": self.commentButton}]];
    //float y = kScreenHeight - distanceToBottom3;
    //self.loveButton.center = CGPointMake(space + 20, kScreenHeight - 64 + offsetY3);
    [self.loveButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_left).with.offset(space + 20);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    NSLog(@"loveButton centerX: %@", NSStringFromCGRect(self.loveButton.frame));
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.loveButton.mas_right).with.offset(space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    NSLog(@"downloadButton centerX: %f", self.downloadButton.center.x);
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.downloadButton.mas_right).with.offset(space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    NSLog(@"commentButton centerX: %f", self.commentButton.center.x);
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.commentButton.mas_right).with.offset(space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    NSLog(@"moreButton centerX: %f", self.moreButton.center.x);

    [self.view addSubview:self.beginTimeLabel];
    [self.view addSubview:self.musicSlider];
    [self.view addSubview:self.endTimeLabel];
    space = kScreenWidth / 20;
//    y = kScreenHeight - distanceToBottom2;
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_left).with.offset(space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_right).with.offset(-space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
    }];
    [self.musicSlider mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
        make.width.equalTo(@(kScreenWidth - 4 * space));
    }];

    [self.view addSubview:self.tooglePlayModeButton];
    [self.view addSubview:self.previousMusicButton];
    [self.view addSubview:self.tooglePlayPauseButton];
    [self.view addSubview:self.nextMusicButton];
    [self.view addSubview:self.musicListButton];
    
    //self.tooglePlayModeButton.backgroundColor = [UIColor redColor];
    //y = kScreenHeight - distanceToBottom1;
    [self.tooglePlayModeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
        make.centerX.equalTo(self.beginTimeLabel.mas_centerX).offset(0);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    [self.previousMusicButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
        make.left.equalTo(self.loveButton.mas_right);
        make.width.equalTo(@(49));
        make.height.equalTo(@(49));
    }];
    [self.nextMusicButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
        make.right.equalTo(self.moreButton.mas_left);
        make.width.equalTo(@(49));
        make.height.equalTo(@(49));
    }];
    [self.tooglePlayPauseButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
        make.centerX.equalTo(self.view.mas_left).with.offset(self.view.width / 2);
        make.width.equalTo(@(68));
        make.height.equalTo(@(68));
    }];
    [self.musicListButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
        make.centerX.equalTo(self.endTimeLabel.mas_centerX).offset(0);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Accessor Methods
- (UIImageView *)recordImageView
{
    if (_recordImageView == nil)
    {
        _recordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_default_cover_play"]];
        NSLog(@"%@", NSStringFromCGSize(_recordImageView.size));
        _recordImageView.layer.cornerRadius = _recordImageView.width / 2;
        [_recordImageView clipsToBounds];
    }
    
    return _recordImageView;
}

- (UIButton *)loveButton
{
    if (_loveButton == nil)
    {
        _loveButton = [[UIButton alloc] init];
        UIImage *loveImage = [UIImage imageNamed:@"cm2_play_icn_love"];
        _loveButton.imageView.image = loveImage;
        _loveButton.size = loveImage.size;
        _loveButton.backgroundColor = [UIColor redColor];
    }
    
    return _loveButton;
}

- (UIButton *)downloadButton
{
    if (_downloadButton == nil)
    {
        _downloadButton = [[UIButton alloc] init];
        UIImage *downloadImage = [UIImage imageNamed:@"cm2_play_icn_dld"];
        _downloadButton.imageView.image = downloadImage;
        _downloadButton.size = downloadImage.size;
        _downloadButton.backgroundColor = [UIColor redColor];
    }
    
    return _downloadButton;
}

- (UIButton *)commentButton
{
    if (_commentButton == nil)
    {
        _commentButton = [[UIButton alloc] init];
        UIImage *commentImage = [UIImage imageNamed:@"cm2_play_icn_cmt"];
        _commentButton.imageView.image = commentImage;
        _commentButton.size = commentImage.size;
        _commentButton.backgroundColor = [UIColor redColor];
        NSLog(@"***%@", NSStringFromCGSize(_commentButton.size));
    }
    
    return _commentButton;
}

- (UIButton *)moreButton
{
    if (_moreButton == nil)
    {
        _moreButton = [[UIButton alloc] init];
        UIImage *moreImage = [UIImage imageNamed:@"cm2_play_icn_more"];
        _moreButton.imageView.image = moreImage;
        _moreButton.size = moreImage.size;
        _moreButton.backgroundColor = [UIColor redColor];
        NSLog(@"*****************%@", NSStringFromCGSize(_moreButton.size));
    }
    
    return _moreButton;
}

- (UILabel *)beginTimeLabel
{
    if (_beginTimeLabel == nil)
    {
        _beginTimeLabel = [[UILabel alloc] init];
        _beginTimeLabel.backgroundColor = [UIColor clearColor];
        _beginTimeLabel.font = [UIFont systemFontOfSize:10];
        _beginTimeLabel.textColor = [UIColor whiteColor];
        _beginTimeLabel.text = @"00:00";
        _beginTimeLabel.backgroundColor = [UIColor redColor];
    }
    
    return _beginTimeLabel;
}

- (UILabel *)endTimeLabel
{
    if (_endTimeLabel == nil)
    {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.backgroundColor = [UIColor clearColor];
        _endTimeLabel.font = [UIFont systemFontOfSize:10];
        _endTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.text = @"04:39";
        _endTimeLabel.backgroundColor = [UIColor redColor];
    }
    
    return _endTimeLabel;
}

- (UISlider *)musicSlider
{
    if (_musicSlider == nil)
    {
        _musicSlider = [[UISlider alloc] init];
        _musicSlider.tintColor = THEME_COLOR_RED;
        _musicSlider.backgroundColor = [UIColor redColor];
    }
    
    return _musicSlider;
}

- (UIButton *)tooglePlayModeButton
{
    if (_tooglePlayModeButton == nil)
    {
        _tooglePlayModeButton = [[UIButton alloc] init];
        UIImage *musicListImage = [UIImage imageNamed:@"cm2_icn_list"];
        _tooglePlayModeButton.imageView.image = musicListImage;
        _tooglePlayModeButton.size = musicListImage.size;
        _tooglePlayModeButton.backgroundColor = [UIColor redColor];
    }
    
    return _tooglePlayModeButton;
}

- (UIButton *)previousMusicButton
{
    if (_previousMusicButton == nil)
    {
        _previousMusicButton = [[UIButton alloc] init];
        UIImage *previousMusicImage = [UIImage imageNamed:@"cm2_fm_btn_next"];
        _previousMusicButton.imageView.image = previousMusicImage;
        _previousMusicButton.size = previousMusicImage.size;
        _previousMusicButton.transform = CGAffineTransformMakeRotation(M_PI);
        _previousMusicButton.backgroundColor = [UIColor redColor];
    }
    
    return _previousMusicButton;
}

- (UIButton *)nextMusicButton
{
    if (_nextMusicButton == nil)
    {
        _nextMusicButton = [[UIButton alloc] init];
        UIImage *nextMusicImage = [UIImage imageNamed:@"cm2_fm_btn_next"];
        _nextMusicButton.imageView.image = nextMusicImage;
        _nextMusicButton.size = nextMusicImage.size;
        _nextMusicButton.transform = CGAffineTransformMakeRotation(M_PI);
        _nextMusicButton.backgroundColor = [UIColor redColor];
    }
    
    return _nextMusicButton;
}

- (UIButton *)tooglePlayPauseButton
{
    if (_tooglePlayPauseButton == nil)
    {
        _tooglePlayPauseButton = [[UIButton alloc] init];
        UIImage *tooglePlayPauseImage = [UIImage imageNamed:@"cm2_fm_btn_play"];
        _tooglePlayPauseButton.imageView.image = tooglePlayPauseImage;
        _tooglePlayPauseButton.size = tooglePlayPauseImage.size;
        //_tooglePlayPauseButton.backgroundColor = [UIColor clearColor];
        _tooglePlayPauseButton.backgroundColor = [UIColor redColor];
    }
    
    return _tooglePlayPauseButton;
}

- (UIButton *)musicListButton
{
    if (_musicListButton == nil)
    {
        _musicListButton = [[UIButton alloc] init];
        UIImage *musicListImage = [UIImage imageNamed:@"cm2_icn_list"];
        _musicListButton.imageView.image = musicListImage;
        _musicListButton.size = musicListImage.size;
        _musicListButton.backgroundColor = [UIColor redColor];
    }
    
    return _musicListButton;
}

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil)
    {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    
    return _backgroundImageView;
}

- (UIVisualEffectView *)visualEffectView
{
    if (_visualEffectView == nil)
    {
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _visualEffectView.frame = self.view.bounds;
    }
    
    return _visualEffectView;
}

@end
