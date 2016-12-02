//
//  MusicListTableViewCell.h
//  数字版权交易系统
//
//  Created by 李剑 on 16/12/1.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicEntity.h"

@interface MusicListTableViewCell : UITableViewCell

@property (nonatomic) NSInteger index;
@property (nonatomic, copy) NSString *musicTitle;
@property (nonatomic, copy) NSString *musicAuthor;
@property (nonatomic) MusicEntity *musicEntity;

- (void)setSpeakerViewHidden:(BOOL)hidden;
- (void)configureWithIndex:(NSInteger)index musicEntity:(MusicEntity *)musicEntity;

@end
