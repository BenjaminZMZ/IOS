//
//  UIView+FrameProcessor.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/28.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "UIView+FrameProcessor.h"

@implementation UIView (FrameProcessor)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect newRect = self.frame;
    newRect.origin.x = x;
    self.frame = newRect;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect newRect = self.frame;
    newRect.origin.y = y;
    self.frame = newRect;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect newRect = self.frame;
    newRect.size.width = width;
    self.frame = newRect;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect newRect = self.frame;
    newRect.size.height = height;
    self.frame = newRect;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect newRect = self.frame;
    newRect.size = size;
    self.frame = newRect;
}

- (void)setAnchorPointWithoutTranslation:(CGPoint)anchorPoint {
    CGPoint oldOrigin = self.frame.origin;
    self.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    self.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}

@end
