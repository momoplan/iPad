//
//  QueryChaseViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryChaseViewController.h"

@interface QueryChaseViewController ()

@end

@implementation QueryChaseViewController
@synthesize delegate;
@synthesize chaseStateArray;

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
    self.delegate = nil;
    [chaseStateArray release],chaseStateArray = nil;
    [queryChaseView release];
    [chaseTableView release];
    [refreshView release];
    [super dealloc];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [super tabBarBackgroundImageViewWith:self.view];
	// Do any additional setup after loading the view.
    [self queryChaseTitleView];
    [self queryChaseTableView];
    queryChaseView =[[QueryChaseDetailView alloc]initWithFrame:CGRectMake(550, 100, 360, 550)];
    queryChaseView.delegate = self;
    [self sendQueryChaseRequestWithPage:0];
    
}

#pragma mark 取消追期
- (void)cancelChaseClick:(NSString*)idNo
{
    NSMutableDictionary * mDict =[[NSMutableDictionary alloc]init];
    [mDict setObject:@"cancelTrack" forKey:@"command"];
    [mDict setObject:idNo forKey:@"tsubscribeNo"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeCancelTrack showProgress:YES];
    [mDict release];

}

#pragma mark ----------- chase view
- (void)queryChaseTitleView
{
   [self.view addSubview:getTopLableWithTitle(@"追号查询")];
    
    UIButton *queryChaseBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    queryChaseBackBtn.frame     = CGRectMake(0, 0, 76, 76);
    [queryChaseBackBtn setImage:[UIImage imageNamed:@"narBack.png"] forState:UIControlStateNormal];
    [queryChaseBackBtn addTarget:self action:@selector(queryChaseBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryChaseBackBtn];
}
/* 追号查询 列表 */
- (void)queryChaseTableView
{
    self.chaseStateArray                = [[NSMutableArray alloc]init];
    chaseTableView                      = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, 908, 645) style:UITableViewStylePlain];
    chaseTableView.delegate             = self;
    chaseTableView.dataSource           = self;
    [self.view addSubview:chaseTableView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 0;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 710, 600, REFRESH_HEADER_HEIGHT)];
    [chaseTableView addSubview:refreshView];
    refreshView.myScrollView            = chaseTableView;
    [refreshView stopLoading:NO];

    
}
#pragma mark ---------- RYCNetManager delegate
- (void)sendQueryChaseRequestWithPage:(int)pageIndex
{
    NSMutableDictionary * mDict =[[NSMutableDictionary alloc]init];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
	[mDict setObject:@"10" forKey:@"maxresult"];
	[mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    [mDict setObject:@"track" forKey:@"type"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeQueryTrack showProgress:YES];
    [mDict release];
}
- (void)sendRequestChaseDetailWithID:(NSString *)subscriID
{
    NSMutableDictionary * mDict =[[NSMutableDictionary alloc]init];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:@"trackDetail" forKey:@"type"];
    [mDict setObject:subscriID forKey:@"tsubscribeNo"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkReqestTypeGetLotDate showProgress:YES];
    [mDict release];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryTrack:   //
        {
            if (curPageIndex == 0) {
                [self.chaseStateArray removeAllObjects];
            }
            [self queryChaseDataSetDictionary:dataDic];
        }
            break;
        case ASINetworkReqestTypeGetLotDate:    //
        {
            if (ErrorCode(dataDic)) {
                [self chaseDetailSetDictionary:dataDic];
            }
        }
            break;
        case ASINetworkRequestTypeCancelTrack://取消追期
            if (ErrorCode(dataDic)) {
                curPageIndex = 0;
                [self sendQueryChaseRequestWithPage:0];
            }
            break;
        default:
            break;
    }
}
/* 追号查询 数据整理 */
- (void)queryChaseDataSetDictionary:(NSDictionary *)mDic
{
    NSMutableArray * nuArray    = [[NSMutableArray alloc]init];
    NSArray * result = KISDictionaryHaveKey(mDic, @"result");
    for (int i=0; i<result.count; i++) {
        NSDictionary * dic      = [result objectAtIndex:i];
        QueryChaseCellModel * model =[[QueryChaseCellModel alloc]init];
        model.tradeId           = KISDictionaryHaveKey(dic, @"id");
        model.lotNo             = KISDictionaryHaveKey(dic, @"lotNo");
        model.lotName           = KISDictionaryHaveKey(dic, @"lotName");
        model.lotMulti          = KISDictionaryHaveKey(dic, @"lotMulti");
        model.bet_code          = KISDictionaryHaveKey(dic, @"bet_code");
        model.betCode           = KISDictionaryHaveKey(dic, @"betCode");
        model.batchNum          = KISDictionaryHaveKey(dic, @"batchNum");
        model.lastNum           = KISDictionaryHaveKey(dic, @"lastNum");
        model.beginBatch        = KISDictionaryHaveKey(dic, @"beginBatch");
        model.lastBatch         = KISDictionaryHaveKey(dic, @"lastBatch");
        model.betNum            = KISDictionaryHaveKey(dic, @"betNum");
        model.amount            = KISDictionaryHaveKey(dic, @"amount");
        model.remainderAmount   = KISDictionaryHaveKey(dic, @"remainderAmount");
        model.oneAmount         = KISDictionaryHaveKey(dic, @"oneAmount");
        model.state             = KISDictionaryHaveKey(dic, @"state");
        model.orderTime         = KISDictionaryHaveKey(dic, @"orderTime");
        model.prizeEnd          = KISDictionaryHaveKey(dic, @"prizeEnd");
        model.isRepeatBuy       = KISDictionaryHaveKey(dic, @"isRepeatBuy");
        [nuArray addObject:model];
        [model release];
    }
    [self.chaseStateArray addObjectsFromArray:nuArray];
    [nuArray release];
    [chaseTableView reloadData];
    
    totalPageCount              = [KISDictionaryHaveKey(mDic, @"totalPage") intValue];
    startY                      = chaseTableView.contentSize.height;
    
    centerY                     = chaseTableView.contentSize.height - 640;
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
}
- (void)chaseDetailSetDictionary:(NSDictionary *)detDic
{
    
    NSArray * result = KISDictionaryHaveKey(detDic, @"result");
    if (result.count==0) {
        return;
    }
    NSMutableArray *array =[[NSMutableArray alloc]init];
    for (int i=0; i<result.count; i++) {
        ChaseDetailCellModel *model =[[ChaseDetailCellModel alloc]init];
        NSDictionary *dic =[result objectAtIndex:i];
        model.batchCode = KISDictionaryHaveKey(dic, @"batchCode");
        model.lotMulti = KISDictionaryHaveKey(dic, @"lotMulti");
        model.amount  = KISDictionaryHaveKey(dic, @"amount");
        model.winCode   = KISDictionaryHaveKey(dic, @"winCode");
        model.state     = KISDictionaryHaveKey(dic, @"state");
        model.stateMemo = KISDictionaryHaveKey(dic, @"stateMemo");
        model.desc      = KISDictionaryHaveKey(dic, @"desc");
        model.prizeAmt  = KISDictionaryHaveKey(dic, @"prizeAmt");
        [array addObject:model];
        [model release];
    }
    [queryChaseView.chaseDataAry removeAllObjects];
    [queryChaseView chaseDetailTableViewCellArray:array];
    [array release];
}
#pragma mark ---------- chase methods
- (void)queryChaseBackButtonClick:(id)sender
{
    [self.delegate queryChaseViewDisappear:self];
}

#pragma mark ----------- chase tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chaseStateArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell = @"celled";
    QueryChaseTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell =[[[QueryChaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model =[chaseStateArray objectAtIndex:indexPath.row];
    cell.mySuperViewController = self;
    [cell queryChaseTableCellRefresh];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == chaseTableView) {
        QueryChaseCellModel * model = [self.chaseStateArray objectAtIndex:indexPath.row];
        [queryChaseView chaseDetailDataChaseModel:model];
        [self sendRequestChaseDetailWithID:model.tradeId];
        [self.view addSubview:queryChaseView];
    }
    
}
#pragma mark --------- querychaseview delegate
- (void)queryChaseDetailCloseButton:(UIView *)view
{
    [queryChaseView removeFromSuperview];
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
        [self sendQueryChaseRequestWithPage:curPageIndex];
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
