//
//  AccountDetailTabelViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "AccountDetailTabelViewCell.h"

@implementation AccountDetailTabelViewCell
@synthesize model;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        typeLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 25)];
        typeLabel.text = model.memo;
        [self.contentView addSubview:typeLabel];
        
        monLabel =[[UILabel alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
        [self.contentView addSubview:monLabel];
        
        timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(700, 10, 200, 25)];
        [self.contentView addSubview:timeLabel];

    }
    return self;
}
- (void)dealloc{
    [model release],model = nil;
    [typeLabel release];
    [monLabel release];
    [timeLabel release];

    [super dealloc];


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark ----------- contentView
- (void)accountCellContentView
{
    typeLabel.text = model.memo;
    
    
    if ([model.blsign isEqualToString:@"-1"]) {
        monLabel.text = [NSString stringWithFormat:@"-%.2f元",[model.amt  intValue]/100.0];
        [monLabel setTextColor:[UIColor colorWithRed:32.0/255.0 green:124.0/255.0 blue:35.0/255.0 alpha:1.0]];
    }else
    {
        monLabel.text = [NSString stringWithFormat:@"+%.2f元",[model.amt intValue]/100.0];
        [monLabel setTextColor:[UIColor colorWithRed:196.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    }

    timeLabel.text = model.platTime;

    
    }
@end
