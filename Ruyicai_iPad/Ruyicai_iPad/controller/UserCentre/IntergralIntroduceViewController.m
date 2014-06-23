//
//  IntergralIntroduceViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-11-13.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "IntergralIntroduceViewController.h"

@interface IntergralIntroduceViewController ()

@end

@implementation IntergralIntroduceViewController
@synthesize delegate;
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
	// Do any additional setup after loading the view.
    
    UIImageView * bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 467, 735)];
    bgImage.image = RYCImageNamed(@"detailView_bg.png");
    [self.view addSubview:bgImage];
    [bgImage release];
    
    UIButton * backBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(20, 10, 60, 40);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:btnNormal];
    [backBtn setBackgroundImage:RYCImageNamed(@"detail_back_nor.png") forState:btnNormal];
    [backBtn setBackgroundImage:RYCImageNamed(@"detail_back_click.png") forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(intergralIntroduceBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel * titLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 10, 100, 40)];
    titLabel.text = @"积分规则";
    titLabel.textColor = RGBCOLOR(255, 255, 255);
    titLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titLabel];
    [titLabel release];
    
    contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 75, 447,645)];
    contentTextView.font = [UIFont systemFontOfSize:17];
    contentTextView.editable = NO;
    [self.view addSubview:contentTextView];
    
    [self  sendIntegralIntrodRequest];
}
- (void)dealloc
{
    [contentTextView release];
    [super dealloc];

//    self.delegate = nil;
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkReqestTypeGetLotDate:
        {
            contentTextView.text = KISDictionaryHaveKey(dataDic, @"content");
        }
            break;
        default:
            break;
    }
}
/* 积分介绍 */
- (void)sendIntegralIntrodRequest
{
    NSMutableDictionary*  tempDic = [[NSMutableDictionary alloc]init];
    [tempDic setObject:@"information" forKey:@"command"];
    [tempDic setObject:@"scoreRule" forKey:@"newsType"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:tempDic withRequestType:ASINetworkReqestTypeGetLotDate showProgress:YES];
    [tempDic release];
}
- (void)intergralIntroduceBack:(id)sender
{
    [self.delegate intergralIntroduceViewDisappear:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
