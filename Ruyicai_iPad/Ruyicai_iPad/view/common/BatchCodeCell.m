//
//  BatchCodeCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-11.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "BatchCodeCell.h"

@implementation BatchCodeCell
@synthesize stageStr;
- (void)dealloc
{
    [stageStr release],stageStr = nil;
    [super dealloc];

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIButton* listButton    = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
        [listButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateNormal];
        [listButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateHighlighted];
        [listButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:listButton];
        [listButton release];
        
        batchCodeLabel                      = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 110, 25)];
        batchCodeLabel.text                 = [NSString stringWithFormat:@"%@期", @"2013080"];
        batchCodeLabel.textColor            = [UIColor blackColor];
        batchCodeLabel.textAlignment        = NSTextAlignmentLeft;
        batchCodeLabel.backgroundColor      = [UIColor clearColor];
        [self.contentView addSubview:batchCodeLabel];
        [batchCodeLabel release];
        
        UITextField* lotMuField             = [[UITextField alloc] initWithFrame:CGRectMake(150, 3, 50, 25)];
        lotMuField.borderStyle              = UITextBorderStyleBezel;
        lotMuField.delegate                 = self;
        lotMuField.placeholder              = @"倍数";
//        lotMuField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        lotMuField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        lotMuField.keyboardType = UIKeyboardTypeEmailAddress;
//        lotMuField.keyboardAppearance = UIKeyboardAppearanceAlert;
//        //lotMuField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        lotMuField.autocorrectionType = UITextAutocorrectionTypeNo;
//        lotMuField.returnKeyType = UIReturnKeyDone;
        lotMuField.textColor                = [UIColor blackColor];
        lotMuField.text                     = [NSString stringWithFormat:@"%d", 1];
        [self.contentView addSubview:lotMuField];
        [lotMuField release];
        
        UILabel* lotmuLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(200, 3, 10, 25)];
        lotmuLabel.text                     = @"倍";
        lotmuLabel.textColor                = [UIColor blackColor];
        lotmuLabel.textAlignment            = NSTextAlignmentLeft;
        lotmuLabel.backgroundColor          = [UIColor clearColor];
        [self.contentView addSubview:lotmuLabel];
        [lotmuLabel release];
        
        UILabel* amountLabel                = [[UILabel alloc] initWithFrame:CGRectMake(210, 3, 50, 25)];
        amountLabel.text                    = [NSString stringWithFormat:@"%d", 2];
        amountLabel.textColor               = [UIColor redColor];
        amountLabel.textAlignment           = NSTextAlignmentRight;
        amountLabel.backgroundColor         = [UIColor clearColor];
//        amountLabel.tag = AmountLabelTagStart + i;
        [self.contentView addSubview:amountLabel];
        [amountLabel release];
        
        UILabel* danWeiLabel                = [[UILabel alloc] initWithFrame:CGRectMake(260, 3, 15, 25)];
        danWeiLabel.text                    = @"元";
        danWeiLabel.textColor               = [UIColor blackColor];
        danWeiLabel.textAlignment           = NSTextAlignmentLeft;
        danWeiLabel.backgroundColor         = [UIColor clearColor];
        [self.contentView addSubview:danWeiLabel];
        [danWeiLabel release];
    }
    return self;
}
- (void)refreshCellView
{
    batchCodeLabel.text = stageStr;
}
- (void)selectButtonClick:(id)sender
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
