//
//  ZC_LCB_SeeDetailTableViewCell.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-1-21.
//
//

#import <UIKit/UIKit.h>
//6场半 进球彩
@interface ZC_LCB_SeeDetailTableViewCell : UIView
{
    NSArray*                        m_contentStr;
    NSString                        *m_play;
    BOOL                            isZC_JQC;
}
@property(nonatomic, retain)NSString *play;
@property(nonatomic, assign)BOOL   isZC_JQC;
@property(nonatomic,retain) NSArray* contentStr;
@end
