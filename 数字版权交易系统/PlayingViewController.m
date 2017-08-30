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
#import <SDWebImage/UIImageView+WebCache.h>
#import "FakeNavigationBar.h"
#import "UIView+FrameProcessor.h"
#import "Track.h"
#import "Macro.h"
#import "MusicEntity.h"
#import "NSString+Additions.h"
#import "MusicTitleNavBarView.h"
#import "RecordViewController.h"

typedef NS_ENUM(NSInteger, MusicPlayingMode)
{
    MusicPlayingModeLoopAll = 0,
    MusicPlayingModeLoopSingle = 1,
    MusicPlayingModeShuffle = 2,
};

@interface PlayingViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic) FakeNavigationBar *fakeBar;

@property (nonatomic) RecordView *recordView;
@property (nonatomic) UIImageView *recordImageView;

@property (nonatomic) UIView *recordContainerView;
@property (nonatomic) UIView *commentBtnContainerView;
@property (nonatomic) UIView *sliderContainerView;
@property (nonatomic) UIView *tooglePlayBtnContainerView;

@property (nonatomic) UIView *recordBackgroundView;
@property (nonatomic) UIView *bbView;
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
@property (nonatomic) UIView *backgroundView;

@property (nonatomic) MusicTitleNavBarView *musicTitleView;

@property (nonatomic) BOOL isPlaying;
@property (nonatomic) NSTimer *musicProgressTimer;
@property (nonatomic) BOOL isMusicTimerEffective;
@property (nonatomic) NSTimer *sliderValueTimer;
@property (nonatomic) BOOL isSliderTimerEffective;
@property (nonatomic, assign) MusicPlayingMode musicPlayingMode;

@property (nonatomic) NSMutableArray *originArray;
@property (nonatomic) NSInteger nextRandomMusicIndex;

@property (nonatomic) UIPageViewController *recordPageVC;
@property (nonatomic) NSArray *recordVCsBuffer;
@property (nonatomic) RecordViewController *prensentRecordVC;
@property (nonatomic) RecordViewController *previousRecordVC;
@property (nonatomic) RecordViewController *nextRecordVC;


@end

#define offsetY1 (-44)
#define offsetY2 (-94)
#define offsetY3 (-140)

#define kSliderWidth (0.72 * kScreenWidth)

#define diskWidth (kScreenWidth == 320 ? 228 : 288)
#define bbViewWidth (diskWidth + (kScreenWidth == 320 ? 13 : 15))
//#define diskWidthIp6 248

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

static void *kSliderValueKVOKey = &kSliderValueKVOKey;



@implementation PlayingViewController

+ (instancetype)sharedInstance
{
    static PlayingViewController *sharedPlayingVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayingVC = [[PlayingViewController alloc] init];
        //sharedPlayingVC.streamer = [[DOUAudioStreamer alloc] init];
        sharedPlayingVC.isPlaying = NO;
        sharedPlayingVC.musicPlayingMode = MusicPlayingModeLoopAll;
        
    });
    
    return sharedPlayingVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //将translucent设为YES，使edgesForExtendedLayout设为UIRectEdgeAll
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.view.opaque = YES;
    
    
    [self configureViews];
    //self.currentIndex = 0;
    self.musicProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(updateSliderValue)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];//用户拖动切换唱片时musicProgressTimer失效，time Label不会更新。需要在NSRunLoopCommonModes下加一个timer
    self.isMusicTimerEffective = NO;
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    if (self.dontReloadMusic && self.streamer)
        return;
    //[self startRotatingRecordView];
    [self checkAndPlayMusicOfIndex:self.currentIndex];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s", __FUNCTION__);
    self.dontReloadMusic = YES;
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
    //[self.fakeBar setValue:@YES forKey:@"_fakeTranslucent"];
    self.fakeBar.fakeTitleView = self.musicTitleView;
    [self.view addSubview:self.fakeBar];
    CGSize size = self.fakeBar.bounds.size;
    [self.fakeBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(size.height));
    }];
}

- (void)backItemTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureViews
{
//    [self.view addSubview:self.backgroundImageView];
//    [self.view addSubview:self.visualEffectView];
    [self.view addSubview:self.backgroundView];
    [self configureNavigationBar];
    [self.recordContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.fakeBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(offsetY3);
    }];
    
