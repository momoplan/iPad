//
//  LotteryDetailViewController.m
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "LotteryDetailViewController.h"
#import "RYCImageNamed.h"
#import "LotteryAnnouncementViewController.h"
#import "CommonRecordStatus.h"
#import "RYCNetworkManager.h"
#import "LotteryDetailTableViewCell.h"

@interface LotteryDetailViewController ()

@end

@implementation LotteryDetailViewController
@synthesize lotTitle = m_lotTitle;
@synthesize delegate;
@synthesize myTableView = m_myTableView;
@synthesize detailBatchCode = m_detailBatchCode;
@synthesize historyLotteryData = m_historyLotteryData;
@synthesize lotteryDetailData = m_lotteryDetailData;
@synthesize lotteryDetailView = m_lotteryDetailView;

- (void) dealloc
{
    [m_lotteryDetailView release];
    [m_myTableView release];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];
    
    m_historyLotteryData = [[NSMutableArray alloc] init];
    m_lotteryDetailData = [[NSDictionary alloc] init];
    
    UIImageView *tabBarBgImageView = [[UIImageView alloc] initWithImage:RYCImageNamed(@"tabBar_bg.png")];
    tabBarBgImageView.frame = CGRectMake(0, 0, 910, 64);
    [self.view addSubview:tabBarBgImageView];
    [tabBarBgImageView release];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(10, 10, 45, 45);
    [backButton setImage:RYCImageNamed(@"back.png") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton release];
    
    //tableView
    m_myTableView           = [[UITableView alloc] init];
    m_myTableView.frame     = CGRectMake(0, 66, [UIScreen mainScreen].bounds.size.height * 0.5, 650);
    m_myTableView.delegate  = self;
    m_myTableView.dataSource    = self;
    [self.view addSubview:m_myTableView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 1;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 720, 400, REFRESH_HEADER_HEIGHT)];
    [m_myTableView addSubview:refreshView];
    refreshView.myScrollView            = m_myTableView;
    [refreshView stopLoading:NO];
    
    //开奖详情页面
    m_lotteryDetailView = [[LotteryDatailView alloc] init];
    m_lotteryDetailView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height * 0.5 + 2,
                                           66,
                                           [UIScreen mainScreen].bounds.size.height * 0.5 - 120,
                                            650);
    m_lotteryDetailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_lotteryDetailView];
}

- (void) back:(id)sender
{
    [self.delegate LotteryDetailViewDisappear:self];
}



//刷新数据
- (void) refreshView
{
    [self setTopTitleName];
    m_lotteryDetailView.lotNo = [[CommonRecordStatus commonRecordStatusManager] lotNoWithLotTitle:self.lotTitle];
    [self sendRequestLotteryInfoWithPage:1];
}


//标题显示
- (void) setTopTitleName
{
    [self.view addSubview:getTopLableWithTitle([NSString stringWithFormat:@"%@－开奖",[[CommonRecordStatus commonRecordStatusManager] lotNameWithLotTitle:self.lotTitle]])];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyLotteryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    LotteryDetailTableViewCell *cell = (LotteryDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[LotteryDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    cell.lotTitle = self.lotTitle;
    NSDictionary *mDic = (NSDictionary*)[self.historyLotteryData objectAtIndex:indexPath.row];

    cell.batchCode = KISDictionaryHaveKey(mDic, @"batchCode");
    cell.openPrizeCode = KISDictionaryHaveKey(mDic, @"winCode");
    cell.openPrizeDate = KISDictionaryHaveKey(mDic, @"openTime");
    if ([cell.lotTitle isEqualToString: kLotTitleFC3D]) {
        cell.lotteryTryNo = [mDic objectForKey:@"tryCode"];
    }

    
    [cell refleshTableCell];
    
    return cell;
}

#pragma mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //请求当前期的详细信息
    NSMutableArray *tempArray = [self getAllBatchCode:self.historyLotteryData];
    NSString *lotno = [[CommonRecordStatus commonRecordStatusManager] lotNoWithLotTitle:self.lotTitle];
    
    NSMutableDictionary* mDict_1 = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict_1 setObject:@"AllQuery" forKey:@"command"];
    [mDict_1 setObject:@"winInfoDetail" forKey:@"type"];
    [mDict_1 setObject:lotno forKey:@"lotno"];
    m_detailBatchCode = [tempArray objectAtIndex:indexPath.row];
    if(m_detailBatchCode)
        [mDict_1 setObject:m_detailBatchCode forKey:@"batchcode"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict_1 withRequestType:ASINetworkReqestTypeGetWinInfoDetail showProgress:YES];
}


