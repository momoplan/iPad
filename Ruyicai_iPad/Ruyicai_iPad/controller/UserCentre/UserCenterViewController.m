//
//  UserCenterViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "UserCenterViewController.h"

@interface UserCenterViewController ()
{
    NSString * isNight;
}
@end

@implementation UserCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isNight =[[NSString alloc]initWithString:@"isnight"];
    userInfomationDic = [[NSMutableDictionary alloc]init];
	// Do any additional setup after loading the view.
    [self userTitleView];//标题
    [self userInfoTableView];//列表
    [self userDetailInfoView];//用户资料
    
}

- (void)dealloc
{
    [succeedView release];
    [notLoginView release];
    [userInfoArray release];
    [userInfomationDic release];

    if (loginTypeBtn) {
        [loginTypeBtn release];
    }
    [super dealloc];

}
#pragma mark --------- view create
//页面的标题
- (void)userTitleView
{
   
    [self.view addSubview:getTopLableWithTitle(@"用户中心")];

    if ([self isSuccessLogin]) {
        [self loginTypeButtonDraw];
    }
 
}
- (void)loginTypeButtonDraw
{
    if (loginTypeBtn) {
        [self.view addSubview:loginTypeBtn];
        loginTypeBtn.hidden = NO;
        return;
    }
    loginTypeBtn                    = [[UIButton alloc] init];
    loginTypeBtn.frame              = CGRectMake(800, 25, 100, 25);
    [loginTypeBtn setTitle:@"注销" forState:btnNormal];
    [loginTypeBtn setTintColor:[UIColor whiteColor]];
    [loginTypeBtn addTarget:self action:@selector(userCenterCancelLoginButton:) forControlEvents:btnTouch];
    [self.view addSubview:loginTypeBtn];
}
// 用户信息 列表
- (void)userInfoTableView
{
    UITableView * infoTabelView         =[[UITableView alloc]initWithFrame:CGRectMake(0, 70, 600, 650) style:UITableViewStyleGrouped];
    infoTabelView.backgroundColor       =[UIColor clearColor];
    infoTabelView.backgroundView        = nil;
    infoTabelView.delegate              = self;
    infoTabelView.dataSource            = self;
//    infoTabelView.separatorColor        =[UIColor whiteColor];
    [self.view addSubview:infoTabelView];
    [infoTabelView release];
}
//用户资料
- (void)userDetailInfoView
{
       userInfoArray = [[NSMutableArray alloc]initWithObjects:@"用户名",@"未设置" ,@"未绑定",@"未绑定",@"未绑定",@"0.00",@"0",nil];
    if ([self isSuccessLogin]) {
        [self userCenterSucceedView];
        [self userCenterRequestUserInfomation];
    }else{
        [self userCenterNotLoginView];
    }
    
}
- (void)userCenterNotLoginView
{
    if (!notLoginView) {
        /* 没有登录 */
        notLoginView            =[[UIView alloc]initWithFrame:CGRectMake(600, 68, 308, 650)];
        notLoginView.backgroundColor = RGBCOLOR(244, 244, 244);
        UIView *bgView          = [[UIView alloc]initWithFrame:CGRectMake(0, 0, notLoginView.frame.size.width, 43)];
        bgView.backgroundColor  = [UIColor colorWithPatternImage:RYCImageNamed(@"total_top_button_bg.png")];
        [notLoginView addSubview:bgView];
        [bgView release];
        
        UILabel *titLabel       =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 25)];
        titLabel.text           = @"尚未登录";
        titLabel.backgroundColor    = [UIColor clearColor];
        titLabel.font           = [UIFont systemFontOfSize:20];
        [notLoginView addSubview:titLabel];
        [titLabel release];
        
        UIButton *loginBtn      =[UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame          = CGRectMake(10, 60, 118, 41);
        [loginBtn setBackgroundImage:RYCImageNamed(@"userCenter_button_normal.png") forState:btnNormal];
        [loginBtn setBackgroundImage:RYCImageNamed(@"userCenter_button_click.png") forState:UIControlStateHighlighted];
        [loginBtn setTitleColor:[UIColor blackColor] forState:btnNormal];
        [loginBtn setTitle:@"用户登录" forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [loginBtn addTarget:self action:@selector(userCenterLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [notLoginView addSubview:loginBtn];
        
        UIButton * regBtn       =[UIButton buttonWithType:UIButtonTypeCustom];
        regBtn.frame            = CGRectMake(150, 60, 118, 41);
        [regBtn setBackgroundImage:RYCImageNamed(@"userCenter_button_normal.png") forState:btnNormal];
        [regBtn setBackgroundImage:RYCImageNamed(@"userCenter_button_click.png") forState:UIControlStateHighlighted];
        [regBtn setTitleColor:[UIColor blackColor] forState:btnNormal];
        [regBtn addTarget:self action:@selector(userCenterRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
        regBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [regBtn setTitle:@"注  册" forState:UIControlStateNormal];
        [notLoginView addSubview:regBtn];
        
        UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 150, notLoginView.frame.size.width, 2)];
        lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
        [notLoginView addSubview:lineView];
        [lineView release];
        
        UIView *leftLineView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, notLoginView.frame.size.height)];
        leftLineView.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"userCenter_left_line.png")];
        [notLoginView addSubview:leftLineView];
        [leftLineView release];

    }
    [self.view addSubview:notLoginView];

}
- (void)userCenterSucceedView
{
    /* 登录完成 */
    if (!succeedView) {
        succeedView             =[[UIView alloc]initWithFrame:CGRectMake(600, 68, 308, 650)];
        succeedView.backgroundColor = RGBCOLOR(244, 244, 244);
        //     if (![isNight isEqualToString:@"night"]) {
        //         succeedView.backgroundColor    =[UIColor whiteColor];
        //     }else{
        //          succeedView.backgroundColor   =[UIColor blackColor];
        //     }
        
        UIView *bgView          = [[UIView alloc]initWithFrame:CGRectMake(0, 0, succeedView.frame.size.width, 43)];
        bgView.backgroundColor  = [UIColor colorWithPatternImage:RYCImageNamed(@"total_top_button_bg.png")];
        [succeedView addSubview:bgView];
        [bgView release];
        
       
        
        UILabel *headLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, succeedView.frame.size.width-100, 40)];
        headLabel.backgroundColor =[UIColor clearColor];
        headLabel.text =@"用户资料";
        headLabel.font  = [UIFont systemFontOfSize:20];
