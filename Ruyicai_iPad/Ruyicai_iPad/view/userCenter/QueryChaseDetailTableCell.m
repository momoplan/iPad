//
//  QueryChaseDetailTableCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryChaseDetailTableCell.h"

@implementation QueryChaseDetailTableCell
@synthesize detModel;
- (void)dealloc
{
    [stageLabel release];
    [sumLabel release];
    [numLabel release];
    [winLabel release];
    [mulLabel release];
    [stateLabel release];
    [detModel release],detModel = nil;
    [super dealloc];

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        stageLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 20)];
        stageLabel.font =[UIFont systemFontOfSize:15];
        [self.contentView addSubview:stageLabel];
        
        sumLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 150, 20)];
        sumLabel.font = stageLabel.font;
        [self.contentView addSubview:sumLabel];
        
        numLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 250, 20)];
        numLabel.font = stageLabel.font;
        [self.contentView addSubview:numLabel];
        
        winLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 60, 150, 20)];
        winLabel.font = stageLabel.font;
        [self.contentView addSubview:winLabel];
        
        mulLabel =[[UILabel alloc]initWithFrame:CGRectMake(180, 0, 120, 20)];
        mulLabel.font = stageLabel.font;
        [self.contentView addSubview:mulLabel];
        
        stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(180, 20, 120, 20)];
        stateLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:stateLabel];
    }
    return self;
}
- (void)getDetailCellDataRefresh
{
    stageLabel.text = [NSString stringWithFormat:@"期号:%@",detModel.batchCode];
    sumLabel.text = [NSString stringWithFormat:@"金额:%0.2f",[detModel.amount intValue]/100.0];
    numLabel.text = [NSString stringWithFormat:@"开奖号码:%@",detModel.winCode];
    winLabel.text = [NSString stringWithFormat:@"中奖金额:%0.2f元",[detModel.prizeAmt intValue]/100.0] ;
    mulLabel.text = [NSString stringWithFormat:@"倍数:%@倍",detModel.lotMulti ];
    stateLabel.text = [NSString stringWithFormat:@"状态:%@",detModel.stateMemo] ;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
