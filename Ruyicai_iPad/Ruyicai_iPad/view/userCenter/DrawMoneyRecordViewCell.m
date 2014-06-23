//
//  DrawMoneyRecordViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "DrawMoneyRecordViewCell.h"

@implementation DrawMoneyRecordViewCell
@synthesize cellState;
@synthesize cashModel;
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self drawContentCell];
    }
    return self;
}
- (void)dealloc
{
    [stateLabel release];
    [cashModel release],cashModel = nil;
    [dateLabel release];
    [sumLabel release];
    self.delegate = nil;
    [super dealloc];

}
#pragma mark -------- contentView
- (void)drawContentCell
{
    UIImageView * topView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 560, 44)];
    topView.image = [UIImage imageNamed:@"draw_cell_top.png"];
    [self.contentView addSubview:topView];
    [topView release];
    
    UIImageView * bottomView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"draw_cell_bottom.png"]];
    bottomView.frame = CGRectMake(topView.frame.origin.x, topView.frame.origin.y+topView.frame.size.height, topView.frame.size.width, 44);
    [self.contentView addSubview:bottomView];
    [bottomView release];
    
    dateLabel =[[UILabel alloc]initWithFrame:CGRectMake( 30,20, 300, 20)];
    dateLabel.text = @"提现日期: 2013-7-23 15:47:31";
    dateLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:dateLabel];
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(dateLabel.frame.origin.x, 60, 50, 20)];
    label.text = @"金额:";
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
    [label release];
    
    sumLabel =[[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x+20, label.frame.origin.y, 200, 20)];
    sumLabel.backgroundColor = [UIColor clearColor];
    sumLabel.text = @"50.00元";
    sumLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:sumLabel];
    
    stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(500, label.frame.origin.y, 60, 20)];
    stateLabel.text =@"取消";
    stateLabel.backgroundColor = [UIColor clearColor];
    stateLabel.textColor =[UIColor grayColor];
    [self.contentView addSubview:stateLabel];
   
    cancelBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame =CGRectMake(500, 15, 60, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"buyNormal.png"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(drawCellCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    cancelBtn.hidden = YES;

}
- (void)refreshCellView
{
    dateLabel.text  = [NSString stringWithFormat:@"提现日期:  %@",cashModel.cashTime];
    sumLabel.text   = [NSString stringWithFormat:@"%0.2f元",[cashModel.amount intValue]/100.0];
    
    
    int state =[cashModel.state intValue];
    switch (state) {
        case 1: // 待审核
        {
            stateLabel.text =cashModel.stateMemo;
            stateLabel.textColor =[UIColor orangeColor];
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            cancelBtn.hidden = NO;
        }
            break;
        case 103: // 已审核
        {
            stateLabel.text =cashModel.stateMemo;
            stateLabel.textColor = [UIColor redColor];
             cancelBtn.hidden = YES;
        }
            break;
        case 104: // 驳回
        {
            stateLabel.text =cashModel.stateMemo;
            stateLabel.textColor = [UIColor grayColor];
            [cancelBtn setTitle:@"原因" forState:UIControlStateNormal];
            cancelBtn.hidden = NO;
        }
            break;
        case 105: // 成功
        {
            stateLabel.text =cashModel.stateMemo;
            stateLabel.textColor = [UIColor redColor];
            cancelBtn.hidden = YES;
        }
            break;
        case 106: // 取消
        {
            stateLabel.text =cashModel.stateMemo;
            stateLabel.textColor = [UIColor grayColor];
            cancelBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
}
- (void)drawCellCancelButton:(id)sender
{
    if ([cashModel.state isEqualToString:@"104"]) {
        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:cashModel.rejectReason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
   
    if ([cashModel.state isEqualToString:@"1"]) {
        [self.delegate drawMoneyRecordCancelCashId:cashModel.cashdetailid];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
