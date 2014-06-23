//
//  JC_SeeDetailTableViewCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-12-19.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define betContentCellHeight (18)
#define CellHeight (60)

@interface JC_SeeDetailTableViewCell : UIView<UITextViewDelegate>
{
    NSArray*                   m_contentStr;
}
@property(nonatomic, retain) NSArray* contentStr;
@property(nonatomic, retain)NSString*       jc_lotNo;
@property(nonatomic, retain)NSArray* contentHeight;//每场比赛的高度

@end
