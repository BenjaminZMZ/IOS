//
//  AccountHeaderViewFlowLayout.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/28.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "AccountHeaderViewFlowLayout.h"
#import "DecorationView.h"

#import "UIView+FrameProcessor.h"
#import "Macro.h"

static NSString * const DecorationViewKind = @"DecorationViewKind";

@implementation AccountHeaderViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(kScreenWidth / 4, 50);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        
        [self registerClass:[DecorationView class] forDecorationViewOfKind:DecorationViewKind];
    }
    
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    NSLog(@"%lu", (unsigned long)attributesArray.count);
    NSMutableArray *decorationAttributesArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in attributesArray)
    {
        if (attributes.indexPath.item < 3)
            [decorationAttributesArray addObject:[self layoutAttributesForDecorationViewOfKind:DecorationViewKind atIndexPath:attributes.indexPath]];
    }
    
    NSLog(@"%lu", (unsigned long)[attributesArray arrayByAddingObjectsFromArray:decorationAttributesArray].count);
    return [attributesArray arrayByAddingObjectsFromArray:decorationAttributesArray];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *decorationAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:DecorationViewKind withIndexPath:indexPath];
    if (elementKind == DecorationViewKind)
    {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (indexPath.section == 0)
        {
            CGFloat y = attributes.center.y + attributes.size.height / 2;
            decorationAttributes.size = CGSizeMake(kScreenWidth, 0.5);
            decorationAttributes.center = CGPointMake(kScreenWidth/2, y);
        }
        else if (indexPath.item < 3)
        {
            CGFloat y = attributes.center.y;
            CGFloat x = attributes.center.x + attributes.size.width / 2;
            CGFloat height = attributes.size.height * 0.6;
            decorationAttributes.center = CGPointMake(x, y);
            decorationAttributes.size = CGSizeMake(0.5, height);
        }
    }
    decorationAttributes.zIndex = 1;
    return decorationAttributes;
}

@end
