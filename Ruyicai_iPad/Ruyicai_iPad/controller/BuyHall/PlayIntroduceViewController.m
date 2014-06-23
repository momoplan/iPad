//
//  PlayIntroduceViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-17.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "PlayIntroduceViewController.h"

@interface PlayIntroduceViewController ()

@end

@implementation PlayIntroduceViewController
@synthesize delegate;
@synthesize introduceLotNo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc{
    [introduceLotNo release],introduceLotNo = nil;
    [super dealloc];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor clearColor];
    
    UIImageView * bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 467, 735)];
    bgImage.image = RYCImageNamed(@"detailView_bg.png");
    [self.view addSubview:bgImage];
    [bgImage release];
    
    UIButton * backBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(20, 10, 60, 40);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:btnNormal];
//    [backBtn setBackgroundImage:RYCImageNamed(@"detail_back_nor.png") forState:btnNormal];
//    [backBtn setBackgroundImage:RYCImageNamed(@"detail_back_click.png") forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [backBtn addTarget:self action:@selector(playIntroduceBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel * titleLabel        =[[UILabel alloc]initWithFrame:CGRectMake(200, 10, 100, 40)];
    titleLabel.text             = @"玩法介绍";
    titleLabel.font             = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = RGBCOLOR(244, 244, 244);
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    
    NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:@"information" forKey:@"command"];
    [tempDic setObject:@"playIntroduce" forKey:@"newsType"];
    [tempDic setObject:introduceLotNo   forKey:@"lotno"];
    
    [RYCNetworkManager sharedManager].netLotType = NET_LOT_BASE;
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:tempDic withRequestType:ASINetworkReqestTypeGetLotDate showProgress:YES];
}
- (void)playIntroduceBack:(id)sender
{
    [self.delegate playIntroduceViewDisappear:self];
}
#pragma mark ------------- notification
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkReqestTypeGetLotDate:
            [self playMethodsIntroduceView:dataDic];
            break;
            
        default:
            break;
    }
   }
- (void)playMethodsIntroduceView:(NSDictionary *)mDic
{
    NSDictionary * parserDict = mDic;
    NSString* dict = [parserDict objectForKey:@"title"];
    NSString* content = [parserDict objectForKey:@"introduce"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-20, 35)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = dict;
    label.font =[UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    [label setTextColor:[UIColor brownColor]];
    [self.view addSubview:label];
    [label release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 105, self.view.frame.size.width-20, self.view.frame.size.height-120)];
    textView.text = content;
    textView.font = [UIFont systemFontOfSize:18];
    textView.editable = NO;
    [textView setTextColor:[UIColor blackColor]];
    [textView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:textView];
    [textView release];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
