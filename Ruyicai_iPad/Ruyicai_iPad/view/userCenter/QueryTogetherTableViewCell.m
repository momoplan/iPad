//
//  QueryTogetherTableViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryTogetherTableViewCell.h"

@implementation QueryTogetherTableViewCell
@synthesize togeModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryWinCell.png"]];
        self.backgroundView  = bgImage;
        [bgImage release];
        UIImageView *selectImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryWinCellClick.png"]];
        
        self.selectedBackgroundView = selectImage;
        [selectImage release];
        
        kindLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 30)];
        kindLabel.font =[UIFont boldSystemFontOfSize:25];
        kindLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:kindLabel];
        
        stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x + kindLabel.frame.size.width +10, kindLabel.frame.origin.y+5, 100, 20)];
        stateLabel.backgroundColor =[UIColor clearColor];
        stateLabel.textColor = RGBCOLOR(46, 139, 42);
        [self.contentView addSubview:stateLabel];
        
        timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x, 60, 300, 20)];
        timeLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:timeLabel];
        
        numberLabel =[[UILabel alloc]initWithFrame:CGRectMake(400, 20, 300, 20)];
        numberLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:numberLabel];
        
        
        UILabel *subLabel =[[UILabel alloc]initWithFrame:CGRectMake(numberLabel.frame.origin.x, 45, 120, 20)];
        subLabel.backgroundColor =[UIColor clearColor];
        subLabel.text = @"认购金额:";
        [self.contentView addSubview:subLabel];
        [subLabel release];
        
        monLabel =[[UILabel alloc]initWithFrame:CGRectMake(subLabel.frame.origin.x+subLabel.frame.size.width, 40, 150, 30)];
        monLabel.textColor =[UIColor redColor];
        monLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:monLabel];

        winCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(650, 0, 250, 90)];
        winCountLabel.textColor =[UIColor redColor];
        winCountLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:winCountLabel];
    }
    return self;
}
- (void)dealloc
{
    [togeModel release],togeModel = nil;
    [monLabel release];
    [numberLabel release];
    [timeLabel release];
    [kindLabel release];
    [stateLabel release];
    [super dealloc];

}
- (void)queryTogetherCellRefresh
{
    monLabel.text =[ NSString stringWithFormat:@"%0.2f",[togeModel.buyAmt intValue]/100.0 ];
    numberLabel.text = [ NSString stringWithFormat:@"编号: %@",togeModel.caseLotId];
    
    timeLabel.text = togeModel.buyTime;
    
    kindLabel.text = togeModel.lotName;
    //合买状态 1认购中，2满员，3成功，4撤单，5流单，6已中奖
    winCountLabel.text = @"";
    switch ([togeModel.displayState intValue]) {
        case 1:
        {
           stateLabel.text =@"(认购中）";
        }
            break;
        case 2:
            stateLabel.text =@"(满员）";
            break;
        case 3:
            stateLabel.text =@"(成功）";
            break;
        case 4:
            stateLabel.text =@"(撤单）";
            break;
        case 5:
            stateLabel.text =@"(流单）";
            break;
        case 6:
            stateLabel.text =@"(已中奖）";
            winCountLabel.text = [NSString stringWithFormat:@"中奖金额：%.2lf元", [togeModel.prizeAmt doubleValue]/100];
            break;
        default:
            break;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
