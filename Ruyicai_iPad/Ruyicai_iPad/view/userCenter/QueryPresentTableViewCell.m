//
//  QueryPresentTableViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryPresentTableViewCell.h"

@implementation QueryPresentTableViewCell
@synthesize giftModel;

- (void)dealloc
{
    [giftModel release],giftModel = nil;
    [kindLabel release];
    [timeLabel release];
    [sendLabel release];
    [monLabel release];
    [super dealloc];


}
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
        
        kindLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 30)];
        kindLabel.text = @"双色球";
        kindLabel.font =[UIFont boldSystemFontOfSize:25];
        kindLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:kindLabel];
        
        timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x, 60, 300, 20)];
        timeLabel.text = @"购买时间:2013-9-99 56:52:25";
        timeLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:timeLabel];
        
        sendLabel =[[UILabel alloc]initWithFrame:CGRectMake(300, 20, 200, 30)];
        sendLabel.text = [NSString stringWithFormat:@"受赠人:%@",@"kogokolo"];
        sendLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:sendLabel];
        
        UILabel *numLabel =[[UILabel alloc]initWithFrame:CGRectMake(sendLabel.frame.origin.x, 50, 120, 30)];
        numLabel.backgroundColor =[UIColor clearColor];
        numLabel.text = @"赠送金额:";
        [self.contentView addSubview:numLabel];
        [numLabel release];
        
        monLabel =[[UILabel alloc]initWithFrame:CGRectMake(numLabel.frame.origin.x+numLabel.frame.size.width, 50, 150, 30)];
        monLabel.text =@"50.00元";
        monLabel.textColor =[UIColor redColor];
        monLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:monLabel];
        

    }
    return self;
}
- (void)queryPresentCellRefresh
{
    kindLabel.text = giftModel.lotName;
    timeLabel.text = [NSString stringWithFormat:@"购买时间:%@",giftModel.orderTime];
    if ([giftModel.gifted isEqualToString:@"1"]) {
        sendLabel.text = [NSString stringWithFormat:@"受赠人:%@",giftModel.toMobileId];
    }
    else
        sendLabel.text = [NSString stringWithFormat:@"赠送人:%@",giftModel.giftMobileId];

    monLabel.text =[NSString stringWithFormat:@"%.2f",[giftModel.amount intValue]/100.0];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
