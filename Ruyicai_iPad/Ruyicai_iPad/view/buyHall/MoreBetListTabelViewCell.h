//
//  MoreBetListTabelViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-3.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreBetListTabelViewCell : UITableViewCell
{
    
    UILabel*  redLabel;
    UILabel*  blueLabel;
    
    UILabel*  inforLabel;
}
@property (nonatomic,retain) NSDictionary * messDic;
- (void)refreshCellView;
@end
