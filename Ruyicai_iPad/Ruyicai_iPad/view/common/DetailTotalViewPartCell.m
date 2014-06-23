//
//  DetailTotalViewPartCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-19.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "DetailTotalViewPartCell.h"

@implementation DetailTotalViewPartCell
@synthesize model;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initCellView];
    }
    return self;
}
- (void)dealloc
{
    [nameLabel release];
    [timeLabel release];
    [moneyLabel release];
    [model release],model = nil;
    [super dealloc];

}
- (void)initCellView
{
    nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
    [self.contentView addSubview:nameLabel];
    
   timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(200, 10, 200, 20)];
    [self.contentView addSubview:timeLabel];
    
    moneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(450, 10, 100, 20)];
    moneyLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:moneyLabel];
}
- (void)detailTotalPartCellRefresh
{
    nameLabel.text = model.nickName;
    timeLabel.text = model.buyTime;
    moneyLabel.text =[NSString stringWithFormat:@"￥%d",[model.buyAmt intValue]/100];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
