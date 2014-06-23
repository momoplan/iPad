//
//  LotteryAnnouncementViewController.m
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-17.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "LotteryAnnouncementViewController.h"
#import "RYCNetworkManager.h"
#import "LotteryTableViewCell.h"
#import "CommonRecordStatus.h"
#import "RYCImageNamed.h"

@interface LotteryAnnouncementViewController ()

@end

@implementation LotteryAnnouncementViewController
@synthesize cellCount = m_cellCount;
@synthesize myTableView = m_myTableView;
@synthesize lotNameArray = m_lotNameArray;
@synthesize lotteryNoArray = m_lotteryNoArray;
@synthesize netData = m_netData;
@synthesize todayOpenPrizeLotNoArray = m_todayOpenPrizeLotNoArray;
@synthesize openPrizeBatchCode = m_openPrizeBatchCode;

- (void) dealloc
{
    [m_netData release];
    [m_myTableView release];
    [m_lotNameArray release];
    [m_lotteryNoArray release];
    [m_todayOpenPrizeLotNoArray release];
    
    [super dealloc];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self queryOpenState];//今日开奖和加奖
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view addSubview:getTopLableWithTitle(@"开奖公告")];
    m_cellCount = 0;
    m_netData = [[NSDictionary alloc] init];
    m_todayOpenPrizeLotNoArray = [[NSArray alloc] init];
    
    m_lotNameArray = [[NSMutableArray alloc] initWithCapacity:1];
    [m_lotNameArray addObject:kLotTitleSSQ];
    [m_lotNameArray addObject:kLotTitleDLT];
    [m_lotNameArray addObject:kLotTitleFC3D];
    [m_lotNameArray addObject:kLotTitleGD115];
    [m_lotNameArray addObject:kLotTitleSSC];
//    [m_lotNameArray addObject:kLotTitleQLC];
    
    //测试
    m_lotteryNoArray = [[NSMutableArray alloc] initWithCapacity:1];
    [m_lotteryNoArray addObject:@"01020304050607"];
    [m_lotteryNoArray addObject:@"01020304050607"];
    [m_lotteryNoArray addObject:@"010203"];
    [m_lotteryNoArray addObject:@"0102030405"];
    [m_lotteryNoArray addObject:@"0102030405"];
    
    m_myTableView = [[UITableView alloc] init];//]WithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.height - 116 , self.view.frame.size.width - 100) style:UITableViewStylePlain];
    m_myTableView.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.height - 116 , 650);
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
    
    //请求开奖数据
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"QueryLot" forKey:@"command"];
    [dict setObject:@"winInfo" forKey:@"type"];

    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:dict withRequestType:ASINetworkReqestTypeGetLotteryInfo showProgress:YES];
}

- (void)queryOpenState
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"select" forKey:@"command"];
    [dict setObject:@"buyCenter" forKey:@"requestType"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:dict withRequestType:ASINetworkRequestTypeQueryTodayOpen showProgress:YES];
}


#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_lotNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    LotteryTableViewCell *cell = (LotteryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[LotteryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.lotTitle = [m_lotNameArray objectAtIndex:indexPath.row];
    NSDictionary* subDict = (NSDictionary*)[self.netData objectForKey:cell.lotTitle];
    if([[subDict allKeys] count] == 0)
    {
        NSArray *array01 = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",nil];
        NSArray *array02 = [[NSArray alloc] initWithObjects:@"batchCode",@"winCode",@"openTime",@"tryCode", nil];
        subDict = [NSDictionary dictionaryWithObjects:array01 forKeys:array02 ];
        [array01 release];
        [array02 release];
    }
    m_openPrizeBatchCode = [subDict objectForKey:@"batchCode"];
    cell.batchCode = m_openPrizeBatchCode;
    cell.lotteryDate = [subDict objectForKey:@"openTime"];
    cell.lotteryNo = [subDict objectForKey:@"winCode"];
    
    if ([cell.lotTitle isEqualToString: kLotTitleFC3D]) {
        cell.lotteryTryNo = [subDict objectForKey:@"tryCode"];
    }
    
    NSString *tempLotNo = [[CommonRecordStatus commonRecordStatusManager] lotNoWithLotTitle:[m_lotNameArray objectAtIndex:indexPath.row]];
    cell.isOpenPrize = NO;
    for (int i = 0; i < [self.todayOpenPrizeLotNoArray count]; i++) {
        if ([tempLotNo isEqualToString:[m_todayOpenPrizeLotNoArray objectAtIndex:i]])
        {
            cell.isOpenPrize = YES;
            break;
        }
    }
    
    [cell refreshCell];
    
    return cell;
}


#pragma mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    m_lotteryViewController = [[LotteryDetailViewController alloc]init];
    m_lotteryViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height - 116 , 650);
    m_lotteryViewController.lotTitle = [m_lotNameArray objectAtIndex:indexPath.row];
    m_lotteryViewController.detailBatchCode = m_openPrizeBatchCode;
    m_lotteryViewController.delegate = self;
    [m_lotteryViewController refreshView];
    m_lotteryViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.view addSubview:m_lotteryViewController.view];
    
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    transition.subtype = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
    [m_lotteryViewController.view.layer addAnimation:transition forKey:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 数据获取成功
- (void)netSuccessWithResult:(NSDictionary*)mDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkReqestTypeGetLotteryInfo:
        {
            self.netData = mDic;
            NSLog(@"%@",self.netData);
            [m_myTableView reloadData];
            break;
        }
        case ASINetworkRequestTypeQueryTodayOpen:
        {
            NSString *errorCode = KISDictionaryHaveKey(mDic, @"error_code");
            NSString *message = KISDictionaryHaveKey(mDic, @"message");
            if ([errorCode isEqualToString:@"0000"]) {
                
                NSArray* lotStateArray = KISDictionaryHaveKey(mDic, @"result");
                NSMutableDictionary* lotStateDic = [NSMutableDictionary dictionaryWithCapacity:1];
                for (int i = 0; i < [lotStateArray count]; i++) {
                    [lotStateDic addEntriesFromDictionary:[lotStateArray objectAtIndex:i]];
                }
                self.todayOpenPrizeLotNoArray = [self getLotNoTodayOpenPrize:lotStateDic];
                [self.myTableView reloadData];
            }
            else
            {
                [[RYCNetworkManager sharedManager] showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
            }
        }
        default:
            break;
    }
}

//获得今日开奖的彩种

- (NSArray*) getLotNoTodayOpenPrize:(NSMutableDictionary*)lotStateDic
{
    NSMutableArray *openPrizeArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *allKeys = [lotStateDic allKeys];
    for (int i = 0; i < [allKeys count]; i++) {
        NSString *key = [allKeys objectAtIndex:i];
        NSDictionary *lotInfo = [lotStateDic objectForKey:key];
        if ([[lotInfo objectForKey:@"isTodayOpenPrize"] isEqualToString:@"true"]) {
            [openPrizeArray addObject:key];
        }
    }
    NSLog(@"%@",openPrizeArray);
    return openPrizeArray;
}

#pragma mark   LotteryDetailViewDelegate
- (void)LotteryDetailViewDisappear:(LotteryDetailViewController*)viewController
{

    
    [UIView animateWithDuration:.5 animations:^(void){
        CGPoint point = m_lotteryViewController.view.center;
        point.x += 1000;
        m_lotteryViewController.view.center = point;
    }completion:^(BOOL isFinish){
        if (isFinish) {
            [m_lotteryViewController.view removeFromSuperview];
            [m_lotteryViewController release];
        }
    }];

}

@end