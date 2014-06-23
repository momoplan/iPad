//
//  AccountDetailViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "AccountDetailViewController.h"

@interface AccountDetailViewController ()

@end

@implementation AccountDetailViewController
@synthesize delegate;
@synthesize accDataArray;
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
    [accDataArray release],accDataArray =nil;
    
    [accTableView release];
    [refreshView release];
    [noRecordView release];
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
    [self accountTitleView]; //页面 标题等
    [self accountTableView];// 列表布局u
    [self accountNoRecoredViewCreate];
    self.accTypeString    = @"0";
    [self accountInitTableViewDataPage:0];
    
  
}
#pragma mark -------- view create
- (void)accountTitleView
{
    [super tabBarBackgroundImageViewWith:self.view];
    
    [self.view addSubview:getTopLableWithTitle(@"账户明细")];
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 70, 900, 80)];
    headView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:headView];
    [headView release];
    
    
    
    UIButton *accountBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    accountBackBtn.frame = CGRectMake(0, 0, 76, 77);
    [accountBackBtn setImage:[UIImage imageNamed:@"viewback.png"] forState:UIControlStateNormal];
    [accountBackBtn  setImage:[UIImage imageNamed:@"viewback-click.png"] forState:UIControlStateSelected];
    [accountBackBtn addTarget:self action:@selector(accountBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:accountBackBtn];
#define TagAccountTypeButton100 100
    NSArray *array =[[NSArray alloc]initWithObjects:@"全部",@"充值",@"支付",@"派奖",@"提现", nil];
    for (int i=0; i<array.count; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(80+(132*i), 10, 132, 70);
        button.tag = TagAccountTypeButton100  +i;
        [button setTitleColor:[UIColor blackColor] forState:btnNormal];
        [button setBackgroundImage:RYCImageNamed(@"draw_cell_tab_btn.png") forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(accountDetailKindButton:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:button];
        
    }
    [array release];
}
/* 明细列表 */
- (void)accountTableView{
    self.accDataArray               = [[NSMutableArray alloc]initWithCapacity:1];
    accTableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, 900, 560) style:UITableViewStylePlain];
    accTableView.delegate           = self;
    accTableView.dataSource         = self;
    [self.view addSubview:accTableView];
    
    [self accountRefreshViewCreate];
}
- (void)accountRefreshViewCreate
{
    totalPageCount                      = 0;
    curPageIndex                        = 0;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 710, 900, REFRESH_HEADER_HEIGHT)];
    [accTableView addSubview:refreshView];
    refreshView.myScrollView            = accTableView;
    [refreshView stopLoading:NO];
}
- (void)accountNoRecoredViewCreate
{
    noRecordView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, 900, 550)];
    noRecordView.backgroundColor = RGBCOLOR(255, 255, 255);
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 200, 30)];
    textLabel.text = @"无记录";
    textLabel.font = [UIFont boldSystemFontOfSize:20];
    [noRecordView addSubview:textLabel];
    [textLabel release];
}
- (void)accountInitTableViewDataPage:(NSUInteger)pageIndex
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"accountdetail" forKey:@"command"];
    [mDic setObject:@"new" forKey:@"type"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDic setObject:@"15" forKey:@"maxresult"];
    [mDic setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    [mDic setObject:self.accTypeString forKey:@"transactiontype"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeAccountDetail showProgress:YES];

}
#pragma mark ---------- RYCNetManager delegate
- (void)netSuccessWithResult:(NSDictionary*)parserDict tag:(NSInteger)requestTag
{
    DLog(@"账号 明细-------- %@",parserDict);
    switch (requestTag) {
        case ASINetworkRequestTypeAccountDetail://账户明细
        {
            [self accountDetailTableDataReload:parserDict];
        }
            break;
        default:
            break;
    }
}
#pragma mark --------- account methods
/*  请求数据格式化 */
- (void)accountDetailTableDataReload:(NSDictionary *)dataDic
{
//    if (curPageIndex == 0)
//        [self.accDataArray removeAllObjects];
    
    if (RecordCodeNull(dataDic)) {//无记录
        [self.view addSubview:noRecordView];
        [accTableView removeFromSuperview];
        return;
    }
    if (ErrorCode(dataDic)) {
        [noRecordView removeFromSuperview];
        [self.view addSubview:accTableView];
        NSMutableArray * nuArray =[[NSMutableArray alloc]init];
        NSArray * array =[dataDic objectForKey:@"result"];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic =[array objectAtIndex:i];
            AccountDetailCellModel *model =[[AccountDetailCellModel alloc]init];
            model.amt = [dic objectForKey:@"amt"];
            model.blsign = [dic objectForKey:@"blsign"];
            model.platTime = [dic objectForKey:@"platTime"];
            model.memo =[dic objectForKey:@"memo"];
            model.transactionType = [dic objectForKey:@"ttransactionType"];
            [nuArray addObject:model];
//            [model release];
        }
        if (curPageIndex == 0) {
            [accDataArray removeAllObjects];
        }
        [self.accDataArray addObjectsFromArray:nuArray];
        [nuArray release];
        [accTableView reloadData];
        
        totalPageCount              = [KISDictionaryHaveKey(dataDic, @"totalPage") intValue];
        startY                      = accTableView.contentSize.height;
        
        centerY                     = accTableView.contentSize.height- 44*13;
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
   
}
- (void)accountBackButtonClick:(id)sender
{
    [self.delegate accountDetailViewDisappear:self];
}
- (void)accountDetailKindButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self refreshButtonImg:btn.tag];
    
    self.accTypeString = [NSString stringWithFormat:@"%d",btn.tag - TagAccountTypeButton100];
    curPageIndex = 0;
    [self  accountInitTableViewDataPage:curPageIndex];
}
- (void)refreshButtonImg:(int)buttpnTag
{
    for (int i = 0; i < 5; i++) {
        UIButton* tempButton = (UIButton*)[self.view viewWithTag:TagAccountTypeButton100 + i];
        if (buttpnTag == tempButton.tag) {
            tempButton.selected = YES;
        }
        else
            tempButton.selected = NO;
    }
}
#pragma mark ----------- account tableView 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.accDataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dequeCell = @"celled";
    AccountDetailTabelViewCell *cell =(AccountDetailTabelViewCell*) [tableView dequeueReusableCellWithIdentifier:dequeCell] ;
    if (cell == nil) {
        cell =[[[AccountDetailTabelViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model =[self.accDataArray objectAtIndex:indexPath.row];
    [cell accountCellContentView];
    return cell;
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
    NSLog(@"start");
    if(curPageIndex < totalPageCount)
    {
        [self accountInitTableViewDataPage:curPageIndex];
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