//    [self.view addSubview:self.bbView];
//    [self.bbView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_top).with.offset((self.view.height - 64 + offsetY3)/2 + 64);
//        make.width.equalTo(@(bbViewWidth));
//        make.height.equalTo(@(bbViewWidth));
//    }];
//    [self.view addSubview:self.recordBackgroundView];
//    [self.recordBackgroundView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_top).with.offset((self.view.height - 64 + offsetY3)/2 + 64);
//        make.width.equalTo(@(diskWidth));
//        make.height.equalTo(@(diskWidth));
//    }];
    
    [self addChildViewController:self.recordPageVC];
    self.recordPageVC.view.frame = self.view.bounds;
    [self.recordContainerView addSubview:self.recordPageVC.view];
    [self.recordPageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recordContainerView.mas_left);
        make.right.equalTo(self.recordContainerView.mas_right);
        make.top.equalTo(self.recordContainerView.mas_top);
        make.bottom.equalTo(self.recordContainerView.mas_bottom);
    }];
    [self.recordPageVC didMoveToParentViewController:self];
    
    [self.recordContainerView bringSubviewToFront:self.recordNeddleView];
    
//    [self.view addSubview:self.recordNeddleView];
//    [self.recordNeddleView mas_makeConstraints:^(MASConstraintMaker *make){
//        if (kScreenWidth == 320)
//        {
//            make.top.equalTo(self.view.mas_top).with.offset(48);
//            make.centerX.equalTo(self.view.mas_centerX).with.offset(self.recordNeddleView.width * 0.3);
//        }
//        else
//        {
//            make.top.equalTo(self.view.mas_top).with.offset(36);
//            make.centerX.equalTo(self.view.mas_centerX).with.offset(self.recordNeddleView.width * 0.25);
//        }
//    }];
    
//    [self.view addSubview:self.beginTimeLabel];
//    [self.view addSubview:self.musicSlider];
//    [self.view addSubview:self.endTimeLabel];
//    float space = 0.075 * kScreenWidth;
//    float sliderWidth = 0.72 * kScreenWidth;
//    //    y = kScreenHeight - distanceToBottom2;
//    //其他控件都根据musicSlider的位置布局
//    [self.musicSlider mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
//        make.width.equalTo(@(sliderWidth));
//    }];
//    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerX.equalTo(self.view.mas_left).with.offset(space);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
//    }];
//    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerX.equalTo(self.view.mas_right).with.offset(-space);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
//    }];
    [self.sliderContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY2);
        make.height.equalTo(self.musicSlider.mas_height);
    }];

    
//    [self.view addSubview:self.loveButton];
//    [self.view addSubview:self.downloadButton];
//    [self.view addSubview:self.commentButton];
//    [self.view addSubview:self.moreButton];
//    
//    space = (sliderWidth - 4 * self.loveButton.width) / 3.0;
//    NSLog(@"space: %f", space);
//    NSLog(@"kScreenWidth: %f", kScreenWidth);
//
//    [self.loveButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.equalTo(self.musicSlider.mas_left).with.offset(0);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
//        make.width.equalTo(@(40));
//        make.height.equalTo(@(40));
//    }];
//    //NSLog(@"loveButton centerX: %@", NSStringFromCGRect(self.loveButton.frame));
//    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.equalTo(self.loveButton.mas_right).with.offset(space);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
//        make.width.equalTo(@(40));
//        make.height.equalTo(@(40));
//    }];
//    //NSLog(@"downloadButton centerX: %f", self.downloadButton.center.x);
//    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.equalTo(self.downloadButton.mas_right).with.offset(space);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
//        make.width.equalTo(@(40));
//        make.height.equalTo(@(40));
//    }];
//    //NSLog(@"commentButton centerX: %f", self.commentButton.center.x);
//    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.equalTo(self.commentButton.mas_right).with.offset(space);
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
//        make.width.equalTo(@(40));
//        make.height.equalTo(@(40));
//    }];
    [self.commentBtnContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY3);
        make.height.equalTo(self.commentButton.mas_height);
    }];
    
