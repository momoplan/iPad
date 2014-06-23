//
//  MoreMessageViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  更多

#import "RootViewController.h"
#import "LotteryInformationViewController.h"
#import "HelpCenterViewController.h"
#import "ActivityCenterViewController.h"
#import "MoreSettingViewController.h"
#import "VersionInformationViewController.h"
#import "BaseHelpViewController.h"
#import "UserFeedbackViewController.h"
@interface MoreMessageViewController : RootViewController
<LotteryInfoViewDelegate,HelpCenterViewDelegate,ActivityCenterViewDelegate,
moreSettingViewDelegate,BaseHelpViewDelegate>
{
    
}
@end
