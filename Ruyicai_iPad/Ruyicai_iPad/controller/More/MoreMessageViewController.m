//
//  MoreMessageViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "MoreMessageViewController.h"

@interface MoreMessageViewController ()

@end

@implementation MoreMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark ============= controller
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setMoreTitelView];
    [self setMoreTableView];

}
- (void)dealloc{
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ============= view
/* 设置标题 */
- (void)setMoreTitelView
{
    [self.view addSubview:getTopLableWithTitle(@"更多")];

}
/*  选项列表*/
- (void)setMoreTableView
{
    UITableView * moreTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 68, 908, 650) style:UITableViewStyleGrouped];
    moreTabelView.delegate = self;
    moreTabelView.backgroundColor = [UIColor whiteColor];
    moreTabelView.backgroundView        = nil;
    moreTabelView.dataSource = self;
    [self.view addSubview:moreTabelView];
    [moreTabelView release];
}

#pragma mark ============  tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row = 0;
    switch (section) {
        case 0:
            row = 4;
            break;
        case 1:
            row = 4;
            break;
        default:
            break;
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell =@"celled";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dequeCell]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
       
    }
    NSArray *array = @[@[@"彩票资讯",@"活动中心",@"帮助中心",@"自动登录设置"],@[@"用户反馈",@"关于我们",@"版本信息",@"客服电话:       400 - 665 - 1000"]];
    NSArray *imageAry = @[@[@"newsinformation.png",@"activecenter.png",@"more_genequest.png",@"setupico.png"],@[@"more_feedback.png",@"more_guanyu.png",@"more_banben.png",@"more_kefu.png"]];
    cell.imageView.image = RYCImageNamed([[imageAry objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
    if (indexPath.section==0&&indexPath.row==3) {
        cell.accessoryType  = UITableViewCellAccessoryNone;
        UISwitch * setSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(830, 12, 79, 27)];
        NSString * ranState = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveRandomSate];
        if ([ranState isEqualToString:@"0"]) {
            setSwitch.on = NO;
        }else{
            setSwitch.on = YES;
        }
        [setSwitch addTarget:self action:@selector(loginAutoSwitchAction:) forControlEvents:UIControlEventValueChanged];
//        [cell.contentView addSubview:setSwitch];
        cell.accessoryView = setSwitch;
        [setSwitch release];

    }
    cell.textLabel.text = [[array objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIView * showView = nil;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0: // 彩票资讯
                {
                    LotteryInformationViewController * lotteryInfo =[[LotteryInformationViewController alloc]init];
                    showView = lotteryInfo.view;
                    lotteryInfo.delegate = self;
                }
                    break;
                    
                case 1: // 活动中心
                {
                    ActivityCenterViewController * activityCenter =[[ActivityCenterViewController alloc]init];
                    activityCenter.delegate = self;
                    showView = activityCenter.view;
                }
                    break;
                case 2: // 帮助中心
                {
                    HelpCenterViewController * helpCenter =[[HelpCenterViewController alloc]init];
                    showView = helpCenter.view;
                    helpCenter.delegate = self;
                }
                    break;
//                case 3: //设置
//                {
//                    MoreSettingViewController *moreSetView =[[MoreSettingViewController alloc]init];
//                    showView = moreSetView.view;
//                    moreSetView.delegate = self;
//                }
//                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UserFeedbackViewController *feedBackV =[[UserFeedbackViewController alloc]initWithNibName:@"UserFeedbackViewController" bundle:nil];
                    feedBackV.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:feedBackV animated:YES completion:^{}];
                    return;
                }
                    break;
                case 1:// 关于我们
                {
                    BaseHelpViewController  * baseHelp =[[BaseHelpViewController alloc]init];
                    baseHelp.htmlFileName   =  @"ruyihelper_authorizing";
                    baseHelp.delegate       = self;
                    showView                = baseHelp.view;
                    
                }
                    break;
                case 2:    // 版本信息
                {
                    VersionInformationViewController * versionInfo =[[VersionInformationViewController alloc]initWithNibName:@"VersionInformationViewController" bundle:nil];
                    versionInfo.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:versionInfo animated:YES completion:^{}];
                    return;
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
      }
   
    showView.frame =CGRectMake(0, 0, 920, 730);
    [self.view addSubview:showView];
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [showView.layer addAnimation:transition forKey:nil];

}
#pragma mark ================ viewDisappear
- (void)lotteryInfoViewDisappear:(UIViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];
}
- (void)helpCenterViewDisappear:(UIViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];

}
- (void)activityCenterViewDisappear:(UIViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];

}
- (void)moreSettingViewDisappear:(UIViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];
}
- (void)baseHelpViewDisappear:(UIViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];

}

- (void)loginAutoSwitchAction:(id)sender
{
    UISwitch * mySwitch = (UISwitch *)sender;
    if (mySwitch.on) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kSaveRandomSate];
        [self showAlertWithMessage:@"只能设置关闭，如需开启请到登录界面打开并登录"];
        mySwitch.on = NO;
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kSaveRandomSate];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
