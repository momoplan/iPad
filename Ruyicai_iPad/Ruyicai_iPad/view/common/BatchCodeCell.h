//
//  BatchCodeCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-11.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatchCodeCell : UITableViewCell
<UITextFieldDelegate>
{
    UILabel* batchCodeLabel;
}
- (void)refreshCellView;
@property (nonatomic,retain) NSString *stageStr;
@end
