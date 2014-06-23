//
//  PickNumberBasketTableCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-16.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickNumberBasketCellDelegate <NSObject>

- (void) deleteCellDataWithIndex:(int)cellIndex;

@end


@interface PickNumberBasketTableCell : UITableViewCell
{
    UILabel * redLabel;//红球
    UILabel * blueLable;//篮球
    UILabel * resultLabel;//注数
}
@property (nonatomic ,retain) NSDictionary * cellContentDic;
@property (nonatomic) int contentIndex;
@property (nonatomic,assign) id<PickNumberBasketCellDelegate>delegate;
- (void) basketTableCellRefresh;
@end
