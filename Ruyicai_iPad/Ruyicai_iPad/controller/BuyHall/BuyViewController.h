//
//  BuyViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 购彩大厅

#import "RootViewController.h"
#import "RYNarBarView.h"

#import "TicketKindViewController.h"//双色球
#import "DLT_PickNumberViewController.h" //大乐透
#import "FC3DPickViewController.h"//福彩3d
#import "SSCPickNumViewController.h" // 时时彩
#import "GD11X5PickNumerViewController.h" // 广东11选5
#import "BuyAdShowViewController.h"
#import "LoginViewController.h"
#import "MobClick.h"//友盟

@interface BuyViewController : RootViewController
<RYNarBarViewDelegate,TicketKindDelegate,DLT_PickNumberViewDelegate,
FC3DPickViewDelegate,SSCPickNumViewDelegate,GD11X5PickNumberViewDelegate,LoginViewControllerDelegate>
{
    BuyAdShowViewController *buyAdShowView;
    UIButton                *itemBtn;
}
@end
