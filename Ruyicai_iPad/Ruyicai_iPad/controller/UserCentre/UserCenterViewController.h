//
//  UserCenterViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 用户中心

#import "RootViewController.h"
#import "DrawMoneyViewController.h"
#import "AccountDetailViewController.h"
#import "FundDetailViewController.h"
#import "IntegralDetailViewController.h"
#import "QueryWinningViewController.h"
#import "QueryBetViewController.h"
#import "QueryChaseViewController.h"
#import "QueryPresentViewController.h"
#import "QueryTogetherViewController.h"
#import "MyMessageViewController.h"
#import "ModifyPasswordViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "BindingPhoneViewController.h"
#import "BingingIDCardViewController.h"
#import "BingingNickNameViewController.h"
@interface UserCenterViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate,DrawMoneyViewControllerDelegate,AccountDetailViewControllerDelegate,
IntegralDetailViewContorollerDelegate,QueryWinningViewControllerDelegate,QuetyBetViewControllerDelegate,
QueryChaseViewControllerDelegate,QueryPresentViewControllerDelegate,QueryTogetherViewControllerDelegate,MyMessageViewControllerDelegate,LoginViewControllerDelegate,RegisterViewDelegate,bingingPhoneViewDelegete,bingingIDCardViewDelegate,
BingingNickNameViewDelegate,UIAlertViewDelegate>
{
    UIView          * succeedView;      // 登陆成功
    UIView          * notLoginView;     // 未登陆
    NSMutableArray  * userInfoArray;    // 用户信息
    UIButton        * loginTypeBtn;     // 注销 登陆按钮
    NSMutableDictionary    * userInfomationDic;// 用户信息字典
}
@end
