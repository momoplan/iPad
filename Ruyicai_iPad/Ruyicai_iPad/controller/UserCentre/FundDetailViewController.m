//
//  FundDetailViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "FundDetailViewController.h"

@interface FundDetailViewController ()

@end

@implementation FundDetailViewController

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
    [showView release];
    [super dealloc];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   
    self.view.backgroundColor =[UIColor clearColor];
    UIView *blackView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    blackView.backgroundColor =[UIColor blackColor];
    blackView.alpha = 0.6;
    [self.view addSubview:blackView];
    [blackView release];
    
    showView =[[UIView alloc]initWithFrame:CGRectMake(250, 250, 500, 400)];
    showView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:showView];
    
    UIImageView *bgImg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alter_bg.png"]];
    bgImg.frame = CGRectMake(0, 0, 500, 300);
    [showView addSubview:bgImg];
    [bgImg release];
    
    UIButton * fundBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    fundBackBtn.frame =CGRectMake(10, 10, 40, 40);
    [fundBackBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [fundBackBtn addTarget:self action:@selector(fundBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:fundBackBtn];
    
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(200, 10, 150, 40)];
    titleLabel.backgroundColor =[UIColor clearColor];
    titleLabel.text = @"资金详情";
    titleLabel.textColor =[UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [showView addSubview:titleLabel];
    [titleLabel release];
    
    /* 请求余额 */
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"AllQuery" forKey:@"command"];
    [mDic setObject:@"balance" forKey:@"type"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeQueryBalance showProgress:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)fundDetailShowCreate:(NSArray *)array
{
    
    NSArray * titArray =[[[NSArray alloc]initWithObjects:@"总金额",@"冻结金额",@"可投注金额",@"可提现金额", nil]autorelease];
    NSArray * numArray = [array retain];
    for (int i=0; i<titArray.count;i++) {
        
        UILabel * sumLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 70+(50*i), 300, 40)];
        sumLabel.text = [titArray objectAtIndex:i];
        sumLabel.backgroundColor =[UIColor clearColor];
        sumLabel.font = [UIFont boldSystemFontOfSize:20];
        [showView addSubview:sumLabel];
        [sumLabel release];
        
        UILabel * mLabel =[[UILabel alloc]initWithFrame:CGRectMake(300, sumLabel.frame.origin.y, 150, 40)];
        mLabel.textAlignment = NSTextAlignmentRight;
        mLabel.text =[numArray objectAtIndex:i];
        mLabel.backgroundColor =[UIColor clearColor];
        mLabel.font = sumLabel.font;
        mLabel.textColor = [UIColor brownColor];
        [showView addSubview:mLabel];
        [mLabel release];
    }
    
 
}
#pragma mark ----------- fund methods
- (void)fundBackButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark ---------- RYCNetManager delegate
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    DLog(@"余额 查询-------- %@",dataDic);
    switch (requestTag) {
        case ASINetworkRequestTypeQueryBalance://
        {
            NSArray * array = @[[dataDic objectForKey:@"balance"],[dataDic objectForKey:@"freezebalance"],[dataDic objectForKey:@"bet_balance"],[dataDic objectForKey:@"drawbalance"]];
            [UserLoginData sharedManager].userDrawbalance = [dataDic objectForKey:@"drawbalance"];
            [self fundDetailShowCreate:array];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
