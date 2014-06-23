//
//  TogetherDocumentaryTableCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-11-11.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryTogetherDocumentaryModel.h"

@protocol TogetherDocumentaryTableCellDelegate <NSObject>

- (void)queryTogetherDocTabelCellShowDetail:(QueryTogetherDocumentaryModel *)model;
- (void)queryTOgetherTabelCellChangeState:(QueryTogetherDocumentaryModel *)model;

@end

@interface TogetherDocumentaryTableCell : UITableViewCell
{
    UILabel         * monLabel;//金额
    UILabel         * numberLabel;//编号
    UILabel         * timeLabel;//时间
    UILabel         * kindLabel;//彩种
    UILabel         * stateLabel;//状态
    UIButton        * modButton;
}
@property (nonatomic,retain) QueryTogetherDocumentaryModel *docModel;
@property (nonatomic,assign) id<TogetherDocumentaryTableCellDelegate>delegate;

- (void)refreshTogetherDocumentaryCell;
@end