//    [self.view addSubview:self.tooglePlayModeButton];
//    [self.view addSubview:self.previousMusicButton];
//    [self.view addSubview:self.tooglePlayPauseButton];
//    [self.view addSubview:self.nextMusicButton];
//    [self.view addSubview:self.musicListButton];
//    
//    //self.tooglePlayModeButton.backgroundColor = [UIColor redColor];
//    //y = kScreenHeight - distanceToBottom1;
//    [self.tooglePlayModeButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
//        make.right.equalTo(self.musicSlider.mas_left).offset(0);
//        make.width.equalTo(@(44));
//        make.height.equalTo(@(44));
//    }];
//    [self.previousMusicButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
//        make.centerX.equalTo(self.musicSlider.mas_left).with.offset(sliderWidth / 5);
//        make.width.equalTo(@(49));
//        make.height.equalTo(@(49));
//    }];
//    [self.nextMusicButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
//        make.centerX.equalTo(self.musicSlider.mas_right).with.offset(-sliderWidth / 5);
//        make.width.equalTo(@(49));
//        make.height.equalTo(@(49));
//    }];
//    [self.tooglePlayPauseButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
//        make.centerX.equalTo(self.view.mas_left).with.offset(self.view.width / 2);
//        make.width.equalTo(@(68));
//        make.height.equalTo(@(68));
//    }];
//    [self.musicListButton mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
//        make.left.equalTo(self.musicSlider.mas_right).offset(0);
//        make.width.equalTo(@(44));
//        make.height.equalTo(@(44));
//    }];
    [self.tooglePlayBtnContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.centerY.equalTo(self.view.mas_bottom).with.offset(offsetY1);
        make.height.equalTo(self.tooglePlayPauseButton.mas_height);
    }];
    [self.view bringSubviewToFront:self.fakeBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma play music
- (void)checkAndPlayMusicOfIndex:(NSInteger)index {
    self.currentIndex = index;
    RecordViewController *presentVC = (RecordViewController *)(self.recordPageVC.viewControllers[0]);
    presentVC.index = index;
    MusicEntity *musicEntity = self.musicEntities[index];
    if (musicEntity.musicUrl)
        [self playMusicOfIndex:index];
    else {
        __weak typeof(self) weakSelf = self;
        [musicEntity getMusicUrlWithCompletionBlock:^(){
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf playMusicOfIndex:index];
            }
        }];
    }
    if (musicEntity.picUrl) {
        //[self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:musicEntity.picUrl] placeholderImage:[UIImage imageNamed:@"cm2_default_play_bg"]];
        [self renderImageWithUrl:musicEntity.picUrl atIndex:index];
    } else {
        __weak typeof(self) weakSelf = self;
        [musicEntity getPicUrlWithCompletionBlock:^(NSString *imgurl){
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                //[self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"cm2_default_play_bg"]];
                [strongSelf renderImageWithUrl:imgurl atIndex:index];
            }
        }];
    }
}

- (void)renderImageWithUrl:(NSString *)imgurl atIndex:(NSInteger)index{
    RecordViewController *presentVC = (RecordViewController *)(self.recordPageVC.viewControllers[0]);
    if (index == presentVC.index) {
        NSURL *picUrl = [NSURL URLWithString:imgurl];
        [self.backgroundImageView sd_setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"cm2_default_play_bg"]];
        [presentVC setCoverWithURL:picUrl];
    }
}

- (void)playMusicOfIndex:(NSInteger)index {
    
    MusicEntity *musicEntity = ((MusicEntity *)(self.musicEntities[index]));
//    ((MusicTitleNavBarView *)self.fakeBar.fakeTitleView).musicTitle = musicEntity.name;
//    NSLog(@"***%@", musicEntity.name);
    self.musicTitleView.musicTitle = musicEntity.name;
    self.musicTitleView.authorName = musicEntity.artistName;
    [self stopRotatingRecordView];
    [self startRotatingRecordView];
    if (self.streamer != nil)
    {
        [self removeStreamerObserver];
        self.streamer = nil;
    }
    Track *track = [[Track alloc] init];
    NSURL *fileURL = nil;
    if (musicEntity.filePath != nil) {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:musicEntity.filePath ofType:@"mp3"];
        fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    } else if (musicEntity.musicUrl != nil) {
        fileURL = [NSURL URLWithString:musicEntity.musicUrl];
    } else return;
    
    track.audioFileURL = fileURL;
    NSLog(@"*****%@", fileURL);
    self.streamer = [DOUAudioStreamer streamerWithAudioFile:track];
    
    [self addStreamerObserver];
    //[self updateTimeLabel];
    [self.musicSlider setValue:0];
    
    [self.streamer play];
    self.isMusicTimerEffective = YES;

    self.isPlaying = YES;
}

- (void)removeStreamerObserver
{
    [self.streamer removeObserver:self forKeyPath:@"status" context:kStatusKVOKey];
    [self.streamer removeObserver:self forKeyPath:@"duration" context:kDurationKVOKey];
    [self.streamer removeObserver:self forKeyPath:@"bufferingRatio" context:kBufferingRatioKVOKey];
}

