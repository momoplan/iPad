//
//  BuyLotteryTableCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-10-18.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "BuyLotteryTableCell.h"

@implementation BuyLotteryTableCell
@synthesize cellLotNo;
@synthesize cellDataDic;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        stageLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 65, 180, 20)];
        stageLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:stageLabel];
        
        openTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, stageLabel.frame.origin.y, 180, 20)];
        openTimeLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:openTimeLabel];
        
        tryNoLabel =[[UILabel alloc]initWithFrame:CGRectMake(250, 10, 200, 40)];
        tryNoLabel.backgroundColor =[UIColor clearColor];
        tryNoLabel.textColor = RGBCOLOR(100, 56, 32);
        tryNoLabel.font = [UIFont systemFontOfSize:20.0];
        [self.contentView addSubview:tryNoLabel];
    }
    return self;
}
- (void)dealloc
{
    [cellLotNo       release],cellLotNo      = nil;
    [cellDataDic     release],cellDataDic    = nil;
    [stageLabel      release];
    [openTimeLabel   release];
    [tryNoLabel release];
    
    [super dealloc];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)lotteryCellBallRefresh
{
    stageLabel.text = [NSString stringWithFormat:@"第%@期", KISDictionaryHaveKey(cellDataDic, @"batchCode")];
    openTimeLabel.text = [NSString stringWithFormat:@"开奖时间: %@", KISDictionaryHaveKey(cellDataDic, @"openTime")];
    
    tryNoLabel.text = @"";
    if ([cellLotNo isEqualToString:kLotNoSSQ]) {
    
        [self cellSSQballViewDrawBlue:1];
    }
    if ([cellLotNo isEqualToString:kLotNoDLT]) {
        [self cellDLTBallViewDraw];
    }
    if ([cellLotNo isEqualToString:kLotNoGD115]) {
        [self cellSSQballViewDrawBlue:0];
    }
    if ([cellLotNo isEqualToString:kLotNoSSC]) {
        [self cellSSCBallViewDraw];
    }
    if ([cellLotNo isEqualToString:kLotNoFC3D]) {
        [self cellFC3DballViewDraw];
        
        NSString * tryString = KISDictionaryHaveKey(cellDataDic, @"tryCode");
        if (tryString && tryString.length == 6) {
            
            tryNoLabel.text = [NSString stringWithFormat:@"试机号：%d，%d，%d",[[tryString substringWithRange:NSMakeRange(0, 2)] intValue], [[tryString substringWithRange:NSMakeRange(2, 2)] intValue], [[tryString substringWithRange:NSMakeRange(4, 2)] intValue]];
        }
      
    }
}
- (void)cellSSQballViewDrawBlue:(int)blueInt
{
    NSString * redBallString =KISDictionaryHaveKey(cellDataDic, @"winCode");
    if (redBallString ) {
        NSArray * redArray =[self lotteryCellBallNumberString:redBallString];
        if (redArray.count !=0) {
            for (int i=0; i<redArray.count; i++) {
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
               button.frame = CGRectMake(50+(i*45), 10, 40, 40);
                if (i >=redArray.count-blueInt) {
                    [button setBackgroundImage:[UIImage imageNamed:@"ball_blue.png"] forState:UIControlStateNormal];
                }else{
                    [button setBackgroundImage:[UIImage imageNamed:@"ball_red.png"] forState:UIControlStateNormal];
                }
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:[redArray objectAtIndex:i] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                [self.contentView addSubview:button];
            }
            
        }
        
    }
    
}
-(void)cellFC3DballViewDraw
{
    NSString * redBallString =KISDictionaryHaveKey(cellDataDic, @"winCode");
    if (redBallString) {
        NSArray * redArray =[self lotteryCellBallNumberString:redBallString];
        if (redArray.count!=0) {
            for (int i=0; i<3; i++) {
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(50+(i*45), 10, 40, 40);
                 [button setBackgroundImage:[UIImage imageNamed:@"ball_red.png"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%d", [[redArray objectAtIndex:i] integerValue]] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                [self.contentView addSubview:button];
            }
        }
    }
}
- (void)cellDLTBallViewDraw
{
    NSString * winCodeString =KISDictionaryHaveKey(cellDataDic, @"winCode");
    if (winCodeString ) {
        NSMutableArray * lotteryArray =[[NSMutableArray alloc]initWithCapacity:0];
        if (winCodeString.length == 20) {
            for (int i = 0; i < 7; i++)
            {
                NSMutableString *lotteryMutable = [NSMutableString stringWithString:winCodeString];
                
                //删掉空格符
                NSRange rangge = [lotteryMutable rangeOfString:@" "];
                while (rangge.length > 0) {
                    [lotteryMutable deleteCharactersInRange:rangge];
                    rangge = [lotteryMutable rangeOfString:@" "];
                }
                //删掉“＋”
                rangge = [lotteryMutable rangeOfString:@"+"];
                while (rangge.length > 0) {
                    [lotteryMutable deleteCharactersInRange:rangge];
                    rangge = [lotteryMutable rangeOfString:@"+"];
                }
                NSString *subString = [lotteryMutable substringWithRange:NSMakeRange(2*i, 2)];
                [lotteryArray addObject:subString];
            }
        }

        if (lotteryArray.count !=0) {
            for (int i=0; i<lotteryArray.count; i++) {
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame =  CGRectMake(50+(i*45), 10, 40, 40);
                if (i == 6||i==5) {
                    [button setBackgroundImage:[UIImage imageNamed:@"ball_blue.png"] forState:UIControlStateNormal];
                }else{
                    [button setBackgroundImage:[UIImage imageNamed:@"ball_red.png"] forState:UIControlStateNormal];
                }
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:[lotteryArray objectAtIndex:i] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                [self.contentView addSubview:button];
                
            }
            
        }
        [lotteryArray release];
        
    }
}
- (void)cellSSCBallViewDraw
{
    NSString * winCodeString =KISDictionaryHaveKey(cellDataDic, @"winCode");
    if (winCodeString ) {
        NSMutableArray * lotteryArray =[[NSMutableArray alloc]initWithCapacity:0];
        if (winCodeString.length == 5) {
            for (int i = 0; i < 5; i++){
                NSString *subString = [winCodeString substringWithRange:NSMakeRange(1*i, 1)];
                [lotteryArray addObject:subString];
            }
        }
        NSString * dxdsString =@"";       
        if (lotteryArray.count !=0) {
            for (int i=0; i<lotteryArray.count; i++) {
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame =  CGRectMake(50+(i*45), 10, 40, 40);
                [button setBackgroundImage:[UIImage imageNamed:@"ball_red.png"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:[lotteryArray objectAtIndex:i] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                [self.contentView addSubview:button];
                
                if (i>2) {
                    int numValue =[[lotteryArray objectAtIndex:i] intValue];
                    if (i==4) {
                        dxdsString =[dxdsString stringByAppendingString:@" "];
                    }
                    if (numValue >4) {
                        dxdsString =[dxdsString stringByAppendingString:@"大"];
                    }else{
                        dxdsString =[dxdsString stringByAppendingString:@"小"];
                    }
                    if (numValue%2 ==0) {
                        dxdsString =[dxdsString stringByAppendingString:@"双"];
                    }else
                    {
                        dxdsString =[dxdsString stringByAppendingString:@"单"];
                    }
                }
            }
            
        }
        [lotteryArray release];
        UIButton * doubleButton =[UIButton buttonWithType:UIButtonTypeCustom];
        doubleButton.frame = CGRectMake(300, 10, 80, 40);
        [doubleButton setBackgroundImage:[UIImage imageNamed:@"dxds_open.png"] forState:UIControlStateNormal];
        [doubleButton setTitle:dxdsString forState:UIControlStateNormal];
        [doubleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doubleButton.userInteractionEnabled = NO;
        [self.contentView addSubview:doubleButton];
        
    }

}
- (NSMutableArray *)lotteryCellBallNumberString:(NSString *)lotString
{
    NSMutableArray * strArray =[[NSMutableArray alloc]init];
    for (int i=0; i<lotString.length/2; i++) {
        NSString * string= [lotString substringWithRange:NSMakeRange(2*i, 2)];
        [strArray addObject:string];
    }
    return [strArray autorelease];
}
@end
