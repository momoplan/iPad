//
//  ChangedPageViewController.m
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-17.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "ChangedPageViewController.h"
#import "RYCImageNamed.h"
#import "ChangedPageTableCell.h"
#import "LoginViewController.h"
#import "AlipayPaymentViewController.h"
#import "ShowMessageViewController.h"

#define KDNAViewTag (123)
#define KPhoneCardViewTag (124)

@interface ChangedPageViewController ()

@end

@implementation ChangedPageViewController

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
    [m_myTableView release], m_myTableView = nil;
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString* phoneName = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveUserNameKey];
    if(![self isSuccessLogin])
    {
        cell_count = 3;
    }
    else if (phoneName && [phoneName isEqualToString:@"15847754382"]) {
        cell_count = 3;
    }
    else
        cell_count = 4;
    [m_myTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:getTopLableWithTitle(@"充值中心")];
    
    cell_count = 4;//appStore版本不允许有手机卡充值
    m_didSelectRow = 0;
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 908, 645) style:UITableViewStylePlain];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.rowHeight = 80;
    m_myTableView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:m_myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return cell_count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"cellIdentifier";
	ChangedPageTableCell* cell = (ChangedPageTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell)
		cell = [[[ChangedPageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    switch ([indexPath row])
    {
        case 0:
            cell.iconImageName = @"ico_zhifubao.png";
            cell.titleName = @"手机支付宝充值";
            cell.littleTitleName = @"支持借记卡和信用卡充值，免开通网银";
            cell.isHaveImg_free = YES;
            break;
        case 1:
            cell.iconImageName = @"ico_bank.png";
            cell.titleName = @"银联语音充值";
            cell.littleTitleName = @"使用银联DNA手机支付，支持各大银行";
            cell.isHaveImg_free = YES;
            break;
        case 2:
            cell.iconImageName = @"ico_zhuangzhang.png";
            cell.titleName = @"银行转账";
            cell.littleTitleName = @"通过银行柜台、ATM或者网上银行转账";
            cell.isHaveImg_free = NO;
            break;
        case 3:
            cell.iconImageName = @"ico_phone.png";
            cell.titleName = @"手机充值卡充值";
            cell.littleTitleName = @"支持联通、移动、电信充值卡";
            cell.isHaveImg_free = NO;
            break;
        default:
            break;
    }
    [cell refresh];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* phoneName = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveUserNameKey];
    
    if([self isSuccessLogin] && phoneName && [phoneName isEqualToString:@"15847754382"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kRuYiCaiCharge]];
        return;
    }
    m_didSelectRow = [indexPath row];

    if ([UserLoginData sharedManager].hasLogin)//已登陆
    {
        if (1 == m_didSelectRow)//银联语音
        {
            NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
            [mDict setObject:@"AllQuery" forKey:@"command"];
            [mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
            [mDict setObject:@"dna" forKey:@"type"];
            
            [RYCNetworkManager sharedManager].netDelegate = self;
            [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeQueryDNA showProgress:YES];
        }
        else
        {
            [self pushChangedView];
        }
    }
    else//未登陆
    {
        LoginViewController *login =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:^{
            
        }];
        [login release];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pushChangedView
{
    switch (m_didSelectRow) {
        case 0:
        {
            AlipayPaymentViewController* viewController = [[AlipayPaymentViewController alloc] init];
            viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:viewController animated:YES completion:^{
                
            }];
            [viewController release];
        } break;
        case 2:
        {
            ShowMessageViewController* viewController = [[ShowMessageViewController alloc] init];
            viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            viewController.isTextView = NO;
            viewController.myTitle = @"银行转帐";
            viewController.contentStr = @"ruyicai_zhuanzhang";
            [self presentViewController:viewController animated:YES completion:^{
                
            }];
            [viewController release];
        }   break;
        case 3:
        {
            PhoneCardPaymentViewController* viewController = [[PhoneCardPaymentViewController alloc] init];
            viewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height - 116 , self.view.frame.size.width - 225);
            viewController.delegate = self;
            viewController.view.tag = KPhoneCardViewTag;
            [self.view addSubview:viewController.view];
            
            CATransition *transition = [CATransition animation];
            transition.duration = .5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
            transition.subtype = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
            [viewController.view.layer addAnimation:transition forKey:nil];
//            [viewController release];
        }break;
        default:
            break;
    }
}
#pragma mark －－－－联网成功
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryDNA:
        {
            DNAPaymentViewController* viewController = [[DNAPaymentViewController alloc] init];
            viewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height - 116 , self.view.frame.size.width - 225);
            viewController.delegate = self;
            if ([KISDictionaryHaveKey(dataDic, @"bindstate") isEqualToString:@"0"]) {//未绑定，但是曾经提交过信息，未交钱
                viewController.bindName = KISDictionaryHaveKey(dataDic, @"name");
                viewController.bindBankCardNo = KISDictionaryHaveKey(dataDic, @"bankcardno");
                viewController.bindCertId = KISDictionaryHaveKey(dataDic, @"certid");
                viewController.bindDate = KISDictionaryHaveKey(dataDic, @"binddate");
                viewController.bindAddressName = KISDictionaryHaveKey(dataDic, @"addressname");
                viewController.bindBankAddress = KISDictionaryHaveKey(dataDic, @"bankaddress");
                viewController.bindPhonenum = KISDictionaryHaveKey(dataDic, @"phonenum");
                [viewController showBindStatus:NO];
            }
            else if ([KISDictionaryHaveKey(dataDic, @"bindstate") isEqualToString:@"1"])  //bind，绑定
            {
                viewController.bindName = KISDictionaryHaveKey(dataDic, @"name");
                viewController.bindBankCardNo = KISDictionaryHaveKey(dataDic, @"bankcardno");
                viewController.bindCertId = KISDictionaryHaveKey(dataDic, @"certid");
                viewController.bindDate = KISDictionaryHaveKey(dataDic, @"binddate");
                viewController.bindAddressName = KISDictionaryHaveKey(dataDic, @"addressname");
                viewController.bindBankAddress = KISDictionaryHaveKey(dataDic, @"bankaddress");
                viewController.bindPhonenum = KISDictionaryHaveKey(dataDic, @"phonenum");
                [viewController showBindStatus:YES];
            }
            else//未绑定
            {
                [viewController showBindStatus:NO];
            }
            viewController.view.tag = KDNAViewTag;
            [self.view addSubview:viewController.view];

            CATransition *transition = [CATransition animation];
            transition.duration = .5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
            transition.subtype = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
            [viewController.view.layer addAnimation:transition forKey:nil];
//            [viewController release];
  
        } break;
        default:
            break;
    }
}

#pragma mark 移除
- (void)dismissMyView:(DNAPaymentViewController*)viewcontroller
{
    [UIView animateWithDuration:.5 animations:^(void){
        CGPoint point = [self.view viewWithTag:KDNAViewTag].center;
        point.x += 1000;
        [self.view viewWithTag:KDNAViewTag].center = point;
    }completion:^(BOOL isFinish){
        if (isFinish) {
            [[self.view viewWithTag:KDNAViewTag] removeFromSuperview];
        }
    }];
}

- (void)dismissPhoneCardView:(PhoneCardPaymentViewController*)viewcontroller
{
    [UIView animateWithDuration:1.0 animations:^(void){
        CGPoint point = [self.view viewWithTag:KPhoneCardViewTag].center;
        point.x += 1000;
        [self.view viewWithTag:KPhoneCardViewTag].center = point;
    }completion:^(BOOL isFinish){
        if (isFinish) {
            [[self.view viewWithTag:KPhoneCardViewTag] removeFromSuperview];
        }
    }];
}

@end
