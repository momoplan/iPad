//
//  UserCenterTogetherFowllerCell.m
//  Ruyicai_iPad
//
//  Created by Shen Yanping on 14-4-24.
//  Copyright (c) 2014年 baozi. All rights reserved.
//

#import "UserCenterTogetherFowllerCell.h"

@implementation UserCenterTogetherFowllerCell

- (void)dealloc{
    self.nameLabel = nil;
    self.costLabel = nil;
    self.timeLabel = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 20)];
        [self.contentView addSubview:self.nameLabel];
        
        self.costLabel =[[UILabel alloc]initWithFrame:CGRectMake(170, 0, 150, 20)];
        self.costLabel.textColor =[UIColor redColor];
        [self.contentView addSubview:self.costLabel];
        
        self.timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 200, 20)];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
