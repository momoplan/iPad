//
//  TotalBuyViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-18.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "TotalBuyViewCell.h"

@implementation TotalBuyViewCell
@synthesize model;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initContentView];
    }
    return self;
}

- (void)initContentView
{
    //进度显示图片
    
    goalProgressView    = [[GoalBarView alloc] initWithFrame:CGRectMake(10, 5, 70, 70)];
    [goalProgressView setPercent:0];
    [self.contentView addSubview:goalProgressView];
    
    //彩种名称
     kindLabel                          = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, 80, 20)];
    kindLabel.backgroundColor           = [UIColor grayColor];
    kindLabel.textColor                 = [UIColor whiteColor];
    kindLabel.layer.cornerRadius        = 5;
    kindLabel.textAlignment             = NSTextAlignmentCenter;
    [self.contentView addSubview:kindLabel];
    //发起人
    originatorLabel                     = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 20)];
    originatorLabel.backgroundColor     = [UIColor clearColor];
    originatorLabel.textColor =[UIColor grayColor];
    [self.contentView addSubview:originatorLabel];
    
    allCostLabel                        = [[UILabel alloc]initWithFrame:CGRectMake(originatorLabel.frame.origin.x, originatorLabel.frame.origin.y + 25, 120, 40)];
    allCostLabel.backgroundColor        = [UIColor clearColor];
    allCostLabel.font                   = [UIFont systemFontOfSize:23];
    [self.contentView addSubview:allCostLabel];
    
    surpiusLabel                        = [[UILabel alloc]initWithFrame:CGRectMake(allCostLabel.frame.origin.x+allCostLabel.frame.size.width + 40, allCostLabel.frame.origin.y, allCostLabel.frame.size.width, allCostLabel.frame.size.height)];
    surpiusLabel.backgroundColor        = [UIColor clearColor];
    surpiusLabel.font                   = allCostLabel.font;
    [self.contentView addSubview:surpiusLabel];
    
    everyLabel                          =[[UILabel alloc]initWithFrame:CGRectMake(surpiusLabel.frame.origin.x + surpiusLabel.frame.size.width +20, surpiusLabel.frame.origin.y, 120, allCostLabel.frame.size.height)];
    everyLabel.font                     = allCostLabel.font;
    everyLabel.backgroundColor          = [UIColor clearColor];
    [self.contentView addSubview:everyLabel];
    
    perLabel                            = [[UILabel alloc]initWithFrame:CGRectMake(everyLabel.frame.origin.x+everyLabel.frame.size.width+25, everyLabel.frame.origin.y, 80, allCostLabel.frame.size.height)];
    perLabel.backgroundColor            = [UIColor clearColor];
    perLabel.textColor                  = [UIColor redColor];
    perLabel.font                       = allCostLabel.font;
    [self.contentView addSubview:perLabel];
    
    UILabel * markLabel                 = [[UILabel alloc]initWithFrame:CGRectMake(allCostLabel.frame.origin.x, kindLabel.frame.origin.y, 500, 25)];
    markLabel.backgroundColor           = [UIColor clearColor];
    markLabel.textColor                 = [UIColor grayColor];
    markLabel.text                      = @"方案总额                   保底金额                认购金额                保底";
    [self.contentView addSubview:markLabel];
    [markLabel release];
    
    topImg = [[UIImageView alloc]initWithImage: [UIImage imageNamed: @"hm_top.png"]];
    [topImg setFrame:CGRectMake(860, 0, 52, 54)];
    topImg.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:topImg];
}
#pragma mark ------------ methods
- (void)dealloc
{
    [perLabel release];
    [everyLabel release];
    [surpiusLabel release];
    [allCostLabel release];
    [originatorLabel release];
    [numLabel release];
    [kindLabel release];
    [progressImage release];
    [m_honorView release];
    
    [super dealloc];
}

- (void)totalBuyCellRefresh
{
    int percent         = [model.progress intValue];
    [goalProgressView setPercent:percent];
    
    kindLabel.text = model.lotName;

    originatorLabel.text = [NSString stringWithFormat:@"发起人 : %@",model.starter];
    
    int widthIndex = 0;
    icoHeightIndex = 0;
    
    if (m_honorView != nil) {
        [m_honorView removeFromSuperview];
        m_honorView = nil;
    }
    //荣誉
    m_honorView = [[UIView alloc] initWithFrame:CGRectMake(300, 10 , 250 , 23)];
    [self.contentView addSubview:m_honorView];
    
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"crown.png" ICONUM:[model.crown intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycrown.png" ICONUM:[model.graycrown intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"cup.png" ICONUM:[model.cup intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycup.png" ICONUM:[model.graycup intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"diamond.png" ICONUM:[model.diamond intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graydiamond.png" ICONUM:[model.graydiamond intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"goldStar.png" ICONUM:[model.goldStar intValue]];
    [self creatIcoImage:widthIndex ICONAME:@"graygoldStar.png" ICONUM:[model.graygoldStar intValue]];

    allCostLabel.text =[NSString stringWithFormat:@"%0.2f元",[model.totalAmt intValue]/100.0];

    surpiusLabel.text = [NSString stringWithFormat:@"%.2f元",[model.safeAmt intValue]/100.0];;

    everyLabel.text =[NSString stringWithFormat:@"%0.2f元",[model.buyAmt intValue]/100.0];
    perLabel.text = [NSString stringWithFormat:@"%@%%",model.safeRate];

    if ([model.isTop boolValue]) {
        topImg.hidden = NO;
    }
    else
        topImg.hidden = YES;
}
-(NSInteger)creatIcoImage:(NSInteger)widthIndex ICONAME:(NSString*)icoName ICONUM:(NSInteger)icoNum
{
    NSInteger width = widthIndex;
    if (icoNum > 0) {
        if (width > 100) {
            icoHeightIndex = 30;
            width  = 120;
        }
        UIImageView*  ico = [[UIImageView alloc] initWithFrame:CGRectMake(width,0,23,23)];
        ico.image = RYCImageNamed(icoName);
        [ico setBackgroundColor:[UIColor clearColor]];
        [m_honorView addSubview:ico];
        [ico release];
        
        if (icoNum > 1) {
            UILabel* icoNumLable = [[UILabel alloc] initWithFrame:CGRectMake(ico.frame.origin.x + 5, 0 + 5, 23, 23)];
            icoNumLable.backgroundColor = [UIColor clearColor];
            icoNumLable.textAlignment = NSTextAlignmentRight;
            icoNumLable.text = [NSString stringWithFormat:@"%d",icoNum];
            icoNumLable.textColor = [UIColor colorWithRed:148.0/255.0 green:118.0/255.0 blue:0.0/255.0 alpha:1.0];
            icoNumLable.font = [UIFont systemFontOfSize:12];
            [m_honorView addSubview:icoNumLable];
            [icoNumLable release];
        }
        width += 28;
    }
    
    return width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
