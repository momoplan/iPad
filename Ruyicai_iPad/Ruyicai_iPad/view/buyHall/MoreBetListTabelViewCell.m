//
//  MoreBetListTabelViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-3.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "MoreBetListTabelViewCell.h"

@implementation MoreBetListTabelViewCell
@synthesize messDic = _messDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        redLabel = [[UILabel alloc] init];
        redLabel.textAlignment = NSTextAlignmentLeft;
        redLabel.textColor = [UIColor redColor];
       
        redLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:redLabel];
        
        blueLabel = [[UILabel alloc] init];
        blueLabel.textAlignment = NSTextAlignmentLeft;
        blueLabel.textColor = [UIColor blueColor];
      
        blueLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:blueLabel];
        
        inforLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 310, 25)];
        inforLabel.textAlignment = NSTextAlignmentLeft;
        inforLabel.text = @"1注    2元";
        inforLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:inforLabel];
    }
    return self;
}
- (void)refreshCellView
{
    NSArray *redArray =[self.messDic objectForKey:@"redArray"];
    
    NSArray *blueArray = [self.messDic objectForKey:@"blueArray"];
    NSString *redStr =[redArray componentsJoinedByString:@" "];
    NSString *blueStr = [blueArray componentsJoinedByString:@" "];
    int numWidth = 25;
    int redLabelWidth =numWidth*redArray.count;
    if (redLabelWidth >200) {
        redLabelWidth = 200;
    }
    redLabel.frame =CGRectMake(5, 0, redLabelWidth, 25);
    blueLabel.frame =CGRectMake(redLabel.frame.size.width+10, 0, self.contentView.frame.size.width-redLabel.frame.size.width-10, 25);
    redLabel.text =redStr;
    blueLabel.text = blueStr;
    
}
- (void)dealloc
{
    [_messDic release];
    
    [super dealloc];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end