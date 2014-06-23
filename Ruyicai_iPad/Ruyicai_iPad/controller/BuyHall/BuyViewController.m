//
//  BuyViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "BuyViewController.h"
#import "RYNarBarView.h"

#define TAG_BUYTICKETKIND_BUTTON 200
#define TagAdButton103 103



@interface BuyViewController ()

@end

@implementation BuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [buyAdShowView release];
    
    [super dealloc];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 设置自定义导航
    [self addNarBarView];
    // 设置广告栏
    [self addAdView];
    // 设置彩种 列表
    [self addKindsOfTicketView];
    
    [self getTopNewsContent];
    
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self requestTodayOpenOrAdd];
}
- (void)viewDidAppear:(BOOL)animated; 
{
    [super viewDidAppear:animated];
    if ([self isSuccessLogin]){
        [self  sendRequestUserBalance];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:kSaveRandomSate] isEqualToString:@"1"])//自动登陆
    {
        [itemBtn setTitle:@"" forState:btnNormal];
    }
    else{
        [itemBtn setTitle:@"登录注册" forState:btnNormal];
        itemBtn.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark =================== notification
- (void)requestTodayOpenOrAdd
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"select" forKey:@"command"];
    [mDic setObject:@"buyCenter" forKey:@"requestType"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeQueryTodayOpen showProgress:NO];
}
-(void)sendRequestUserBalance
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"AllQuery" forKey:@"command"];
    [mDic setObject:@"balance" forKey:@"type"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeQueryBalance showProgress:NO];
}
- (void)getTopNewsContent
{
   
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"information" forKey:@"command"];
    [mDic setObject:@"topNews" forKey:@"newsType"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkReqestTypeGetTopNews showProgress:NO];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryTodayOpen:
        {
            [self buyCenterTicketStataDictionary:dataDic];
        }
            break;
        case ASINetworkReqestTypeGetTopNews:
        {
            [self adButtonRefreshTitleDictionary:dataDic];
        }
            break;
        case ASINetworkRequestTypeQueryBalance:
        {
            [itemBtn setTitle: [NSString stringWithFormat:@"余额:%@",KISDictionaryHaveKey(dataDic, @"bet_balance")] forState:btnNormal];
            itemBtn.enabled = NO;
        }
        default:
            break;
    }
}
// 购彩中心 开奖 加奖状态
- (void)buyCenterTicketStataDictionary:(NSDictionary *)dataDic
{
    
    NSString *errorCode = KISDictionaryHaveKey(dataDic, @"error_code");
    if ([errorCode isEqualToString:@"0000"]) {
        NSArray * result = KISDictionaryHaveKey(dataDic, @"result");
        NSMutableDictionary* lotStateDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        for (int i = 0; i < [result count]; i++) {
            [lotStateDic addEntriesFromDictionary:[result objectAtIndex:i]];
        }
//        NSDictionary * ssqDic =KISDictionaryHaveKey(lotStateDic, kLotNoSSC);
//        NSString * addAwardState=KISDictionaryHaveKey(ssqDic, @"addAwardState");
//        NSString *saleState =KISDictionaryHaveKey(ssqDic, @"saleState");
//        DLog(@"addAwardState %@ \nisTodayOpenPrize%@",addAwardState,saleState);
        [self refreshKindsOfTicketState:lotStateDic];
        [lotStateDic release];
    }else
    {
        [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
    }

}
- (void)adButtonRefreshTitleDictionary:(NSDictionary *)dataDic
{
    NSString * title = KISDictionaryHaveKey(dataDic, @"title");
    UIButton * adBtn =(UIButton *)[self.view viewWithTag:TagAdButton103];
    [adBtn setTitle:title forState:btnNormal];
    buyAdShowView =[[BuyAdShowViewController alloc]init];
    buyAdShowView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    buyAdShowView.dataDic = dataDic;
    
}
#pragma mark -------------- addView

- (void)addNarBarView
{
    [self.view addSubview:getTopLableWithTitle(@"购彩大厅")];

    
    //右边登陆按钮
    itemBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.frame = CGRectMake(730, 25, 180, 25);
    [itemBtn setTitle:@"登陆注册" forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(narBarButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:itemBtn];
    
}
- (void)addAdView
{
    UIButton * adButton = [UIButton buttonWithType:UIButtonTypeCustom]; //创建按钮
    [adButton setBackgroundImage:RYCImageNamed(@"main_title_bg.png") forState:btnNormal];
    [adButton setTitleColor:RGBCOLOR(102, 102, 102) forState:btnNormal];
    [adButton  setTitle:@"网站最新通知公告" forState: UIControlStateNormal];  //按钮标题
    adButton.titleLabel.font =[UIFont boldSystemFontOfSize:20];
    adButton.tag = TagAdButton103;
    adButton.frame = CGRectMake(0, 68, self.view.frame.size.height-118, 44); //尺寸
    [adButton addTarget:self action:@selector(adButtonClick:) forControlEvents:UIControlEventTouchUpInside]; //绑定事件
    [self.view addSubview:adButton]; //加载视图
    
}
#define TicketButtonWidthValue 130
- (void)addKindsOfTicketView
{
    UIScrollView * kindScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 112, 908, 606)]; //定义后面可滑动
    
    kindScrollView.backgroundColor = RGBCOLOR(220, 220, 220); //背景颜色
    NSArray * itemArray = [[NSArray alloc]initWithObjects:@"双色球",@"大乐透",@"福彩3D",@"时时彩",@"广东11选5", nil]; //彩票种类
    NSArray * itemImgArray =@[@"main_ico_double",@"main_ico_super",@"main_ico_3d",@"main_ico_timec",@"main_ico_gz115"];
    for (int i = 0; i<itemArray.count; i++) { //用for循环来 加载彩种
        
        //图标按钮
        UIButton * ticketBtn =[UIButton buttonWithType:UIButtonTypeCustom]; //类方法实例按钮
        ticketBtn.frame = CGRectMake(50+160*i, 80, TicketButtonWidthValue, TicketButtonWidthValue); //设置尺寸
        ticketBtn.tag = TAG_BUYTICKETKIND_BUTTON + i;// tag标示
        [ticketBtn setImage:[UIImage imageNamed:[itemImgArray objectAtIndex:i]] forState:UIControlStateNormal]; //记载图片
        [ticketBtn addTarget:self action:@selector(showDetailTicket:) forControlEvents:UIControlEventTouchUpInside]; //绑定事件
        [kindScrollView addSubview:ticketBtn]; //放入滑动视图中
        
        // 彩种名称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40+160*i , 210, TicketButtonWidthValue, 30)]; //实例化label
        nameLabel.backgroundColor = [UIColor clearColor];//背景颜色为透明
        nameLabel.font =[UIFont systemFontOfSize:20];
        nameLabel.textAlignment = NSTextAlignmentCenter;//居中显示
        nameLabel.text = [itemArray objectAtIndex:i];//显示文字
        [kindScrollView addSubview:nameLabel];//放入视图中
        [nameLabel release];//释放
    }
    [itemArray release];
    [self.view addSubview:kindScrollView];//滚动视图 加在主视图上
    [kindScrollView release];//释放
    
}
#define TagJiaJiangImg100 100
#define TagKaiJiangImg101 101
#define TagStopSaleImg102 102
- (void)refreshKindsOfTicketState:(NSDictionary*)addOrOpenDic
{
    NSArray * keyArray =@[kLotNoSSQ,kLotNoDLT,kLotNoFC3D,kLotNoSSC,kLotNoGD115];
    
    for (int i=0; i<keyArray.count; i++) {
        NSDictionary * stateDic =KISDictionaryHaveKey(addOrOpenDic, [keyArray objectAtIndex:i]);
         UIButton * button =(UIButton *)[self.view viewWithTag:TAG_BUYTICKETKIND_BUTTON+i];
        if([KISDictionaryHaveKey(stateDic, @"addAwardState") isEqualToString:@"1"])
        {
            [[button  viewWithTag:TagJiaJiangImg100] removeFromSuperview];
            UIImageView*  jiaImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 5, TicketButtonWidthValue-65, TicketButtonWidthValue-65)];
            jiaImg.image = RYCImageNamed(@"jiajiang_right.png");
            jiaImg.backgroundColor = [UIColor clearColor];
            jiaImg.tag = TagJiaJiangImg100;
            [button addSubview:jiaImg];
            [jiaImg release];
        }
        else
        {
            [[button viewWithTag:TagJiaJiangImg100] removeFromSuperview];
        }
        if([KISDictionaryHaveKey(stateDic, @"isTodayOpenPrize") isEqualToString:@"true"])
        {
            [[button viewWithTag:TagKaiJiangImg101] removeFromSuperview];
            UIImageView*  openImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 5, TicketButtonWidthValue-65, TicketButtonWidthValue-65)];
            openImg.image = RYCImageNamed(@"kaijiang_right.png");
            openImg.backgroundColor = [UIColor clearColor];
            openImg.tag = TagKaiJiangImg101;
            [button addSubview:openImg];
            [openImg release];
        }
        else
        {
            [[button viewWithTag:TagKaiJiangImg101] removeFromSuperview];
        }
        if([KISDictionaryHaveKey(stateDic, @"saleState") isEqualToString:@"0"])
        {
            [[button viewWithTag:TagStopSaleImg102] removeFromSuperview];
            
            UIImageView*  stopImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 5, TicketButtonWidthValue-65, TicketButtonWidthValue-65)];
            stopImg.image = RYCImageNamed(@"tingshou_right.png");
            stopImg.backgroundColor = [UIColor clearColor];
            stopImg.tag = TagStopSaleImg102;
            [button addSubview:stopImg];
            [stopImg release];
        }
        else
        {
            [[button viewWithTag:TagStopSaleImg102] removeFromSuperview];            
        }       
    }
    
}
#pragma mark ---------------  narBarDelegate
//narbar 方法
- (void)narBarButtonEvent:(id)sender
{
    DLog(@"登陆");
    if (![self isSuccessLogin]) {
        LoginViewController *login =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        login.delegate = self;
        login.view.backgroundColor = [UIColor clearColor];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:^{
            
        }];
        [login release];
    }
}
- (void)loginViewSuccessLogin
{
    if ([self isSuccessLogin]) {
        [self  sendRequestUserBalance];
    }

}
#pragma mark --------------- methods 
// 广告按钮 事件
- (void)adButtonClick:(id)sender
{
    if (buyAdShowView) {
        [self presentViewController:buyAdShowView animated:YES completion:^{}];
    }
}

