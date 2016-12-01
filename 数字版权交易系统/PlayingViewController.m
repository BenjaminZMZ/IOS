//
//  PlayingViewController.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/29.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "PlayingViewController.h"
#import "RecordView.h"
#import "Masonry.h"
#import "FakeNavigationBar.h"
#import "UIView+FrameProcessor.h"
#import "Macro.h"

@interface PlayingViewController ()

@property (nonatomic) FakeNavigationBar *fakeBar;

@property (nonatomic) UIImageView *recordImageView;
@property (nonatomic) UIImageView *recordNeddleView;
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

#define offsetY1 -44
#define offsetY2 -94
#define offsetY3 -140

@implementation PlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //将translucent设为YES，使edgesForExtendedLayout设为UIRectEdgeAll
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self configureNavigationBar];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self configureViews];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = YES;
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
    //[self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)configureNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cm2_topbar_icn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemTapped)];
    self.fakeBar.fakeLeftBarButtonItem = backItem;
    self.fakeBar.tintColor = NAVBAR_TINT_COLOR;
    [self.fakeBar setTransparent:YES];
    [self.view addSubview:self.fakeBar];
}

- (void)backItemTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureViews
{
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.backgroundImageView];
    //[self.view addSubview:self.visualEffectView];
    [self.view addSubview:self.recordImageView];
    [self.recordImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_top).with.offset((self.view.height - 64 + offsetY3)/2 + 64);
        NSLog(@"self.view.height: %f", self.view.height);
        NSLog(@"(self.view.height - 64 + offsetY3)/2 + 64: %f", (self.view.height - 64 + offsetY3)/2 + 64);
    }];
    
    [self.view addSubview:self.recordNeddleView];
    [self.recordNeddleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(48);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(self.recordNeddleView.width * 0.3);
    }];
    
    [self.view addSubview:self.beginTimeLabel];
    [self.view addSubview:self.musicSlider];
    [self.view addSubview:self.endTimeLabel];
    float space = 0.075 * kScreenWidth;
    float sliderWidth = 0.72 * kScreenWidth;
    //    y = kScreenHeight - distanceToBottom2;
    //其他控件都根据musicSlider的位置布局
    [self.musicSlider mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
        make.width.equalTo(@(sliderWidth));
    }];
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_left).with.offset(space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_right).with.offset(-space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
    }];

    
    [self.view addSubview:self.loveButton];
    [self.view addSubview:self.downloadButton];
    [self.view addSubview:self.commentButton];
    [self.view addSubview:self.moreButton];
    
    space = (sliderWidth - 4 * self.loveButton.width) / 3.0;
    NSLog(@"space: %f", space);
    NSLog(@"kScreenWidth: %f", kScreenWidth);

    [self.loveButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.musicSlider.mas_left).with.offset(0);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    //NSLog(@"loveButton centerX: %@", NSStringFromCGRect(self.loveButton.frame));
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.loveButton.mas_right).with.offset(space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    //NSLog(@"downloadButton centerX: %f", self.downloadButton.center.x);
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.downloadButton.mas_right).with.offset(space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    //NSLog(@"commentButton centerX: %f", self.commentButton.center.x);
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.commentButton.mas_right).with.offset(space);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    //NSLog(@"moreButton centerX: %f", self.moreButton.center.x);
//
//    [self.view addSubview:self.beginTimeLabel];
//    [self.view addSubview:self.musicSlider];
//    [self.view addSubview:self.endTimeLabel];
//    space = kScreenWidth / 20;
////    y = kScreenHeight - distanceToBottom2;
//    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerX.equalTo(self.view.mas_left).with.offset(space);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
//    }];
//    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerX.equalTo(self.view.mas_right).with.offset(-space);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
//    }];
//    [self.musicSlider mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
//        make.width.equalTo(@(0.9 * (kScreenWidth - 4 * space)));
//    }];

    [self.view addSubview:self.tooglePlayModeButton];
    [self.view addSubview:self.previousMusicButton];
    [self.view addSubview:self.tooglePlayPauseButton];
    [self.view addSubview:self.nextMusicButton];
    [self.view addSubview:self.musicListButton];
    
    //self.tooglePlayModeButton.backgroundColor = [UIColor redColor];
    //y = kScreenHeight - distanceToBottom1;
    [self.tooglePlayModeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
        make.right.equalTo(self.musicSlider.mas_left).offset(0);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    [self.previousMusicButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
        make.centerX.equalTo(self.musicSlider.mas_left).with.offset(sliderWidth / 5);
        make.width.equalTo(@(49));
        make.height.equalTo(@(49));
    }];
    [self.nextMusicButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
        make.centerX.equalTo(self.musicSlider.mas_right).with.offset(-sliderWidth / 5);
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
        make.left.equalTo(self.musicSlider.mas_right).offset(0);
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
        _recordImageView.layer.cornerRadius = _recordImageView.width / 2;
        _recordImageView.clipsToBounds = YES;
        _recordImageView.transform = CGAffineTransformMakeScale(1.8 * kScreenWidth / 375, 1.8 *  kScreenWidth / 375);
    }
    
    return _recordImageView;
}

- (UIImageView *)recordNeddleView
{
    if (_recordNeddleView == nil)
    {
        if (kScreenWidth == 375 && kScreenHeight == 667)
            _recordNeddleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_needle_play-ip6"]];
        else
            _recordNeddleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_needle_play"]];
    }
    
    return _recordNeddleView;
}

