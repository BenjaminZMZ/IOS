//
//  FPSTableView.m
//  数字版权交易系统
//
//  Created by 李剑 on 17/3/16.
//  Copyright © 2017年 zdrjxy. All rights reserved.
//

#import "FPSTableView.h"

@implementation FPSTableView
{
    CADisplayLink *_displayLink;
    CFAbsoluteTime lastLogTime;
    NSTimeInterval scrollingTime;
    NSInteger totalFrames;
    NSInteger framesInLastInterval;
    CGFloat averageFPS;
}

- (void)didMoveToWindow {
    if (self.window != nil) {
        [self scrollingStatusDidChange];
        [self resetScrollingPerformanceCounters];
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)dealloc {
    [_displayLink invalidate];
}

- (void)resetScrollingPerformanceCounters {
    framesInLastInterval = 0;
    lastLogTime = CFAbsoluteTimeGetCurrent();
    scrollingTime = 0;
    totalFrames = 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)scrollingStatusDidChange {
    NSString *mode = [NSRunLoop currentRunLoop].currentMode;
    BOOL isScrolling = [mode isEqualToString:UITrackingRunLoopMode];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollingStatusDidChange) object:nil];
    if (isScrolling) {
        NSLog(@"**********%@", UITrackingRunLoopMode);
        if (_displayLink == nil) {
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(screenDidUpdateWhileScrolling)];
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:UITrackingRunLoopMode];
        }
        framesInLastInterval = 0;
        lastLogTime = CFAbsoluteTimeGetCurrent();
        [_displayLink setPaused:NO];
        [self performSelector:@selector(scrollingStatusDidChange) withObject:self afterDelay:0 inModes:[NSArray arrayWithObject: NSDefaultRunLoopMode]];
    } else {
        //NSLog(@"**************%@", NSDefaultRunLoopMode);
        [_displayLink setPaused:YES];
        [self resetScrollingPerformanceCounters];
        [self performSelector:@selector(scrollingStatusDidChange) withObject:self afterDelay:0 inModes:[NSArray arrayWithObject:UITrackingRunLoopMode]];
    }
}

- (void)screenDidUpdateWhileScrolling {
    framesInLastInterval++;
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    if (!lastLogTime) {
        lastLogTime = currentTime;
    }
    CGFloat delta = currentTime - lastLogTime;
    NSLog(@"***%lf", delta);
    if (delta >= 1) {
        scrollingTime += delta;
        totalFrames += framesInLastInterval;
        NSInteger lastFPS = (NSInteger)rintf((CGFloat)framesInLastInterval / delta);
        averageFPS = (CGFloat)(totalFrames / scrollingTime);
        static dispatch_queue_t __dispatchQueue = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __dispatchQueue = dispatch_queue_create("logFPS", 0);
        });
        dispatch_async(__dispatchQueue, ^{
            NSLog(@"*** last FPS = %ld, average FPS = %.2f", lastFPS, averageFPS);
        });
        framesInLastInterval = 0;
        lastLogTime = CFAbsoluteTimeGetCurrent();
    }
//    else {
//        framesInLastInterval++;
//    }
}

@end
