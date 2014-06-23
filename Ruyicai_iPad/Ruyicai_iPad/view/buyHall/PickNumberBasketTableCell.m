//
//  PickNumberBasketTableCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-16.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "PickNumberBasketTableCell.h"

#define CellDeleteBasic (2000)


@implementation PickNumberBasketTableCell
@synthesize cellContentDic;
@synthesize delegate;
@synthesize contentIndex;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        NSArray *redArray = @[@"06",@"10",@"11",@"12",@"28"];
        NSArray *blueArray = @[@"07",@"15"];
        CGFloat width = redArray.count * 30;
        NSString *redStr =[redArray componentsJoinedByString:@" "];
        redLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, width, 20)];
        redLabel.backgroundColor = [UIColor clearColor];
        redLabel.text = redStr;
        redLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:redLabel];
        
        blueLable =[[UILabel alloc]initWithFrame:CGRectMake(redLabel.frame.size.width, redLabel.frame.origin.y, 100, 20)];
        blueLable.backgroundColor  =[UIColor clearColor];
        blueLable.text =[blueArray componentsJoinedByString:@" "];
        blueLable.textColor = [UIColor blueColor];
        [self.contentView addSubview:blueLable];
        
        int count =1;
        resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 200, 20)];
        resultLabel.backgroundColor = [UIColor clearColor];
        resultLabel.text =[NSString stringWithFormat:@"%d 注    %d 元",count,count*2];
        [self.contentView addSubview:resultLabel];
        
           }
    return self;
}
- (void)basketTableCellRefresh
{
    
    NSString * redStr = [cellContentDic objectForKey:@"red"];
    NSString * blueStr = [cellContentDic objectForKey:@"blue"];
    int count = [[cellContentDic objectForKey:@"count"]intValue];
    CGFloat width;
    if ([blueStr isEqualToString:@""]||blueStr == nil) {
        width = redStr.length*25;
    }else
    {
        width = redStr.length*10;
    }
    redLabel.frame = CGRectMake(10, 5, width, 20);
    redLabel.text = redStr;
    
    blueLable.frame = CGRectMake(redLabel.frame.size.width+5, redLabel.frame.origin.y, blueStr.length*15, 20);
    blueLable.text = blueStr;
    
    resultLabel.text =[NSString stringWithFormat:@"%d 注    %d 元",count,count*2];

    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.frame = CGRectMake(240, 15, 20, 20);
    deleBtn.backgroundColor = [UIColor clearColor];
    [deleBtn setBackgroundImage:[UIImage imageNamed:@"cell_delete.png"] forState:UIControlStateNormal];
    deleBtn.tag = contentIndex + CellDeleteBasic;
    [deleBtn addTarget:self action:@selector(cellDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleBtn];

    
}
- (void)cellDeleteAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self.delegate deleteCellDataWithIndex:btn.tag - CellDeleteBasic];
}
- (void)dealloc
{
    [redLabel release];
    [blueLable release];
    [resultLabel release];
    [cellContentDic release],cellContentDic = nil;
    
    [super dealloc];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