- (void)addStreamerObserver
{
    [self.streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [self.streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [self.streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == kStatusKVOKey)
    {
        [self streamerStatusChanged];
    }
    else if (context == kDurationKVOKey)
    {
        
    }
    else if (context == kBufferingRatioKVOKey)
    {
        
    }
    else if (context == kSliderValueKVOKey)//用户开始拖动歌曲进度条
    {
        self.sliderValueTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sliderValueStartChanging) userInfo:nil repeats:YES];
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(sliderValueStartChanging)
                                               userInfo:nil
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];//用于用户一边切换唱片一边拖动滚动条
//        NSLog(@"kSliderValueKVOKey");
        self.isMusicTimerEffective = NO;
//        self.beginTimeLabel.text = [NSString timeIntervalToMMSSFormat:self.streamer.duration * [change[NSKeyValueChangeNewKey] floatValue]];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)streamerStatusChanged
{
    switch (self.streamer.status) {
        case DOUAudioStreamerPaused:
            
            break;
        case DOUAudioStreamerPlaying:
            
            break;
        case DOUAudioStreamerFinished:
            if (self.musicPlayingMode == MusicPlayingModeLoopSingle)
                [self.streamer play];
            else
                [self playNextMusic];
            break;
        case DOUAudioStreamerBuffering:
            
            break;
        case DOUAudioStreamerIdle:
            
            break;
        case DOUAudioStreamerError:
            
            break;
        default:
            break;
    }
}

- (void)updateSliderValue
{
    if (self.isMusicTimerEffective == NO)
        return;
//    if (self.streamer.currentTime >= self.streamer.duration)
//        self.streamer.currentTime -= self.streamer.duration;
//    [self.musicSlider setValue:self.streamer.currentTime / self.streamer.duration animated:YES];
//    [self updateTimeLabel];
    if (!_streamer) {
        return;
    }
    if (_streamer.status == DOUAudioStreamerFinished) {
        [_streamer play];
    }
    
    if ([_streamer duration] == 0.0) {//streamer切换中为nil时
        [_musicSlider setValue:0.0f animated:NO];
    } else {
        if (_streamer.currentTime >= _streamer.duration) {
            _streamer.currentTime -= _streamer.duration;
        }
        
        [_musicSlider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
        [self updateTimeLabel];
    }
}

- (void)updateTimeLabel
{
    self.beginTimeLabel.text = [NSString timeIntervalToMMSSFormat:self.streamer.currentTime];
    self.endTimeLabel.text = [NSString timeIntervalToMMSSFormat:self.streamer.duration];
}

#pragma mark target-action methods
- (void)tooglePlayPause
{
    if (!self.isPlaying)
    {
        //[self.tooglePlayPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [self startRotatingRecordView];
        [_streamer play];
        self.isPlaying = YES;
    }
    else
    {
        //[self.tooglePlayPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [self stopRotatingRecordView];
        [_streamer pause];
        self.isPlaying = NO;
    }
}

- (void)playPreviousMusic
{
    self.isMusicTimerEffective = NO;
    NSInteger previousMusicIndex = [self previousMusicIndex];
    RecordViewController *previousRecordVC = [self recordVCWithIndex:previousMusicIndex];
    [self renderRecordImageForRecordVC:previousRecordVC];
    [self.recordPageVC setViewControllers:@[previousRecordVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished){
        if (finished)
            [previousRecordVC startRotating];
    }];
    [self checkAndPlayMusicOfIndex:previousMusicIndex];
}

- (void)playNextMusic
{
    self.isMusicTimerEffective = NO;
    NSInteger nextMusicIndex = [self nextMusicIndex];
    RecordViewController *nextRecordVC = [self recordVCWithIndex:nextMusicIndex];
    [self renderRecordImageForRecordVC:nextRecordVC];
    [self.recordPageVC setViewControllers:@[nextRecordVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished){
        if (finished)
            [nextRecordVC startRotating];
    }];
    [self checkAndPlayMusicOfIndex:nextMusicIndex];
}

- (void)renderRecordImageForRecordVC:(RecordViewController *)recordViewController {
    NSInteger index = recordViewController.index;
    MusicEntity *musicEntity = self.musicEntities[index];
    NSString *picurl = musicEntity.picUrl;
    if (picurl) {
        [recordViewController setCoverWithURL:[NSURL URLWithString:picurl]];
    } else {
        [musicEntity getPicUrlWithCompletionBlock:^(NSString *imgurl) {
            [recordViewController setCoverWithURL:[NSURL URLWithString:imgurl]];
        }];
    }
}

- (void)tooglePlayMode
{
    switch (self.musicPlayingMode) {
        case MusicPlayingModeLoopAll:
            self.musicPlayingMode = MusicPlayingModeLoopSingle;
            break;
        case MusicPlayingModeLoopSingle:
            self.musicPlayingMode = MusicPlayingModeShuffle;
            break;
        case MusicPlayingModeShuffle:
            self.musicPlayingMode = MusicPlayingModeLoopAll;
            break;
        default:
            break;
    }
}

- (void)sliderValueStartChanging
{
    self.beginTimeLabel.text = [NSString timeIntervalToMMSSFormat:self.streamer.duration * self.musicSlider.value];
}

- (void)sliderValueEndChanging
{
    [self.sliderValueTimer invalidate];
    self.sliderValueTimer = nil;
    self.isMusicTimerEffective = YES;
    float currentVolume = self.streamer.volume;
    [self.streamer setVolume:0];
//    NSTimer *tempTimer = [NSTimer timerWithTimeInterval:0.1 repeats:NO block:^(NSTimer *timer){
//        [self.streamer setCurrentTime:self.streamer.duration * self.musicSlider.value];
//        [self.streamer setVolume:currentVolume];
//    }];
    [self.streamer setCurrentTime:self.streamer.duration * self.musicSlider.value];
    [self.streamer setVolume:currentVolume];
    
}



#pragma shuffle music
- (void)loadOriginArrayIfNeeded
{
    if (self.originArray.count == 0)
    {
        for (NSInteger i = 0; i < self.musicEntities.count; i++)
        {
            if (i == self.currentIndex)
                continue;
            else
            {
                NSNumber *number = [NSNumber numberWithInteger:i];
                [self.originArray addObject:number];
                NSLog(@"number: %@", number);
            }
        }
    }
}

- (NSInteger)getNextRandomMusicIndex
{
    [self loadOriginArrayIfNeeded];
    NSInteger index = arc4random() % self.originArray.count;
    NSInteger result = [self.originArray[index] integerValue];
    if (self.originArray.count > 1)
        self.originArray[index] = [self.originArray lastObject];
    [self.originArray removeLastObject];
    return result;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self previousMusicIndex];
    NSLog(@"previousIndex: %ld", (long)index);
    RecordViewController *recordVC = [self recordVCWithIndex:index];
    return recordVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSInteger index = [self nextMusicIndex];
    NSLog(@"nextIndex: %ld", (long)index);
    RecordViewController *recordVC = [self recordVCWithIndex:index];
    return recordVC;
}

- (RecordViewController *)recordVCWithIndex:(NSInteger)index
{
    RecordViewController *recordVC = self.recordVCsBuffer[index%3];
    [recordVC setCoverWithURL:nil];
    recordVC.index = index;
    return recordVC;
}

- (NSInteger)nextMusicIndex
{
    if (self.musicPlayingMode == MusicPlayingModeShuffle)
        return [self getNextRandomMusicIndex];
    return (self.currentIndex + 1) % self.musicEntities.count;
}

- (NSInteger)previousMusicIndex
{
    if (self.musicPlayingMode == MusicPlayingModeShuffle)
        return [self getNextRandomMusicIndex];
    return self.currentIndex == 0 ? self.musicEntities.count - 1 : self.currentIndex - 1;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    [self stopRotatingRecordView];
    [self rotateAwayRecordNeedleView];
    RecordViewController *pendingViewController = (RecordViewController *)pendingViewControllers[0];
    [self renderRecordImageForRecordVC:pendingViewController];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSLog(@"%s", __FUNCTION__);
    [self startRotatingRecordView];
    if (completed == YES)
    {
        RecordViewController *presentVC = (RecordViewController *)(self.recordPageVC.viewControllers[0]);
        [self checkAndPlayMusicOfIndex:presentVC.index];
    }
    [self rotateBackRecordNeedleView];
}

#pragma mark - rotating record view
- (void)startRotatingRecordView
{
    RecordViewController *presentVC = (RecordViewController *)(self.recordPageVC.viewControllers[0]);
    [presentVC startRotating];
}

- (void)stopRotatingRecordView
{
    RecordViewController *presentVC = (RecordViewController *)(self.recordPageVC.viewControllers[0]);
    [presentVC stopRotating];
}

- (void)rotateAwayRecordNeedleView {
    CGFloat centerX = self.recordNeddleView.center.x;
    CGFloat centerY = self.recordNeddleView.center.y;
    CGFloat x = self.view.bounds.size.width/2;
    CGFloat y = 0;
    CGAffineTransform trans = CGAffineTransformMakeTranslation(x-centerX, y-centerY);
    trans = CGAffineTransformRotate(trans, -M_PI/4);
    trans = CGAffineTransformTranslate(trans, centerX-x, centerY-y);
    [UIView animateWithDuration:0.25 animations:^(){
        self.recordNeddleView.transform = trans;
    }];
}

- (void)rotateBackRecordNeedleView {
    [UIView animateWithDuration:0.25 animations:^(){
        self.recordNeddleView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Accessor Getter Methods
- (NSArray *)recordVCsBuffer {
    if (!_recordVCsBuffer) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            RecordViewController *recordVC = [[RecordViewController alloc] init];
            [recordVC setCoverWithURL:nil];
            [array addObject:recordVC];
        }
        _recordVCsBuffer = [NSArray arrayWithArray:array];
    }
    return _recordVCsBuffer;
}
//- (RecordView *)recordView
//{
//    if (_recordView == nil)
//    {
//        _recordView = [[RecordView alloc] initWithFrame:CGRectMake(0, 0, 238, 238)];
//    }
//    return _recordView;
//}
- (UIView *)recordContainerView {
    if (!_recordContainerView) {
        _recordContainerView = [[UIView alloc] init];
        [self.view addSubview:_recordContainerView];
        
        [_recordContainerView addSubview:self.bbView];
        [self.bbView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(_recordContainerView.mas_centerX);
            make.centerY.equalTo(_recordContainerView.mas_top).with.offset((self.view.height - 64 + offsetY3)/2);
            make.width.equalTo(@(bbViewWidth));
            make.height.equalTo(@(bbViewWidth));
        }];
        [_recordContainerView addSubview:self.recordBackgroundView];
        [self.recordBackgroundView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(_recordContainerView.mas_centerX);
            make.centerY.equalTo(_recordContainerView.mas_top).with.offset((self.view.height - 64 + offsetY3)/2);
            make.width.equalTo(@(diskWidth));
            make.height.equalTo(@(diskWidth));
        }];
        
        [_recordContainerView addSubview:self.recordNeddleView];
        [self.recordNeddleView mas_makeConstraints:^(MASConstraintMaker *make){
            if (kScreenWidth == 320) {
                make.top.equalTo(_recordContainerView.mas_top).with.offset(-17);
                make.centerX.equalTo(_recordContainerView.mas_centerX).with.offset(self.recordNeddleView.width * 0.3);
            } else {
                make.top.equalTo(_recordContainerView.mas_top).with.offset(-29);
                make.centerX.equalTo(self.view.mas_centerX).with.offset(26);
            }
        }];
        _recordContainerView.clipsToBounds = YES;
    }
    return _recordContainerView;
}

