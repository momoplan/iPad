//
//  SetChaseStageTableView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-19.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 设置追期

#import "RYView.h"
#import "BatchCodeCell.h"
@interface SetChaseStageTableView : RYView
{
    BOOL            isSetChaseStage;
    UITableView     * stageTable;
}
@property (nonatomic,retain) NSMutableArray     * stageArray;
@property (nonatomic,retain) NSString           * stageNumber;
@property (nonatomic,retain) NSString           * batchLotNo;
@end