- (UIButton *)loveButton
{
    if (_loveButton == nil)
    {
        _loveButton = [[UIButton alloc] init];
        UIImage *loveImage = [UIImage imageNamed:@"cm2_play_icn_love"];
        //_loveButton.imageView.image = loveImage;
        [_loveButton setImage:loveImage forState:UIControlStateNormal];
        _loveButton.size = loveImage.size;
        //_loveButton.backgroundColor = [UIColor redColor];
    }
    
    return _loveButton;
}

- (UIButton *)downloadButton
{
    if (_downloadButton == nil)
    {
        _downloadButton = [[UIButton alloc] init];
        UIImage *downloadImage = [UIImage imageNamed:@"cm2_play_icn_dld"];
        //_downloadButton.imageView.image = downloadImage;
        [_downloadButton setImage:downloadImage forState:UIControlStateNormal];
        _downloadButton.size = downloadImage.size;
        //_downloadButton.backgroundColor = [UIColor redColor];
    }
    
    return _downloadButton;
}

- (UIButton *)commentButton
{
    if (_commentButton == nil)
    {
        _commentButton = [[UIButton alloc] init];
        UIImage *commentImage = [UIImage imageNamed:@"cm2_play_icn_cmt"];
        //_commentButton.imageView.image = commentImage;
        [_commentButton setImage:commentImage forState:UIControlStateNormal];
        _commentButton.size = commentImage.size;
//        _commentButton.backgroundColor = [UIColor redColor];
//        NSLog(@"***%@", NSStringFromCGSize(_commentButton.size));
    }
    
    return _commentButton;
}

- (UIButton *)moreButton
{
    if (_moreButton == nil)
    {
        _moreButton = [[UIButton alloc] init];
        UIImage *moreImage = [UIImage imageNamed:@"cm2_play_icn_more"];
        //_moreButton.imageView.image = moreImage;
        [_moreButton setImage:moreImage forState:UIControlStateNormal];
        _moreButton.size = moreImage.size;
//        _moreButton.backgroundColor = [UIColor redColor];
//        NSLog(@"*****************%@", NSStringFromCGSize(_moreButton.size));
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
        //_beginTimeLabel.backgroundColor = [UIColor redColor];
        [_beginTimeLabel sizeToFit];
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
        //_endTimeLabel.backgroundColor = [UIColor redColor];
        [_endTimeLabel sizeToFit];
    }
    
    return _endTimeLabel;
}

- (UISlider *)musicSlider
{
    if (_musicSlider == nil)
    {
        _musicSlider = [[UISlider alloc] init];
        _musicSlider.tintColor = THEME_COLOR_RED;
        //_musicSlider.backgroundColor = [UIColor redColor];
    }
    
    return _musicSlider;
}

- (UIButton *)tooglePlayModeButton
{
    if (_tooglePlayModeButton == nil)
    {
        _tooglePlayModeButton = [[UIButton alloc] init];
        UIImage *musicListImage = [UIImage imageNamed:@"cm2_icn_list"];
        //_tooglePlayModeButton.imageView.image = musicListImage;
        [_tooglePlayModeButton setImage:musicListImage forState:UIControlStateNormal];
        _tooglePlayModeButton.size = musicListImage.size;
     //   _tooglePlayModeButton.backgroundColor = [UIColor redColor];
    }
    
    return _tooglePlayModeButton;
}

- (UIButton *)previousMusicButton
{
    if (_previousMusicButton == nil)
    {
        _previousMusicButton = [[UIButton alloc] init];
        UIImage *previousMusicImage = [UIImage imageNamed:@"cm2_fm_btn_next"];
        //_previousMusicButton.imageView.image = previousMusicImage;
        [_previousMusicButton setImage:previousMusicImage forState:UIControlStateNormal];
        _previousMusicButton.size = previousMusicImage.size;
        _previousMusicButton.transform = CGAffineTransformMakeRotation(M_PI);
        //_previousMusicButton.backgroundColor = [UIColor redColor];
    }
    
    return _previousMusicButton;
}

- (UIButton *)nextMusicButton
{
    if (_nextMusicButton == nil)
    {
        _nextMusicButton = [[UIButton alloc] init];
        UIImage *nextMusicImage = [UIImage imageNamed:@"cm2_fm_btn_next"];
        //_nextMusicButton.imageView.image = nextMusicImage;
        [_nextMusicButton setImage:nextMusicImage forState:UIControlStateNormal];
        _nextMusicButton.size = nextMusicImage.size;
    }
    
    return _nextMusicButton;
}

- (UIButton *)tooglePlayPauseButton
{
    if (_tooglePlayPauseButton == nil)
    {
        _tooglePlayPauseButton = [[UIButton alloc] init];
        UIImage *tooglePlayPauseImage = [UIImage imageNamed:@"cm2_fm_btn_play"];
        [_tooglePlayPauseButton setImage:tooglePlayPauseImage forState:UIControlStateNormal];
        _tooglePlayPauseButton.size = tooglePlayPauseImage.size;
    }
    
    return _tooglePlayPauseButton;
}

- (UIButton *)musicListButton
{
    if (_musicListButton == nil)
    {
        _musicListButton = [[UIButton alloc] init];
        UIImage *musicListImage = [UIImage imageNamed:@"cm2_icn_list"];
        //_musicListButton.imageView.image = musicListImage;
        [_musicListButton setImage:musicListImage forState:UIControlStateNormal];
        _musicListButton.size = musicListImage.size;
        //_musicListButton.backgroundColor = [UIColor redColor];
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

- (FakeNavigationBar *)fakeBar
{
    if (_fakeBar == nil)
    {
        _fakeBar = [[FakeNavigationBar alloc] init];
    }
    
    return _fakeBar;
}

@end
