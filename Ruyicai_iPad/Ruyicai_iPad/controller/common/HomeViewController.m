//
//  HomeViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "HomeViewController.h"
#import "BuyViewController.h"
#import "TotalBuyViewController.h"
#import "LotteryAnnouncementViewController.h"
#import "ChangedPageViewController.h"
#import "RYCImageNamed.h"

#import "MoreMessageViewController.h" //更多
#import "UserCenterViewController.h"
#define HOMEMENUTAG 100

@interface HomeViewController ()
{
    BuyViewController * buyView;
    TotalBuyViewController * totalView;
    
    LotteryAnnouncementViewController *lotteryView;
    ChangedPageViewController *changeView;
    
    UserCenterViewController * userCenterView;//用户中心
    MoreMessageViewController *moreView;//更多
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)dealloc{
    [buyView release];
    [totalView release];
    [lotteryView release];
    [changeView release];
    [super dealloc];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.view.bounds = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height );
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"view_redbg" ofType:@"png"];
    UIImageView * imgBackView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:path]];
    imgBackView.frame = CGRectMake(0, 0, 1024, 748);
    [self.view addSubview:imgBackView];
    [imgBackView release];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_redbg.png"]];

    // 左侧目录列表
    [self leftMenuView];
    
    //默认界面
   
    buyView = [[BuyViewController alloc]init];
    buyView.view.frame  = CGRectMake(90, 5, 658 , 998);
    [self.view addSubview:buyView.view];
    
  


    
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ----------- viewCreate
- (void)leftMenuView
{
    NSArray * array_title =[[NSArray alloc]initWithObjects:@"购彩大厅",@"合买大厅",@"开奖公告",@"充值中心",@"用户中心",@"更多", nil];
    NSArray* array_normal_img = @[@"home_normal.png", @"hemai_normal.png", @"kaijiang_normal.png", @"chongzhi_normal.png", @"user_normal.png",  @"more_normal.png"];
    NSArray* array_click_img = @[@"home_click.png", @"hemai_click.png", @"kaijiang_click.png", @"chongzhi_click.png", @"user_click.png",  @"more_click.png"];

    for (int i = 0; i < 6; i++) {
        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 80+(80*i), 75, 80);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(40, 10, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        [button setTitleColor:RGBCOLOR(0, 0, 0) forState:btnNormal];
        [button setTitleColor:RGBCOLOR(255, 255, 255) forState:btnNormal];
        [button setTitle: [array_title objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = HOMEMENUTAG + i;
        [button setBackgroundImage:RYCImageNamed([array_normal_img objectAtIndex:i]) forState:UIControlStateNormal];
        [button setBackgroundImage:RYCImageNamed([array_click_img objectAtIndex:i]) forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
        }
        else
            button.selected = NO;
        [button  addTarget:self action:@selector(buttonLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    [array_title release];
}


#pragma mark ----------- methods 

- (void)removeViewControllers
{
    [buyView.view  removeFromSuperview];
//    [buyView release];
    
    [totalView.view removeFromSuperview];
//    [totalView  release];
    
    [lotteryView.view removeFromSuperview];
    
    [changeView.view removeFromSuperview];
    
    [moreView.view removeFromSuperview];
    [userCenterView.view removeFromSuperview];
    
}

- (void)refreshButtonImg:(int)buttpnTag
{
    for (int i = 0; i < 6; i++) {
        UIButton* tempButton = (UIButton*)[self.view viewWithTag:HOMEMENUTAG + i];
        if (buttpnTag == tempButton.tag) {
            tempButton.selected = YES;
        }
        else
            tempButton.selected = NO;
    }
}
- (void)buttonLeftMenu:(id)sender
{
    [self removeViewControllers];
    
    UIButton * btn = (UIButton *)sender;
    
    [self refreshButtonImg:btn.tag];
    
    switch (btn.tag) {
        case 100://购彩大厅
        {
            if (buyView) {
                [buyView release];
                
            }
            buyView = [[BuyViewController alloc]init];
            buyView.view.frame  = CGRectMake(90, 5, self.view.frame.size.height - 90 , self.view.frame.size.width-20);
            [self.view addSubview:buyView.view];
            
        }
            break;
        case 101://合买大厅
        {
            if (totalView ) {
                [totalView release];
            }
            totalView =[[TotalBuyViewController alloc]init];
            totalView.view.frame  = CGRectMake(90, 5, self.view.frame.size.height - 90 , self.view.frame.size.width);

            [self.view addSubview:totalView.view];
            
        }
            break;
        case 102://开奖公告
        {
            if (lotteryView) {
                [lotteryView release];
            }
            lotteryView = [[LotteryAnnouncementViewController alloc]init];
            lotteryView.view.frame  = CGRectMake(90, 5, self.view.frame.size.height - 90, self.view.frame.size.width);
            
            [self.view addSubview:lotteryView.view];
        }
            break;
        case 103://充值中心
        {
            if (changeView) {
                [changeView release];
            }
            changeView = [[ChangedPageViewController alloc] init];
            changeView.view.frame  = CGRectMake(90, 5, self.view.frame.size.height - 90, self.view.frame.size.width);
            
            [self.view addSubview:changeView.view];
        }
            break;
        case 104://用户中心
        {
            if (userCenterView) {
                [userCenterView release];
            }
            userCenterView =[[UserCenterViewController alloc]init];
            userCenterView.view.frame = CGRectMake(90, 5, self.view.frame.size.height - 90, self.view.frame.size.width);
            [self.view addSubview:userCenterView.view];
        }
            break;
        case 105://更多
        {
            if (moreView) {
                [moreView release];
            }
            moreView =[[MoreMessageViewController alloc]init];
            moreView.view.frame = CGRectMake(90, 5, self.view.frame.size.height - 90, self.view.frame.size.width);
            [self.view addSubview:moreView.view];
        }
            break;
        default:
            break;
    }
}

#pragma mark ------ orientation 自动旋转

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//        if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
//            //zuo
//            NSLog(@"做");
//        }
//        if (interfaceOrientation==UIInterfaceOrientationLandscapeRight) {
//            //you
//            NSLog(@"右");
//        }
//        if (interfaceOrientation==UIInterfaceOrientationPortrait) {
//            //shang
//            NSLog(@"上");
//        }
//        if (interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
//            //xia
//            NSLog(@"下");
//        }
//    return YES;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
@end
