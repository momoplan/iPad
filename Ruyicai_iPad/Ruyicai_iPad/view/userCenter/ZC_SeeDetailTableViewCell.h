//
//  ZC_SeeDetailTableViewCell.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-1-16.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#define betContentCellHeight (18)
#define zcCellHeight (55)

@interface ZC_SeeDetailTableViewCell : UIView
{
    NSArray*                   m_contentStr;
    NSString                   *m_play;
}

@property(nonatomic,retain) NSArray* contentStr;
@property(nonatomic,retain) NSString *play;
@end
