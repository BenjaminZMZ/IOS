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

typedef NS_ENUM(NSInteger, MusicPlayingMode)
{
    MusicPlayingModeLoopAll = 0,
    MusicPlayingModeLoopSingle = 1,
    MusicPlayingModeShuffle = 2,
};

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


@end

#define offsetY1 -44
#define offsetY2 -94
#define offsetY3 -140

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
    [self configureNavigationBar];
    //self.currentIndex = 0;
    self.musicProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
    self.isMusicTimerEffective = NO;
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    if (self.dontReloadMusic && self.streamer)
        return;
    [self createStreamer];
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
    self.fakeBar.fakeTitleView = self.musicTitleView;
    [self.view addSubview:self.fakeBar];
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


#pragma play music
- (void)createStreamer
{
    Track *track = [[Track alloc] init];//((MusicEntity *)(self.musicEntities[self.currentIndex])).fileName
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:((MusicEntity *)(self.musicEntities[self.currentIndex])).fileName ofType:@"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    track.audioFileURL = fileURL;

    MusicEntity *currentEntity = ((MusicEntity *)(self.musicEntities[self.currentIndex]));
    self.musicTitleView.musicTitle = currentEntity.name;
    self.musicTitleView.authorName = currentEntity.artistName;
    NSLog(@"%@", currentEntity.cover);
    //self.backgroundImageView.image = [UIImage imageNamed:@"cm2_default_play_bg"];
    NSURL *imageURL = [NSURL URLWithString:currentEntity.cover];
    [self.backgroundImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"cm2_default_play_bg"]];
    if (self.streamer != nil)
    {
        [self removeStreamerObserver];
        self.streamer = nil;
    }
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
    else if (context == kSliderValueKVOKey)
    {
        self.sliderValueTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sliderValueStartChanging) userInfo:nil repeats:YES];
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
    if (self.streamer.currentTime >= self.streamer.duration)
        self.streamer.currentTime -= self.streamer.duration;
    [self.musicSlider setValue:self.streamer.currentTime / self.streamer.duration animated:YES];
    [self updateTimeLabel];
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
        [_streamer play];
        self.isPlaying = YES;
    }
    else
    {
        //[self.tooglePlayPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_streamer pause];
        self.isPlaying = NO;
    }
}

- (void)playPreviousMusic
{
    self.isMusicTimerEffective = NO;
    if (self.currentIndex == 0)
        self.currentIndex = self.musicEntities.count;
    self.currentIndex = (self.currentIndex - 1) % self.musicEntities.count;
    NSLog(@"self.currentIndex: %ld", (long)self.currentIndex);
    [self createStreamer];
}

- (void)playNextMusic
{
    self.isMusicTimerEffective = NO;;
    if (self.musicPlayingMode == MusicPlayingModeShuffle)
        self.currentIndex = [self getNextRandomMusicIndex];
    else
        self.currentIndex = (self.currentIndex + 1) % self.musicEntities.count;
    NSLog(@"self.currentIndex: %ld", (long)self.currentIndex);
    [self createStreamer];
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


#pragma mark - Accessor Getter Methods
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
        //_musicTitleView.backgroundColor = [UIColor redColor];
    }
    return _musicTitleView;
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
