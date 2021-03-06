//
//  LotteryTableViewCell.m
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-17.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "LotteryTableViewCell.h"
#import "RYCImageNamed.h"
#import "RYCCommon.h"
#import "CommonRecordStatus.h"

@implementation LotteryTableViewCell
@synthesize logoImage = cell_logoImage;
@synthesize logoTitleLabel = cell_logoTitleLabel;
@synthesize lotTitle = cell_lotTitle;
@synthesize batchCode = cell_batchCode;
@synthesize batchCodeLabel = cell_batchCodeLabel;
@synthesize lotteryDate = cell_lotteryDate;
@synthesize lotteryDateLabel = cell_lotteryDateLabel;
@synthesize lotteryNo = cell_lotteryNo;
@synthesize lotteryBallView = cell_lotteryBallView;
@synthesize lotteryTryNo = cell_lotteryTryNo;
@synthesize lotteryTryCodeLabel = cell_lotteryTryCodeLabel;
@synthesize isOpenPrize = cell_isOpenPrize;
@synthesize kaijiangImage = cell_kaijiangImage;
@synthesize openPrizeWeek = cell_openPrizeWeek;

- (void) dealloc
{
    [cell_kaijiangImage release];
    [cell_logoImage release];
    [cell_logoTitleLabel release];
    [cell_lotteryDateLabel release];
    [cell_batchCodeLabel release];
    [cell_lotteryBallView release];
    [cell_lotteryTryCodeLabel release];
    [cell_openPrizeWeek release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //cell的背景图
        UIImageView *cellBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height -116, 100)];
        cellBgImageView.image = RYCImageNamed(@"lottery_cellbg.png");//需要一张Cell的背景图片
        [self addSubview:cellBgImageView];
        [cellBgImageView release];
        
        //彩种的logo
        cell_logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 75, 75)];
        [self addSubview:cell_logoImage];
        
        //彩种的名称
        cell_logoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 160, 20)];
        cell_logoTitleLabel.backgroundColor = [UIColor clearColor];
        cell_logoTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cell_logoTitleLabel];
        
        //期号
        cell_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 160, 20)];
        cell_batchCodeLabel.backgroundColor = [UIColor clearColor];
        cell_batchCodeLabel.font = [UIFont systemFontOfSize:18];
        cell_batchCodeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cell_batchCodeLabel];
        
        //开奖时间
        cell_lotteryDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(310, 10, 260, 20)];
        cell_lotteryDateLabel.backgroundColor = [UIColor clearColor];
        cell_lotteryDateLabel.font = [UIFont systemFontOfSize:18];
        cell_lotteryDateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cell_lotteryDateLabel];
        
        //试机号
        cell_lotteryTryCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(340, 60, 200, 30)];
        cell_lotteryTryCodeLabel.backgroundColor = [UIColor clearColor];
        cell_lotteryTryCodeLabel.textColor = [UIColor orangeColor];
        cell_lotteryTryCodeLabel.font = [UIFont systemFontOfSize:18];
        cell_lotteryTryCodeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cell_lotteryTryCodeLabel];
        
        //开奖小球显示
        cell_lotteryBallView = [[LotteryBallCommonView alloc] initWithFrame:CGRectMake(180, 40, 400, 60)];
//        cell_lotteryBallView.backgroundColor = [UIColor greenColor];
        [self addSubview:cell_lotteryBallView];
        
        cell_kaijiangImage = [[UIImageView alloc] initWithFrame:CGRectMake(680, 50, 160, 25)];
        [cell_kaijiangImage setImage:RYCImageNamed(@"jingrikaijiang.png")];
        cell_kaijiangImage.hidden = YES;
        [self addSubview:cell_kaijiangImage];
        
        //一个星期的哪几天开奖
        cell_openPrizeWeek = [[UILabel alloc] initWithFrame:CGRectMake(550, 0, 400, 40)];
        cell_openPrizeWeek.backgroundColor = [UIColor clearColor];
        cell_openPrizeWeek.font = [UIFont systemFontOfSize:16];
        cell_openPrizeWeek.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cell_openPrizeWeek];
    }
    return self;
}

