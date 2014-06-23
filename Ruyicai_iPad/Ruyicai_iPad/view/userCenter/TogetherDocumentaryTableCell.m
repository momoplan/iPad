//
//  TogetherDocumentaryTableCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-11-11.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "TogetherDocumentaryTableCell.h"

@implementation TogetherDocumentaryTableCell
@synthesize docModel;
@synthesize delegate;
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
        
        kindLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 30)];
        kindLabel.font =[UIFont boldSystemFontOfSize:25];
        kindLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:kindLabel];
        
        stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x + kindLabel.frame.size.width +10, kindLabel.frame.origin.y+5, 100, 20)];
        stateLabel.backgroundColor =[UIColor clearColor];
        stateLabel.textColor = RGBCOLOR(46, 139, 42);
        [self.contentView addSubview:stateLabel];
        
        timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(kindLabel.frame.origin.x, 60, 300, 20)];
        timeLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:timeLabel];
        
        numberLabel =[[UILabel alloc]initWithFrame:CGRectMake(350, 20, 300, 20)];
        numberLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:numberLabel];
        
        
        UILabel *subLabel =[[UILabel alloc]initWithFrame:CGRectMake(numberLabel.frame.origin.x, 45, 100, 20)];
        subLabel.backgroundColor =[UIColor clearColor];
        subLabel.text = @"认购金额:";
        [self.contentView addSubview:subLabel];
        [subLabel release];
        
        monLabel =[[UILabel alloc]initWithFrame:CGRectMake(subLabel.frame.origin.x+subLabel.frame.size.width, 40, 150, 30)];
        monLabel.textColor =[UIColor redColor];
        monLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:monLabel];

        
        UIButton * detButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        detButton.frame = CGRectMake(600, 10, 120, 30);
        [detButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [detButton addTarget:self action:@selector(togetherDocDetailButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:detButton];
        
         modButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        modButton.frame = CGRectMake(detButton.frame.origin.x, detButton.frame.origin.y+40, detButton.frame.size.width, detButton.frame.size.height);
        [modButton setTitle:@"修改定制" forState:UIControlStateNormal];
        [modButton addTarget:self action:@selector(togetherModButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:modButton];
        
        
    }
    return self;
}
- (void)dealloc
{
    self.delegate = nil;
    [docModel release],docModel = nil;
    [monLabel release];
    [numberLabel release];
    [timeLabel release];
    [kindLabel release];
    [stateLabel release];
    
    [super dealloc];

}
- (void)togetherDocDetailButton:(id)sender
{
    [self.delegate queryTogetherDocTabelCellShowDetail:self.docModel];
}
- (void)togetherModButtonAction:(id)sender
{
    [self.delegate queryTOgetherTabelCellChangeState:self.docModel];
}
- (void)refreshTogetherDocumentaryCell
{
    kindLabel.text = docModel.lotName;
    timeLabel.text = docModel.createTime;
    numberLabel.text = [ NSString stringWithFormat:@"编号: %@",docModel.tradeId];
    monLabel.text =[ NSString stringWithFormat:@"%0.2f",[docModel.joinAmt intValue]/100.0 ];
    
    switch ([docModel.state intValue]) {
        case 0:
        {
            stateLabel.text =@"(无效）";
            stateLabel.textColor = [UIColor grayColor];
            [modButton setTitle:@"再次定制" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [modButton setTitle:@"再次定制" forState:UIControlStateNormal];

        }
            break;
        default:
            break;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