#pragma mark  ----------------- 数据获取成功
- (void)sendRequestLotteryInfoWithPage:(int)pageIndex
{
    NSString *lotno = [[CommonRecordStatus commonRecordStatusManager] lotNoWithLotTitle:self.lotTitle];
    //请求对应彩种的开奖情况
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"winInfoList" forKey:@"type"];
    [mDict setObject:@"9" forKey:@"maxresult"];
    [mDict setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];
    [mDict setObject:lotno forKey:@"lotno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeGetLotteryInfo showProgress:YES];
}
- (void)netSuccessWithResult:(NSDictionary*)mDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkReqestTypeGetWinInfoDetail:
        {
            NSString *errorCode = KISDictionaryHaveKey(mDic, @"error_code");
            NSString *message = KISDictionaryHaveKey(mDic, @"message");
            if ([errorCode isEqualToString:@"0000"]) {
                
                self.lotteryDetailData = mDic;
                
                m_lotteryDetailView.detailData = self.lotteryDetailData;
                [m_lotteryDetailView refleshView];
            }
            else
            {
                [[RYCNetworkManager sharedManager] showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
            }
            break;
        }
        case ASINetworkRequestTypeGetLotteryInfo:
        {
            NSString *errorCode = KISDictionaryHaveKey(mDic, @"error_code");
            NSString *message = KISDictionaryHaveKey(mDic, @"message");
            if ([errorCode isEqualToString:@"0000"]) {
                
                [self.historyLotteryData addObjectsFromArray: KISDictionaryHaveKey(mDic, @"result")];
                [self.myTableView reloadData];
                
                totalPageCount              = [KISDictionaryHaveKey(mDic, @"totalPage") intValue];
                startY                      = m_myTableView.contentSize.height;
                
                centerY                     = m_myTableView.contentSize.height - 640;
                curPageIndex++;
                
                if(curPageIndex == totalPageCount)
                {
                    [refreshView stopLoading:YES];
                }
                else
                {
                    [refreshView stopLoading:NO];
                }
                [refreshView setRefreshViewFrame];
                
                //请求当前期的详细信息
                NSMutableArray *tempArray = [self getAllBatchCode:self.historyLotteryData];
                NSString *lotno = [[CommonRecordStatus commonRecordStatusManager] lotNoWithLotTitle:self.lotTitle];
    
                NSMutableDictionary* mDict_1 = [NSMutableDictionary dictionaryWithCapacity:1];
                [mDict_1 setObject:@"AllQuery" forKey:@"command"];
                [mDict_1 setObject:@"winInfoDetail" forKey:@"type"];
                [mDict_1 setObject:lotno forKey:@"lotno"];
                m_detailBatchCode = [tempArray objectAtIndex:0];
                if(m_detailBatchCode)
                    [mDict_1 setObject:m_detailBatchCode forKey:@"batchcode"];
                
                [RYCNetworkManager sharedManager].netDelegate = self;
                [[RYCNetworkManager sharedManager] netRequestStartWith:mDict_1 withRequestType:ASINetworkReqestTypeGetWinInfoDetail showProgress:YES];
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


//获得这种彩种返回的所有期号
- (NSMutableArray*) getAllBatchCode:(NSArray*)allLotteryArray
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < [allLotteryArray count]; i++) {
        NSDictionary *tempDic = [allLotteryArray objectAtIndex:i];
        [result addObject:KISDictionaryHaveKey(tempDic, @"batchCode")];
    }
    return result;
}

#pragma mark   ------------------------- scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(curPageIndex == 0)
    {
        refreshView.viewMaxY = 0;
    }
    else
    {
        refreshView.viewMaxY = centerY;
    }
    [refreshView viewdidScroll:scrollView];
}
#pragma mark --------------------------  pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView viewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView didEndDragging:scrollView];
}

- (void)startRefresh:(NSNotification *)notification
{
    DLog(@"start");
    if(curPageIndex < totalPageCount)
    {
        [self sendRequestLotteryInfoWithPage:curPageIndex];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