- (UIView *)commentBtnContainerView {
    if (!_commentBtnContainerView) {
        _commentBtnContainerView = [[UIView alloc] init];
        [self.view addSubview:_commentBtnContainerView];
        [_commentBtnContainerView addSubview:self.loveButton];
        [_commentBtnContainerView addSubview:self.downloadButton];
        [_commentBtnContainerView addSubview:self.commentButton];
        [_commentBtnContainerView addSubview:self.moreButton];
        float space = (kSliderWidth - 4 * self.loveButton.width) / 3.0;
        //float space = 0.075 * kScreenWidth;
        [self.loveButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.musicSlider.mas_left).with.offset(0);
            make.centerY.equalTo(_commentBtnContainerView.mas_centerY);
            make.width.equalTo(@(40));
            make.height.equalTo(@(40));
        }];
        //NSLog(@"loveButton centerX: %@", NSStringFromCGRect(self.loveButton.frame));
        [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.loveButton.mas_right).with.offset(space);
            make.centerY.equalTo(_commentBtnContainerView.mas_centerY);
            make.width.equalTo(@(40));
            make.height.equalTo(@(40));
        }];
        //NSLog(@"downloadButton centerX: %f", self.downloadButton.center.x);
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.downloadButton.mas_right).with.offset(space);
            make.centerY.equalTo(_commentBtnContainerView.mas_centerY);
            make.width.equalTo(@(40));
            make.height.equalTo(@(40));
        }];
        //NSLog(@"commentButton centerX: %f", self.commentButton.center.x);
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.commentButton.mas_right).with.offset(space);
            make.centerY.equalTo(_commentBtnContainerView.mas_centerY);
            make.width.equalTo(@(40));
            make.height.equalTo(@(40));
        }];
    }
    return _commentBtnContainerView;
}