//        if (![isNight isEqualToString:@"night"]) {
//            headLabel.backgroundColor =[UIColor whiteColor];
//            headLabel.textColor =[UIColor blackColor];
//        }else{
//            headLabel.backgroundColor =[UIColor blackColor];
//            headLabel.textColor =[UIColor whiteColor];
//        }
        [succeedView addSubview:headLabel];
        [headLabel release];
        
        UIView *leftLineView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, succeedView.frame.size.height)];
        leftLineView.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"userCenter_left_line.png")];
        [succeedView addSubview:leftLineView];
        [leftLineView release];
#define TagBingingLabel100 100
        
        NSArray * leftArray =[[NSArray alloc]initWithObjects:@"用户名:",@"昵称:",@"真实姓名:",@"身份证号:",@"手机号:",@"余额:",@"积分:", nil];
        for (int i=0; i<leftArray.count; i++) {
            
            UILabel *lefLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 50+(40*i), 100, 25)];
            if (![isNight isEqualToString:@"night"]) {
                lefLabel.backgroundColor =[UIColor clearColor];
                lefLabel.textColor = [UIColor blackColor];
            }else{
                lefLabel.backgroundColor =[UIColor blackColor];
                lefLabel.textColor = [UIColor whiteColor];
            }
            
            lefLabel.text = [leftArray objectAtIndex:i];
            [succeedView addSubview:lefLabel];
            [lefLabel release];
            
            
            UILabel *rigLabel =[[UILabel alloc]initWithFrame:CGRectMake(120, lefLabel.frame.origin.y, 150, 25)];
            if (![isNight isEqualToString:@"night"]) {
                rigLabel.backgroundColor =[UIColor clearColor];
                rigLabel.textColor = [UIColor blackColor];
            }else{
                rigLabel.backgroundColor =[UIColor blackColor];
                rigLabel.textColor = [UIColor whiteColor];
                
            }
            rigLabel.tag = TagBingingLabel100 + i;
            rigLabel.text = [userInfoArray objectAtIndex:i];
            [succeedView addSubview:rigLabel];
            [rigLabel release];
        }

        [leftArray release];
        
        
        
        UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 330, notLoginView.frame.size.width, 2)];
        lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
        [succeedView addSubview:lineView];
        [lineView release];
        
        
        UIButton * leaveButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        leaveButton.frame = CGRectMake(20, 350, 118, 41);
        [leaveButton setTitle:@"我的留言" forState:UIControlStateNormal];
        [leaveButton setBackgroundImage:RYCImageNamed(@"userCenter_button_normal.png") forState:btnNormal];
        [leaveButton setBackgroundImage:RYCImageNamed(@"userCenter_button_click.png") forState:UIControlStateHighlighted];
        leaveButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [leaveButton setTitleColor:[UIColor blackColor] forState:btnNormal];
        [leaveButton addTarget:self action:@selector(userCenterLeaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [succeedView addSubview:leaveButton];
        
        UIButton * passwordButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        passwordButton.frame = CGRectMake(150, leaveButton.frame.origin.y, 118, 40);
        [passwordButton setTitle:@"密码修改" forState:UIControlStateNormal];
        [passwordButton setBackgroundImage:RYCImageNamed(@"userCenter_button_normal.png") forState:btnNormal];
        [passwordButton setBackgroundImage:RYCImageNamed(@"userCenter_button_click.png") forState:UIControlStateHighlighted];
        passwordButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [passwordButton setTitleColor:[UIColor blackColor] forState:btnNormal];
        [passwordButton addTarget:self action:@selector(userCenterPassWordButton:) forControlEvents:UIControlEventTouchUpInside];
        [succeedView addSubview:passwordButton];
    }
    
    [self.view addSubview:succeedView];
  
}
- (void)succeedViewDetailWithDictionary
{
    
    for (int i=0; i<userInfoArray.count; i++) {
        UILabel * rigLabel = (UILabel *)[succeedView viewWithTag:TagBingingLabel100+i];
        
#define TagBingingButton500 500
        NSString * stringText = [userInfoArray objectAtIndex:i];
        switch (i) {
            case 0:
                rigLabel.text = stringText;
                break;
            case 1:{
                [[succeedView viewWithTag:TagBingingButton500 + i] removeFromSuperview];
                UIButton * btn  =[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame       = CGRectMake(120, rigLabel.frame.origin.y, 150, 25);
                btn.tag         = TagBingingButton500 + i;
                [btn setTitleColor:[UIColor blackColor] forState:btnNormal];
                [btn setBackgroundColor:RGBCOLOR(244, 244, 244)];
                [btn addTarget:self action:@selector(userCenterBingingPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
                if ([stringText isEqualToString:@"(点击设置)"]) {
                    
                    [btn setTitleColor:[UIColor blueColor] forState:btnNormal];
                    [btn setTitle:stringText forState:UIControlStateNormal];
                    [succeedView addSubview:btn];
                }
                else
                {
                    rigLabel.text = stringText;
                }
            }
                break;
            case 2:
            case 3:
            {
                [[succeedView viewWithTag:TagBingingButton500 + i] removeFromSuperview];

                UIButton * btn  =[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame       = CGRectMake(120, rigLabel.frame.origin.y, 150, 25);
                btn.tag         = TagBingingButton500 + i;
                [btn setTitleColor:[UIColor blackColor] forState:btnNormal];
                [btn setBackgroundColor:RGBCOLOR(244, 244, 244)];
                [btn addTarget:self action:@selector(userCenterBingingPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
                if ([stringText isEqualToString:@"(点击绑定身份证)"]) {
                    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    [btn setTitle:stringText forState:UIControlStateNormal];
                    [succeedView addSubview:btn];
                }else{
                    rigLabel.text = stringText;
                }
            }
                break;
            case 4:
            {
                [[succeedView viewWithTag:TagBingingButton500 + i] removeFromSuperview];

                UIButton * btn  =[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame       = CGRectMake(120, rigLabel.frame.origin.y, 150, 25);
                btn.tag         = TagBingingButton500 + i;
                [btn setBackgroundColor:RGBCOLOR(244, 244, 244)];
                [btn addTarget:self action:@selector(userCenterBingingPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
                if ([stringText isEqualToString:@"(点击绑定手机号)"]) {
                    [btn setTitle:stringText forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    [succeedView addSubview:btn];

                 }else
                 {
                     rigLabel.text = stringText;
                 }
            }
                break;
            case 5:
                rigLabel.text = stringText;
                rigLabel.textColor = [UIColor redColor];
                break;
            case 6:
                rigLabel.text = stringText;
                break;
            default:
                break;
        }

    }
    
        

}
#pragma mark ---------- RYCNetManager delegate
/* 请求用户信息 */
-(void)userCenterRequestUserInfomation
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"updateUserInfo" forKey:@"command"];
    [mDic setObject:@"userCenter" forKey:@"type"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeUserCenter showProgress:NO];
}
- (void)registerViewSuccessRegisterUserName:(NSString *)userName passWord:(NSString *)passWord
{
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"login" forKey:@"command"];
    [mDict setObject:userName forKey:@"phonenum"];
    [mDict setObject:passWord forKey:@"password"];
    [mDict setObject:@"0" forKey:@"isAutoLogin"];
    if([CommonRecordStatus commonRecordStatusManager].deviceToken)
    {
        [mDict setObject:[CommonRecordStatus commonRecordStatusManager].deviceToken forKey:@"token"];
        [mDict setObject:kTokenType forKey:@"type"];
    }
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeUserLogin showProgress:YES];
    
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeUserCenter://用户中心
        {
            [userInfomationDic addEntriesFromDictionary:dataDic];
            [self userCenterDataHandleToArray:dataDic];
        }
            break;
        case ASINetworkRequestTypeUserLogin: //登录
        {
            if ([KISDictionaryHaveKey(dataDic, @"error_code") isEqualToString:@"0000"]) {
                
                [UserLoginData sharedManager].userNo = KISDictionaryHaveKey(dataDic, @"userno");
                [UserLoginData sharedManager].hasLogin = YES;
                [UserLoginData sharedManager].userRealName = KISDictionaryHaveKey(dataDic, @"name");
                [UserLoginData sharedManager].userRealCard = KISDictionaryHaveKey(dataDic, @"certid");
                
                [[UserLoginData sharedManager] saveUserName:KISDictionaryHaveKey(dataDic, @"userName") AndrandomNumber:KISDictionaryHaveKey(dataDic, @"randomNumber") andUserPassword:@""];
                [[UserLoginData sharedManager] saveUserRealName:KISDictionaryHaveKey(dataDic, @"name") andUserRealCardId:KISDictionaryHaveKey(dataDic, @"certid")];
                
                [self loginViewSuccessLogin];
            }
        }
        case ASINetworkRequestTypeQueryDNA:{

            DrawMoneyViewController *drawMoney =[[DrawMoneyViewController alloc]init];
            drawMoney.delegate = self;
            drawMoney.drawbalanceString = [UserLoginData sharedManager].userDrawbalance;
            drawMoney.DNADataDic = dataDic;
            
            UIView* showView = drawMoney.view;
            showView.frame = CGRectMake(0, 0, 908, 720);
            [self.view addSubview:showView];
            CATransition *transition = [CATransition animation];
            transition.duration = .5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
            transition.subtype = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
            [showView.layer addAnimation:transition forKey:nil];
        }break;
        default:
            break;
    }
}

/* 得到得 用户数据 整理放入 数组中 */
- (void)userCenterDataHandleToArray:(NSDictionary*)mDic
{
    [[NSUserDefaults standardUserDefaults] setObject:[mDic objectForKey:@"bet_balance"] forKey:kSaveBetBalance];

    NSMutableArray *array =[[NSMutableArray alloc]init];
    [array addObject:[mDic objectForKey:@"userName"]];
    if (![[mDic objectForKey:@"nickName"]isEqualToString:@""]) {
        [array addObject:[mDic objectForKey:@"nickName"]];
    }else{
        [array addObject:@"(点击设置)"];
    }
    if (![[mDic objectForKey:@"certId"]isEqualToString:@""]) {
        [UserLoginData sharedManager].userRealCard = [mDic objectForKey:@"certId"];
        
        NSString * selfCardName = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveRealName];
        NSString * selfCardNum = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveRealCard];
         [array addObject:[selfCardName stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"]];
        [array addObject: [selfCardNum stringByReplacingCharactersInRange:NSMakeRange(4, 10) withString:@"*****"]];
    }else{
        [array addObject:@"(点击绑定身份证)"];
        [array addObject:@"(点击绑定身份证)"];
    }
    if (![[mDic objectForKey:@"mobileId"] isEqualToString:@""]) {
        NSString *mobileNum = KISDictionaryHaveKey(userInfomationDic, @"mobileId");
        [array addObject: [ mobileNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    }else{
        [array addObject:@"(点击绑定手机号)"];
    }
    
    [array addObject:[mDic objectForKey:@"bet_balance"]];
    [array addObject:[mDic objectForKey:@"score"]];
    
    [userInfoArray removeAllObjects];
    [userInfoArray addObjectsFromArray:array];
    [self succeedViewDetailWithDictionary];
    [array release];
}
#pragma mark ---------- methods
#define TagAlertView200 200
/* 取消自动登录 */
- (void)userCenterCancelLoginButton:(id)sender
{
    
    UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定注销登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = TagAlertView200;
    [alertView show];
    [alertView release];

}
/* 绑定 手机号 */
- (void)userCenterBingingPhoneButton:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag - TagBingingButton500) {
        case 1://昵称
        {
            if ([btn.titleLabel.text isEqualToString:@"(点击设置)"]) {
                BingingNickNameViewController *bingNickName =[[[BingingNickNameViewController alloc]init]autorelease];
                bingNickName.delegate                       = self;
                bingNickName.modalTransitionStyle           = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:bingNickName animated:YES completion:^{
                    
                }];
            }else
            {
                
            }
        }
            break;
        case 2://身份证
        case 3:
        {
            BingingIDCardViewController * bingCard =[[BingingIDCardViewController alloc]init];
            bingCard.delegate = self;
            bingCard.cardNumText = KISDictionaryHaveKey(userInfomationDic, @"certId");
            bingCard.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:bingCard animated:YES completion:^{
                
            }];
            [bingCard release];
            
        }
            break;
        case 4://手机号
        {
            BindingPhoneViewController * bingPhone  =[[BindingPhoneViewController alloc]init];
            bingPhone.delegate                      = self;
            bingPhone.bingPhoneNumber               = KISDictionaryHaveKey(userInfomationDic, @"mobileId");
            bingPhone.modalTransitionStyle          = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:bingPhone animated:YES completion:^{
                
            }];
            [bingPhone release];
        }
            break;
        default:
            break;
    }
  
}
#pragma mark  我的留言 
- (void)userCenterLeaveButton:(id)sender
{
    MyMessageViewController *messageView =[[MyMessageViewController alloc]init];
    messageView.delegate = self;
    
    messageView.view.frame =CGRectMake(0, 0, 908, 720);
    [self.view addSubview:messageView.view];
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    transition.subtype = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
    [messageView.view.layer addAnimation:transition forKey:nil];
}
/* 密码修改 */
- (void)userCenterPassWordButton:(id)sender
{
    ModifyPasswordViewController * modifyPassword =[[ModifyPasswordViewController alloc]init];
    modifyPassword.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:modifyPassword animated:YES completion:^{
        
    }];
    [modifyPassword release];
}
/* 用户登录 */
- (void)userCenterLoginButton:(id)sender
{
    LoginViewController *loginView =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    loginView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    loginView.delegate = self;
    [self presentViewController:loginView animated:YES completion:^{
        
    }];
    [loginView release];
}
/*  用户注册*/
- (void)userCenterRegisterButton:(id)sender
{
    RegisterViewController *registerView =[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    registerView.delegate = self;
    registerView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:registerView animated:YES completion:^{
        
    }];
    [registerView release];
}

#pragma mark ----------------- alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TagAlertView200) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [UserLoginData sharedManager].hasLogin = NO;
            [[UserLoginData sharedManager] clearUserInfomation];
            
            [succeedView removeFromSuperview];
            [self userCenterNotLoginView];
            
            loginTypeBtn.hidden = YES;
            //    [loginTypeBtn removeFromSuperview];
        }
    }
}
#pragma mark -------- infoTableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 5;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"账号资金";
    }
    return @"我的彩票";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return  60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * celled = @"celled";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell == nil) {
        cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celled]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *array1 =[[NSArray alloc]initWithObjects:@"user_cash.png",@"user_account.png",@"user_balance.png",
                     @"user_integral.png",nil];
    NSArray *array2 =[[NSArray alloc]initWithObjects:@"user_win.png",@"user_bet.png",@"user_trace.png",@"user_gift.png",@"user_hm.png",@"user_message.png", nil];
    NSArray * tetArray1 = [[NSArray alloc]initWithObjects:@"账户提现",@"账户明细",@"资金详情",@"我的积分", nil];
    NSArray * tetArray2 =[[NSArray alloc]initWithObjects:@"中奖查询",@"投注查询",@"追号查询",@"赠彩查询",@"我的合买",@"我的消息", nil];
    NSString *cellString = nil;
    NSString * imgString = nil;
    switch (indexPath.section) {
        case 0:
        {
            cellString = [tetArray1 objectAtIndex:indexPath.row];
            imgString =[array1 objectAtIndex:indexPath.row];
        }
            break;
        case 1:
        {
            imgString =[array2 objectAtIndex:indexPath.row];
            cellString = [tetArray2 objectAtIndex:indexPath.row];
        }
        default:
            break;
    }
    [array1 release];
    [array2 release];
    [tetArray1  release];
    [tetArray2 release];
    cell.textLabel.text = cellString;