// 彩种按钮 事件
- (void)showDetailTicket:(id)sender
{
    UIButton * kindBtn = (UIButton *)sender;
    UIView *view=nil;
    int tag = kindBtn.tag - TAG_BUYTICKETKIND_BUTTON;
    
    switch (tag) {
        case 0://双色球
        {
            TicketKindViewController * kindViewC = [[TicketKindViewController alloc]init];
            kindViewC.delegate = self;
            view = kindViewC.view;
            
        }
            break;
        case 1://大乐透
        {
            DLT_PickNumberViewController * dltPickNum =[[DLT_PickNumberViewController alloc]init];
            dltPickNum.delegate = self;
            view = dltPickNum.view;
        }
            break;
        case 2://福彩3d
        {
            FC3DPickViewController * fcPickView =[[FC3DPickViewController alloc]init];
            fcPickView.delegate = self;
            view = fcPickView.view;
        }
            break;
        case 3: // 时时彩
        {
            SSCPickNumViewController *sscPickView =[[SSCPickNumViewController alloc]init];
            sscPickView.delegate = self;
            view = sscPickView.view;
        }
            break;
        case 4: // 广东11x5
        {
            GD11X5PickNumerViewController * GD11X5PickView =[[GD11X5PickNumerViewController alloc]init];
            GD11X5PickView.delegate = self;
            view = GD11X5PickView.view;
        }
            break;
        default:
            break;
    }
    view.frame  = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width-22 , 0);
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:.5];
    [UIView  setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //动画的内容
    view.frame  = CGRectMake(0, 0, self.view.frame.size.width-22 , self.view.frame.size.height-28);
    [self.view addSubview:view];
    //动画结束
    [UIView commitAnimations];
}

#pragma mark -------------- picknumviewcontroller delegate
- (void)disMissTicketKindViewController:(TicketKindViewController *)controller
{
    [self viewControllerDisappear:controller];
}
- (void)DLT_PickNumberViewDisappear:(UIViewController *)viewController
{
   [self viewControllerDisappear:viewController];
}
- (void)FC3DPickViewDisappear:(UIViewController *)controller
{
   [self viewControllerDisappear:controller];
}
- (void)SSCPickViewDisappear:(UIViewController *)viewController
{
    [self viewControllerDisappear:viewController];
}
- (void)GD11X5PickNumberViewDisappear:(UIViewController *)viewController
{
    [self viewControllerDisappear:viewController];
}
- (void)viewControllerDisappear:(UIViewController *)viewController
{
    [UIView animateWithDuration:0.5 animations:^(void){
        CGPoint point = viewController.view.center;
        point.x += 1000;
        viewController.view.center = point;
    }completion:^(BOOL isFinish){
        if (isFinish) {
            [viewController.view removeFromSuperview];
            [viewController release];
        }
    }];
}


@end





