- (UIView *)sliderContainerView {
    if (!_sliderContainerView) {
        _sliderContainerView = [[UIView alloc] init];
        [self.view addSubview:_sliderContainerView];
        
        [_sliderContainerView addSubview:self.beginTimeLabel];
        [_sliderContainerView addSubview:self.musicSlider];
        [_sliderContainerView addSubview:self.endTimeLabel];
        float space = 0.075 * kScreenWidth;
        //float sliderWidth = kSliderWidth;
        //    y = kScreenHeight - distanceToBottom2;
        //其他控件都根据musicSlider的位置布局
        [self.musicSlider mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(_sliderContainerView.mas_centerX);
            make.centerY.equalTo(_sliderContainerView.mas_centerY);
            make.width.equalTo(@(kSliderWidth));
        }];
        [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(_sliderContainerView.mas_left).with.offset(space);
            make.centerY.equalTo(_sliderContainerView.mas_centerY);
        }];
        [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(_sliderContainerView.mas_right).with.offset(-space);
            make.centerY.equalTo(_sliderContainerView.mas_centerY);
        }];

    }
    return _sliderContainerView;
}

- (UIView *)tooglePlayBtnContainerView {
    if (!_tooglePlayBtnContainerView) {
        _tooglePlayBtnContainerView = [[UIView alloc] init];
        [self.view addSubview:_tooglePlayBtnContainerView];
        _tooglePlayBtnContainerView.userInteractionEnabled = YES;
        
        [_tooglePlayBtnContainerView addSubview:self.tooglePlayModeButton];
        [_tooglePlayBtnContainerView addSubview:self.previousMusicButton];
        [_tooglePlayBtnContainerView addSubview:self.tooglePlayPauseButton];
        [_tooglePlayBtnContainerView addSubview:self.nextMusicButton];
        [_tooglePlayBtnContainerView addSubview:self.musicListButton];
        
        //self.tooglePlayModeButton.backgroundColor = [UIColor redColor];
        //y = kScreenHeight - distanceToBottom1;
        [self.tooglePlayModeButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(_tooglePlayBtnContainerView.mas_centerY);
            make.right.equalTo(self.musicSlider.mas_left).offset(0);
            make.width.equalTo(@(44));
            make.height.equalTo(@(44));
        }];
        [self.previousMusicButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(_tooglePlayBtnContainerView.mas_centerY);
            make.centerX.equalTo(self.musicSlider.mas_left).with.offset(kSliderWidth / 5);
            make.width.equalTo(@(49));
            make.height.equalTo(@(49));
        }];
        [self.nextMusicButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(_tooglePlayBtnContainerView.mas_centerY);
            make.centerX.equalTo(self.musicSlider.mas_right).with.offset(-kSliderWidth / 5);
            make.width.equalTo(@(49));
            make.height.equalTo(@(49));
        }];
        [self.tooglePlayPauseButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(_tooglePlayBtnContainerView.mas_centerY);
            make.centerX.equalTo(_tooglePlayBtnContainerView.mas_centerX);
            make.width.equalTo(@(68));
            make.height.equalTo(@(68));
        }];
        [self.musicListButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(_tooglePlayBtnContainerView.mas_centerY);
            make.left.equalTo(self.musicSlider.mas_right).offset(0);
            make.width.equalTo(@(44));
            make.height.equalTo(@(44));
        }];

    }
    return _tooglePlayBtnContainerView;
}
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
        if (kScreenWidth == 320)
            _recordNeddleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_needle_play"]];
        else
            _recordNeddleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_needle_play-ip6"]];
            
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
        //_beginTimeLabel.text = @"00:00";
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
        //_endTimeLabel.text = @"04:39";
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
        _musicSlider.continuous = NO;
        //_musicSlider.backgroundColor = [UIColor redColor];
        [_musicSlider addTarget:self action:@selector(sliderValueEndChanging) forControlEvents:UIControlEventValueChanged];
        [_musicSlider addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:kSliderValueKVOKey];
    }
    
    return _musicSlider;
}

