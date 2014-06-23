//
//  QueryWinningTableViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-25.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryWinningTableViewCell.h"

@implementation QueryWinningTableViewCell
@synthesize winState;

@synthesize winModel;
@synthesize betModel;
- (void)dealloc
{
    [winModel release],winModel = nil;
    [winMoneyLabel release];
    [moneyLabel release];
    [winState release],winState = nil;
    [kindLabel release];
    [issueLabel release];
    [timeLabel release];
    [super dealloc];


}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.frame =CGRectMake(10, 10, 880, 88);
//        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"queryWinCell.png"]];
        
        UIImageView *bgImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryWinCell.png"]];
        self.backgroundView  = bgImage;
        [bgImage release];
        
        UIImageView *selectImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryWinCellClick.png"]];
        self.selectedBackgroundView = selectImage;
        [selectImage release];
        
        kindLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 250, 30)];
        kindLabel.font =[UIFont boldSystemFontOfSize:25];
        kindLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:kindLabel];
        
        issueLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x + kindLabel.frame.size.width +10, kindLabel.frame.origin.y+5, 200, 20)];
        issueLabel.backgroundColor =[UIColor clearColor];
        issueLabel.textColor = RGBCOLOR(46, 139, 42);
        [self.contentView addSubview:issueLabel];

        timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x, 60, 300, 20)];
        timeLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:timeLabel];
        
        winMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(460, 30, 150, 30)];
        winMoneyLabel.backgroundColor =[UIColor clearColor];
        winMoneyLabel.font=[UIFont systemFontOfSize:18];
        winMoneyLabel.hidden = NO;
        [self.contentView addSubview:winMoneyLabel];
        
        moneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(550, winMoneyLabel.frame.origin.y, 200, 30)];
        moneyLabel.font = winMoneyLabel.font;
        moneyLabel.backgroundColor =[UIColor clearColor];
        moneyLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:moneyLabel];

      
    }
    return self;
}

/* 内容布局 */
- (void)queryWinContentViewCreate
{
    
    int state =[winState intValue];
    switch (state) {
        case 1://投注
        {
            kindLabel.text = betModel.lotName;
            
            if (betModel.batchCode.length > 0) {
                issueLabel.text =[NSString stringWithFormat:@"(期号：%@)",betModel.batchCode ];
            }
            else
            {
                issueLabel.text = @"";
            }
            
            timeLabel.text =[NSString stringWithFormat:@"购买时间：%@",betModel.orderTime];
            
            switch ([betModel.prizeState intValue]) {
                case 0://未开奖
                {
                    winMoneyLabel.text =@"未开奖";
                    moneyLabel.hidden =YES;
                }
                    break;
                case 3://未中奖
                {
                    winMoneyLabel.text =@"未中奖";
                    moneyLabel.hidden =YES;
                }
                    break;
                case 4:
                case 5://中奖
                {
                    winMoneyLabel.text =@"中奖金额";
                    moneyLabel.text = [NSString stringWithFormat:@" %.2lf 元",[betModel.prizeAmt doubleValue]/100];
                    moneyLabel.hidden =NO;
                }
                    break;
                default:
                    break;
            }
            
            
        }
            break;
        case 2://中奖
        {
            kindLabel.text = winModel.lotName;
            
            if (betModel.batchCode.length > 0) {
                issueLabel.text =[NSString stringWithFormat:@"(期号：%@)",winModel.batchCode ];
            }
            else
            {
                issueLabel.text = @"";
            }
            
            timeLabel.text =[NSString stringWithFormat:@"购买时间：%@",winModel.sellTime];
            
            moneyLabel.text = [NSString stringWithFormat:@" %0.2f 元",[winModel.winAmount doubleValue]/100];
            winMoneyLabel.text = @"中奖金额:";
            moneyLabel.hidden =NO;
        }
            break;
        default:
            break;
    }
       
//    UIButton * detailBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    detailBtn.frame = CGRectMake(700, winMoneyLabel.frame.origin.y, 147, 36);
//    [detailBtn setImage:[UIImage imageNamed:@"queryCellBtnnormal.png"] forState:UIControlStateNormal];
//    [detailBtn setImage:[UIImage imageNamed:@"queryCellBtnclick.png"] forState:UIControlStateHighlighted];
//    [self.contentView addSubview:detailBtn];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
