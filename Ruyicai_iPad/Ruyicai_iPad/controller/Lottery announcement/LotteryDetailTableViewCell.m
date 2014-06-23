//
//  LotteryDetailTableViewCell.m
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "LotteryDetailTableViewCell.h"

@implementation LotteryDetailTableViewCell

@synthesize lotTitle = cell_lotTitle;
@synthesize batchCode = cell_batchCode;
@synthesize openPrizeDate = cell_openPrizeDate;
@synthesize openPrizeCode = cell_openPrizeCode;
@synthesize lotteryTryNo = cell_lotteryTryNo;
@synthesize batchCodeLabel = cell_batchCodeLabel;
@synthesize openPrizeDateLabel = cell_openPrizeDateLabel;
@synthesize lotteryTryCodeLabel = cell_lotteryTryCodeLabel;
@synthesize ballView = cell_ballView;


- (void) dealloc
{
    [cell_ballView release];
    [cell_batchCodeLabel release];
    [cell_openPrizeDateLabel release];
    [cell_lotteryTryCodeLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        //期号
        cell_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 30)];
        cell_batchCodeLabel.backgroundColor = [UIColor clearColor];
        cell_batchCodeLabel.font = [UIFont systemFontOfSize:18];
        cell_batchCodeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cell_batchCodeLabel];
        
        //开奖时间
        cell_openPrizeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 260, 20)];
        cell_openPrizeDateLabel.backgroundColor = [UIColor clearColor];
        cell_openPrizeDateLabel.font = [UIFont systemFontOfSize:18];
        cell_openPrizeDateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cell_openPrizeDateLabel];
        
        //开奖小球显示
        cell_ballView = [[LotteryBallCommonView alloc] initWithFrame:CGRectMake(30, 35, 200, 40)];
        [self addSubview:cell_ballView];
        
        cell_lotteryTryCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 40, 200, 20)];
        cell_lotteryTryCodeLabel.backgroundColor = [UIColor clearColor];
        cell_lotteryTryCodeLabel.textColor = [UIColor orangeColor];
        cell_lotteryTryCodeLabel.font = [UIFont systemFontOfSize:18];
        cell_lotteryTryCodeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cell_lotteryTryCodeLabel];
    }   
    return self;
}


- (void) refleshTableCell
{
    cell_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期",cell_batchCode];
    cell_openPrizeDateLabel.text = [NSString stringWithFormat:@"开奖日期：%@",cell_openPrizeDate];
    
    //绘制小球
    [cell_ballView drawBallWithLotteryCode:cell_openPrizeCode lotteryTitle:cell_lotTitle scope:0.9];
    
    if ([self.lotTitle isEqualToString:kLotTitleFC3D])
    {
        if (cell_lotteryTryNo.length == 6) {
            NSMutableArray * lotteryArray =[[NSMutableArray alloc]initWithCapacity:1];

            for (int i = 0; i < 3; i++){
                NSString *subString = [cell_lotteryTryNo substringWithRange:NSMakeRange(2*i, 2)];
                [lotteryArray addObject:subString];
            }
            int oneNum = [[lotteryArray objectAtIndex:0] intValue];
            int twoNum = [[lotteryArray objectAtIndex:1] intValue];
            int three = [[lotteryArray objectAtIndex:2] intValue];
            cell_lotteryTryCodeLabel.text = [NSString stringWithFormat:@"试机号: %d  %d  %d",oneNum,twoNum,three];
            [lotteryArray release];

        }
        else
        {
            cell_lotteryTryCodeLabel.text = @"";
        }
        //试机号
    }
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