- (UIButton *)tooglePlayModeButton
{
    if (_tooglePlayModeButton == nil)
    {
        _tooglePlayModeButton = [[UIButton alloc] init];
        UIImage *musicListImage = [UIImage imageNamed:@"cm2_icn_loop"];
        //_tooglePlayModeButton.imageView.image = musicListImage;
        [_tooglePlayModeButton setImage:musicListImage forState:UIControlStateNormal];
        _tooglePlayModeButton.size = musicListImage.size;
     //   _tooglePlayModeButton.backgroundColor = [UIColor redColor];
        [_tooglePlayModeButton addTarget:self action:@selector(tooglePlayMode) forControlEvents:UIControlEventTouchUpInside];
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
        [_previousMusicButton addTarget:self action:@selector(playPreviousMusic) forControlEvents:UIControlEventTouchUpInside];
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
        [_nextMusicButton addTarget:self action:@selector(playNextMusic) forControlEvents:UIControlEventTouchUpInside];
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
        [_tooglePlayPauseButton addTarget:self action:@selector(tooglePlayPause) forControlEvents:UIControlEventTouchUpInside];
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
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        _backgroundView.opaque = YES;
    }
    
    return _backgroundImageView;
}

- (UIVisualEffectView *)visualEffectView
{
    if (_visualEffectView == nil)
    {
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        
        _visualEffectView.frame = self.view.bounds;
    }
    
    return _visualEffectView;
}