- (void)refreshCell
{
    cell_logoTitleLabel.font = [UIFont systemFontOfSize:16];
    
    if ([self.lotTitle isEqualToString:kLotTitleSSQ])
    {
        cell_logoImage.image = RYCImageNamed(@"ssq.png");
        cell_logoTitleLabel.text = @"双色球";
        cell_openPrizeWeek.text = @"每周二、周四、周日开奖";
    }
    else if ([self.lotTitle isEqualToString:kLotTitleQLC])
    {
        cell_logoImage.image = RYCImageNamed(@"qxc.png");
        cell_logoTitleLabel.text = @"七乐彩";
    }
    else if ([self.lotTitle isEqualToString:kLotTitleFC3D])
    {
        cell_logoImage.image = RYCImageNamed(@"fc3d.png");
        cell_logoTitleLabel.text = @"福彩3D";
        //试机号
        if (self.lotteryTryNo.length == 6) {
            cell_lotteryTryCodeLabel.text = [NSString stringWithFormat:@"试机号: %@  %@  %@",[self.lotteryTryNo substringWithRange:NSMakeRange(0, 2)],[self.lotteryTryNo substringWithRange:NSMakeRange(2, 2)],[self.lotteryTryNo substringWithRange:NSMakeRange(4, 2)]];
        }
    }
    else if ([self.lotTitle isEqualToString:kLotTitleDLT])
    {
        cell_logoImage.image = RYCImageNamed(@"dlt.png");
        cell_logoTitleLabel.text = @"大乐透";
    }
	else if ([self.lotTitle isEqualToString:kLotTitleGD115])
    {
        cell_logoImage.image = RYCImageNamed(@"gz11x5.png");
        cell_logoTitleLabel.text = @"广东11选5";
    }
    else if ([self.lotTitle isEqualToString:kLotTitleSSC])
	{
		cell_logoImage.image = RYCImageNamed(@"ssc.png");
		cell_logoTitleLabel.text = @"时时彩";
            if (cell_lotteryNo.length == 5) {
                NSMutableArray * winAry =[[NSMutableArray alloc]initWithCapacity:1];
                for (int i = 0; i < 5; i++){
                    NSString *subString = [cell_lotteryNo substringWithRange:NSMakeRange(1*i, 1)];
                    [winAry addObject:subString];
                }
            if (winAry.count<5) {
                return;
            }
            NSString * dxdsString = [[NSString alloc]init];
            
            int fourNum = [[winAry objectAtIndex:3] intValue];
            if (fourNum >4) {
                dxdsString =[dxdsString stringByAppendingString:@"大"];
            }else{
                dxdsString =[dxdsString stringByAppendingString:@"小"];
            }
            if (fourNum%2 ==0) {
                dxdsString =[dxdsString stringByAppendingString:@"双"];
            }else
            {
                dxdsString =[dxdsString stringByAppendingString:@"单"];
            }
            dxdsString = [dxdsString stringByAppendingString:@" "];
            int fiveNum = [[winAry objectAtIndex:4] intValue];
            if (fiveNum >4) {
                dxdsString =[dxdsString stringByAppendingString:@"大"];
            }else{
                dxdsString =[dxdsString stringByAppendingString:@"小"];
            }
            if (fiveNum%2 ==0) {
                dxdsString =[dxdsString stringByAppendingString:@"双"];
            }else
            {
                dxdsString =[dxdsString stringByAppendingString:@"单"];
            }
            UIButton * doubleButton =[UIButton buttonWithType:UIButtonTypeCustom];
            doubleButton.frame = CGRectMake(580, 50, 80, 40);
            [doubleButton setBackgroundImage:[UIImage imageNamed:@"dxds_open.png"] forState:UIControlStateNormal];
            [doubleButton setTitle:dxdsString forState:UIControlStateNormal];
            [doubleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            doubleButton.userInteractionEnabled = NO;
            [self addSubview:doubleButton];
//                [winAry release];
//                [dxdsString release];
        }
       
        
    }
    
    //绘制小球
    [cell_lotteryBallView drawBallWithLotteryCode:cell_lotteryNo lotteryTitle:cell_lotTitle scope:1.0];
    
    cell_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期",cell_batchCode];
    cell_lotteryDateLabel.text = [NSString stringWithFormat:@"开奖日期：%@",cell_lotteryDate];
    
    if (self.isOpenPrize) {
        cell_kaijiangImage.hidden = NO;
        cell_openPrizeWeek.hidden = NO;
    }
    else
    {
        cell_kaijiangImage.hidden = YES;
        cell_openPrizeWeek.hidden = YES;
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
