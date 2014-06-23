//
//  QueryChaseTableViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryChaseTableViewCell.h"

@implementation QueryChaseTableViewCell
@synthesize chaseState;
@synthesize model;
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
        
        kindLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
        kindLabel.font =[UIFont boldSystemFontOfSize:25];
        kindLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:kindLabel];
        
        stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x + kindLabel.frame.size.width +10, kindLabel.frame.origin.y+5, 150, 20)];
        stateLabel.backgroundColor =[UIColor clearColor];
        stateLabel.textColor = RGBCOLOR(46, 139, 42);
        [self.contentView addSubview:stateLabel];
        
        totelLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x, 45,400, 20)];
        totelLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:totelLabel];
        
        stageLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x, 65, 150, 20)];
        stageLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:stageLabel];
        
        alStateLabel =[[UILabel alloc]initWithFrame:CGRectMake(400, 30, 200, 30)];
        alStateLabel.backgroundColor =[UIColor clearColor];
        alStateLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:alStateLabel];
        
        self.cancelChase = [[UIButton alloc] initWithFrame:CGRectMake(650, 25, 100, 40)];
        [self.cancelChase setTitle:@"取消追期" forState:UIControlStateNormal];
//        [self.cancelChase setBackgroundColor:[UIColor grayColor]];
        [self.cancelChase setTitleColor:RGBCOLOR(196, 30, 30) forState:UIControlStateNormal];
//        [self.cancelChase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cancelChase.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.cancelChase addTarget:self action:@selector(cancelChaseClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelChase];
    }
    return self;
}
- (void)dealloc
{
    [stateLabel release];
    [chaseState release],chaseState = nil;
    [model release],model = nil;
    [kindLabel release];
    [totelLabel release];
    [stageLabel release];
    [alStateLabel release];

    [super dealloc];
}
- (void)queryChaseTableCellRefresh
{
    kindLabel.text = model.lotName;
    totelLabel.text = [ NSString stringWithFormat:@"追号总额：%.2f元",[model.amount intValue]/100.0];
    stageLabel.text =[NSString stringWithFormat:@"追号期数：%@",model.batchNum];
    alStateLabel.text = [NSString stringWithFormat:@"已追期数：%@",model.lastNum];
    
    self.cancelChase.hidden = YES;
    
    switch ([model.state intValue]) {
        case 0://进行中
        {
            stateLabel.text = [NSString stringWithFormat: @"(%@）",@"进行中"];
            stateLabel.textColor = RGBCOLOR(46, 139, 42);
            if([self.model.batchNum intValue] != [self.model.lastNum intValue])//可取消追期
            {
                self.cancelChase.hidden = NO;
            }
        }
            break;
        case 1:
        {
            stateLabel.text = [NSString stringWithFormat: @"(%@）",model.state];
            stateLabel.textColor = RGBCOLOR(194, 3, 23);
        }
            break;
        case 2://已取消
        {
            stateLabel.text = [NSString stringWithFormat: @"(%@）",@"已取消"];
            stateLabel.textColor = RGBCOLOR(194, 3, 23);
        }
            break;
        case 3://已追完
        {
            stateLabel.text = [NSString stringWithFormat: @"(%@）",@"已追完"];
             stateLabel.textColor = RGBCOLOR(194, 3, 23);
        }
        break;
        default:
            break;
    }
    
}

- (void)cancelChaseClick:(id)sender
{
    [self.mySuperViewController cancelChaseClick:self.model.tradeId];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