- (UIView *)backgroundView
{
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_backgroundView addSubview:self.backgroundImageView];
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        [_backgroundView addSubview:view];
        [_backgroundView addSubview:self.visualEffectView];
        _backgroundView.opaque = YES;
    }
    return _backgroundView;
}

- (FakeNavigationBar *)fakeBar
{
    if (_fakeBar == nil)
    {
        _fakeBar = [[FakeNavigationBar alloc] init];
    }
    
    return _fakeBar;
}

- (NSMutableArray *)originArray
{
    if (_originArray == nil)
        _originArray = @[].mutableCopy;
    return _originArray;
}

- (MusicTitleNavBarView *)musicTitleView
{
    if (_musicTitleView == nil)
    {
        _musicTitleView = [[MusicTitleNavBarView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        _musicTitleView.backgroundColor = [UIColor clearColor];
    }
    return _musicTitleView;
}

- (UIPageViewController *)recordPageVC
{
    if (_recordPageVC == nil)
    {
        _recordPageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _recordPageVC.dataSource = self;
        _recordPageVC.delegate = self;
        RecordViewController *recordVC = [self recordVCWithIndex:self.currentIndex];
        MusicEntity *musicEntity = self.musicEntities[self.currentIndex];
        if (musicEntity.picUrl) {
            [recordVC setCoverWithURL:[NSURL URLWithString:musicEntity.picUrl]];
        } else {
            [musicEntity getPicUrlWithCompletionBlock:^(NSString *imgurl) {
                [recordVC setCoverWithURL:[NSURL URLWithString:imgurl]];
            }];
        }
        [_recordPageVC setViewControllers:@[recordVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _recordPageVC;
}

- (UIView *)recordBackgroundView
{
    if (_recordBackgroundView == nil)
    {
        _recordBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, diskWidth, diskWidth)];
        _recordBackgroundView.layer.cornerRadius = _recordBackgroundView.width / 2;
        _recordBackgroundView.clipsToBounds = YES;
        _recordBackgroundView.backgroundColor = [UIColor blackColor];
        _recordBackgroundView.alpha = 0.15;

//        _recordBackgroundView.layer.shadowColor = [UIColor redColor].CGColor;
//        _recordBackgroundView.layer.shadowOffset = CGSizeMake(10, 10);
    }
    return _recordBackgroundView;
}

- (UIView *)bbView
{
    if (_bbView == nil)
    {
        _bbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bbViewWidth, bbViewWidth)];
        _bbView.layer.cornerRadius = _bbView.width / 2;
        _bbView.clipsToBounds = YES;
        _bbView.backgroundColor = FONT_COLOR_GREY;
        _bbView.alpha = 0.15;
    }
    return _bbView;
}

#pragma mark - Accessor Setter Methods
- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    if (isPlaying)
        [self.tooglePlayPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
    else
        [self.tooglePlayPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
}

- (void)setMusicPlayingMode:(MusicPlayingMode)musicPlayingMode
{
    _musicPlayingMode = musicPlayingMode;
    switch (musicPlayingMode) {
        case MusicPlayingModeLoopAll:
            [self.tooglePlayModeButton setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
            break;
        case MusicPlayingModeLoopSingle:
            [self.tooglePlayModeButton setImage:[UIImage imageNamed:@"cm2_icn_one"] forState:UIControlStateNormal];
            break;
        case MusicPlayingModeShuffle:
            [self.tooglePlayModeButton setImage:[UIImage imageNamed:@"cm2_icn_shuffle"] forState:UIControlStateNormal];
            [self.originArray removeAllObjects];
            break;
        default:
            break;
    }
}

- (void)dealloc
{
    [self.musicSlider removeObserver:self forKeyPath:@"value" context: kSliderValueKVOKey];
    //[super dealloc];
}

@end