//    if (![isNight isEqualToString:@"night"]) {
//        cell.textLabel.textColor =[UIColor grayColor];
//        
//    }else{
//       cell.textLabel.textColor =[UIColor whiteColor];
//        cell.backgroundColor =[UIColor blackColor];
//        cell.imageView.alpha =0.6;
//    }
//   

    cell.imageView.image =[UIImage imageNamed:imgString];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![self isSuccessLogin]) {
        [self userCenterLoginButton:nil];
        return;
    }
    UIView *showView =nil;
    switch (indexPath.section) {
        case 0://账号资金
        {
            switch (indexPath.row) {
                case 0:// 提现
                {
                    if (  [[UserLoginData sharedManager].userRealCard isEqualToString:@""]) {
                        [self showAlertWithMessage:@"为了保障您的账户安全，请您先完成绑定身份证信息后再进行提现操作，谢谢！"];
                        return;
                    }
                    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
                    [mDict setObject:@"AllQuery" forKey:@"command"];
                    [mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
                    [mDict setObject:@"dna" forKey:@"type"];
                    
                    [RYCNetworkManager sharedManager].netDelegate = self;
                    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeQueryDNA showProgress:YES];
                }
                    break;
                case 1://账户明细
                {
                    AccountDetailViewController *accountDetail =[[AccountDetailViewController alloc]init];
                    accountDetail.delegate = self;
                    showView = accountDetail.view;
                }
                    break;
                case 2://资金详情
                {
                    FundDetailViewController * fundDetail =[[FundDetailViewController alloc]init];
                    fundDetail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:fundDetail animated:YES completion:^{
                        
                    }];
                    [fundDetail release];
                }
                    break;
                case 3://我的积分
                {
                    IntegralDetailViewController *integralDetail =[[IntegralDetailViewController alloc]init];
                    integralDetail.userScore =[userInfoArray objectAtIndex:6];
                    integralDetail.delegate = self;
                    showView = integralDetail.view;
                }
                default:
                
                    break;
            }
            
        }
            break;
        case 1://我的彩票
        {
            switch (indexPath.row) {
                case 0://中奖查询
                {
                    QueryWinningViewController *queryWin = [[QueryWinningViewController alloc]init];
                    queryWin.delegate = self;
                    showView = queryWin.view;
                }
                    break;
                 case 1://投注查询
                {
                    QueryBetViewController *queryBet =[[QueryBetViewController alloc]init];
                    queryBet.delegate = self;
                    showView = queryBet.view;
                }
                    break;
                case 2://追号查询
                {
                    QueryChaseViewController *queryChase =[[QueryChaseViewController alloc]init];
                    queryChase.delegate = self;
                    showView = queryChase.view;
                }
                    break;
                case 3://增彩查询
                {
                    QueryPresentViewController *queryPresent =[[QueryPresentViewController alloc]init];
                    queryPresent.delegate = self;
                    showView = queryPresent.view;
                }
                    break;
                case 4://我的合买
                    
                {
                    QueryTogetherViewController *queryTogether =[[QueryTogetherViewController alloc]init];
                    queryTogether.delegate = self;
                    showView = queryTogether.view;
                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
    showView.frame = CGRectMake(0, 0, 908, 720);
    [self.view addSubview:showView];
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    transition.subtype = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
    [showView.layer addAnimation:transition forKey:nil];
}
#pragma mark  ------------  view delegate
/* 提现*/
- (void)drawMoneyViewDisappear:(DrawMoneyViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];

}
/* 账户明细 */
- (void)accountDetailViewDisappear:(AccountDetailViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];
}
/* 我的积分*/
- (void)integralDetailViewDisappear:(IntegralDetailViewController *)viewController
{
    if ([viewController.userScore floatValue]) {
        
    }
    [self userCenterRequestUserInfomation];
    [self rootViewControllerDisappear:viewController];
}
/* 中奖查询*/
- (void)queryWinningViewDisappear:(QueryWinningViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];
}
/* 投注查询*/
- (void)queryBetViewDisappear:(QueryBetViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];

}
/* 追号查询*/
- (void)queryChaseViewDisappear:(QueryChaseViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];
}
/* 赠彩查询 */
- (void)queryPresentViewDisappear:(QueryPresentViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];
}
/* 我的合买*/
- (void)queryTogetherViewDisappear:(QueryTogetherViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];
}
/* 我的留言 */
- (void)myMessageViewDisappear:(UIViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];
}
/* 手机号绑定成功 */
- (void)bingingPhonebingSucceed
{
    [self userCenterRequestUserInfomation];
}
- (void)bingingPhoneNumberClearSucceed
{
    [self userCenterRequestUserInfomation];
}
/* 身份证绑定成功 */
- (void)bingingIDCardOperateSucceed
{
    [self userCenterRequestUserInfomation];
}
#pragma mark 登录成功
- (void)loginViewSuccessLogin
{
    if ([self isSuccessLogin]) {
        
        [self userCenterRequestUserInfomation];
        [notLoginView removeFromSuperview];
        [self userCenterSucceedView];
        [self loginTypeButtonDraw];
    
    }
}
- (void)bingNickNameSetSucceed
{
    if([self isSuccessLogin]){
        [self userCenterRequestUserInfomation];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
