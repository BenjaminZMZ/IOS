//
//  RecordView.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/30.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "RecordView.h"
#import "Masonry.h"
#import "Macro.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+FrameProcessor.h"

@interface RecordView ()

@property (nonatomic) UIImageView *coverImageView;
@property (nonatomic) UIImageView *diskImageView;
//@property (nonatomic) UIImageView *circleImageView;
@property (nonatomic) BOOL shouldRotate;

@end

@implementation RecordView
{
    bool _isRotating;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
        _isRotating = NO;
    }
    return self;
}

- (void)configureViews
{
    [self.coverImageView addSubview:self.diskImageView];
    [self.diskImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.coverImageView.mas_centerX);
        make.centerY.equalTo(self.coverImageView.mas_centerY);
    }];
    
    [self addSubview:self.coverImageView];
    CGSize size = self.coverImageView.size;
    NSLog(@"size: %@", NSStringFromCGSize(size));
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(size.width));
        make.height.equalTo(@(size.height));
    }];
//    [self addSubview:self.circleImageView];
//    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
}

#pragma mark - Instance Methods
- (void)setCoverWithURL:(NSURL *)url
{
    //[self.coverImageView sd_setImageWithURL:url];
    [self.coverImageView setImage:nil];
    UIImage *placeholder = kScreenWidth == 320 ? [UIImage imageNamed:@"cm2_default_cover_play"] : [UIImage imageNamed:@"cm2_default_cover_play-ip6"];
    if (!url) {
        self.coverImageView.image = placeholder;
    } else
        [self.coverImageView sd_setImageWithURL:url placeholderImage:placeholder];
}

- (void)startRotating
{
    //CGAffineTransform endAngle = CGAffineTransformMakeRotation(2 * M_PI);
    self.shouldRotate = YES;
}

- (void)stopRotating
{
    self.shouldRotate = NO;
}

- (void)rotate
{
    if (self.shouldRotate && !_isRotating) {
        _isRotating = YES;
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformRotate(self.transform, M_PI/100);
        } completion:^(BOOL finished){
            _isRotating = NO;
            [self rotate];
        }];
    }
    
}

#pragma mark - Accessor Methods
- (UIImageView *)coverImageView
{
    if (_coverImageView == nil)
    {
        if (kScreenWidth == 320)
        {
            UIImage *cover = [UIImage imageNamed:@"cm2_default_cover_play"];
            _coverImageView = [[UIImageView alloc] initWithImage:cover];
            _coverImageView.size = cover.size;
        }
        
        else//cm2_default_cover_play-ip6
        {
            UIImage *cover = [UIImage imageNamed:@"cm2_default_cover_play-ip6"];
            _coverImageView = [[UIImageView alloc] initWithImage:cover];
            _coverImageView.size = cover.size;
        }
        _coverImageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    return _coverImageView;
}

- (UIImageView *)diskImageView
{
    if (_diskImageView == nil)
    {
        if (kScreenWidth == 320)
            _diskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_disc"]];
        else
            _diskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_disc-ip6"]];
        //cm2_play_disc-ip6
    }
    return _diskImageView;
}

- (void)setShouldRotate:(BOOL)shouldRotate
{
    _shouldRotate = shouldRotate;
    if (shouldRotate == YES && !_isRotating)
        [self rotate];
}

//- (UIImageView *)circleImageView
//{
//    if (_circleImageView == nil)
//    {
//        _circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_runfm_circle"]];
//    }
//    
//    return _circleImageView;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
