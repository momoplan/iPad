//
//  QueryBetViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-25.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryBetViewController.h"

@interface QueryBetViewController ()

@end

@implementation QueryBetViewController
@synthesize delegate;
@synthesize quetyBetArray;
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
    [quetyBetArray release],quetyBetArray = nil;
    [betTableView release];
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
	// Do any additional setup after loading the view.
    [super tabBarBackgroundImageViewWith:self.view];
    [self queryBetTitleView];       //标题
    [self queryBetTableViewCreate]; // 显示列表
    [self queryBetDetailviewCreate];
    
    [self sendReuestBetQueryLotWithPage:0];
}
#pragma mark ---------- querybet view
- (void)queryBetTitleView
{
    [self.view addSubview:getTopLableWithTitle(@"投注查询")];
    
    UIButton *queryBetBackBtn   =[UIButton buttonWithType:UIButtonTypeCustom];
    queryBetBackBtn.frame       = CGRectMake(0, 0, 76, 76);
    [queryBetBackBtn setImage:[UIImage imageNamed:@"narBack.png"] forState:UIControlStateNormal];
    [queryBetBackBtn addTarget:self action:@selector(queryBetBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryBetBackBtn];
}
/* 投注查询 列表 */
- (void)queryBetTableViewCreate
{
    self.quetyBetArray                  = [[NSMutableArray alloc]init];
    betTableView                        = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, 908, 645) style:UITableViewStylePlain];
    betTableView.dataSource             = self;
    betTableView.delegate               = self;
    [self.view addSubview:betTableView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 0;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 710, 600, REFRESH_HEADER_HEIGHT)];
    [betTableView addSubview:refreshView];
    refreshView.myScrollView            = betTableView;
    [refreshView stopLoading:NO];
}
- (void)queryBetDetailviewCreate
{
    queryDetailView                     = [[UIScrollView alloc]initWithFrame:CGRectMake(550, 100, 360, 600)];
//    queryDetailView.contentSize = CGSizeMake(queryDetailView.frame.size.width, 1000);
    queryDetailView.backgroundColor     = [UIColor clearColor];

    UIImageView *imgView                = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryDetailBg.png"]];
    imgView.frame                       = CGRectMake(0, 0, queryDetailView.frame.size.width, queryDetailView.frame.size.height);
    [queryDetailView addSubview:imgView];
    [imgView release];
    
    UIButton *closeBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame                      = CGRectMake(305, 0, 55, 55);
    [closeBtn setImage:[UIImage imageNamed:@"queryclose.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(queryDetailCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [queryDetailView addSubview:closeBtn];
    
    
    UILabel *winTitLabel                = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, queryDetailView.frame.size.width, 55)];
    winTitLabel.text                    = @"投注详情";
    winTitLabel.textAlignment           = NSTextAlignmentCenter;
    winTitLabel.backgroundColor         = [UIColor clearColor];
    [queryDetailView addSubview:winTitLabel];
    [winTitLabel release];
#define TagDetailMessLabel100 100
    NSArray * winTetArray =[[NSArray alloc]initWithObjects:@"彩种类型:",@"期号:",@"订单号:",@"倍数:",@"注数:",@"投注金额:",@"中奖金额:",@"出票状态",@"购买时间",@"开奖号码:",@"投注内容:", nil];
    for (int i=0; i<winTetArray.count; i++) {
        UILabel *detailLabel            = [[UILabel alloc]initWithFrame:CGRectMake(10, 60+(40*i), 100, 25)];
        detailLabel.text                = [winTetArray objectAtIndex:i];
        detailLabel.backgroundColor     = [UIColor clearColor];
        detailLabel.textColor           = [UIColor blueColor];
        detailLabel.textAlignment       = NSTextAlignmentCenter;
        [queryDetailView addSubview:detailLabel];
        [detailLabel release];
        
        UILabel *messLabel              = [[UILabel alloc]initWithFrame:CGRectMake(110, detailLabel.frame.origin.y, 200, 25)];
        messLabel.backgroundColor       = [UIColor clearColor];
        messLabel.tag                   = TagDetailMessLabel100 + i;
        [queryDetailView addSubview:messLabel];
        [messLabel release];
    }
    [winTetArray release];
    
    UITextView *contentTextView         = [[UITextView alloc]initWithFrame:CGRectMake(110, 460, 250, 145)];
    contentTextView.editable            = NO;
    contentTextView.backgroundColor     = [UIColor clearColor];
    contentTextView.tag                 = TagDetailMessLabel100 + 99;
    contentTextView.font                = [UIFont systemFontOfSize:17];
    [queryDetailView addSubview:contentTextView];
    [contentTextView release];
}
- (void)quertBetNoRecordView
{
    noRecordView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, 900, 550)];
    noRecordView.backgroundColor = RGBCOLOR(255, 255, 255);
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 200, 30)];
    textLabel.text = @"无记录";
    textLabel.font = [UIFont boldSystemFontOfSize:20];
    [noRecordView addSubview:textLabel];
    [textLabel release];

}
/*  投注详情 显示*/
- (void)queryBetDetailViewModel:(QueryBetCellModel *)model
{
    NSString * winPrizeState = @"0";
    switch ([model.prizeState intValue]) {
        case 0: // 未开奖
        {
            winPrizeState = @"未开奖";
        }
            break;
        case 3: // 未中奖
        {
            winPrizeState = @"未中奖";
        }
            break;
        default:
            winPrizeState = [NSString stringWithFormat:@"%0.2f元",[model.prizeAmt intValue]/100.0];
            break;
    }
    NSArray *messArray = @[model.lotName,
                           model.batchCode,
                           model.orderId,
                           [NSString stringWithFormat:@"%@倍",model.lotMulti],
                           [NSString stringWithFormat:@"%@注",model.betNum],
                           [NSString stringWithFormat:@"%.2f元",[model.amount intValue]/100.0],
                           winPrizeState,
                           model.stateMemo,
                           model.orderTime,
                           model.winCode,];
    DLog(@"messArray %@",messArray);
    for (int i=0; i<messArray.count; i++) {
        UILabel *label = (UILabel *)[queryDetailView viewWithTag:TagDetailMessLabel100+i];
        label.text = [[messArray objectAtIndex:i] length] > 0 ? [messArray objectAtIndex:i] : @"无";
        label.textColor = [UIColor blackColor];

        if ([model.prizeState isEqualToString:@"3"] && i == 6) {
            label.textColor = [UIColor grayColor];
        }
    }
    UITextView * contentTextView =  (UITextView *)[queryDetailView viewWithTag:TagDetailMessLabel100+99];
    contentTextView.text = model.betCode;
    
    [self.view addSubview:queryDetailView];

}
#pragma mark ---------- RYCNetManager delegate
- (void)sendReuestBetQueryLotWithPage:(int)pageIndex
{
    /* 投注查询 request*/
    NSMutableDictionary * mDic =[[NSMutableDictionary alloc]init];
    [mDic setObject:@"QueryLot" forKey:@"command"];//命令
    [mDic setObject:@"bet" forKey:@"type"];//请求类型
    [mDic setObject:@"9" forKey:@"maxresult"];//每页显示的条数
    [mDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];//当前页数
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDic setObject:@"1" forKey:@"isSellWays"];
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeQueryLotBet showProgress:YES];
    [mDic release];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryLotBet://
        {
            [self queryBetTableDataTidy:dataDic];
        }
            break;
        default:
            break;
    }
}
/* 投注查询 数据处理 */
- (void)queryBetTableDataTidy:(NSDictionary *)betDic
{
    if (RecordCodeNull(betDic)) {
        return;
    }
    NSArray  * result = KISDictionaryHaveKey(betDic, @"result");
    NSMutableArray *nsArray =[[NSMutableArray alloc]init];
    for (int i=0; i<result.count; i++) {
        NSDictionary * dic =[result objectAtIndex:i];
        QueryBetCellModel *model =[[QueryBetCellModel alloc]init];
        model.lotNo         = KISDictionaryHaveKey(dic, @"lotNo");
        model.lotName       = KISDictionaryHaveKey(dic, @"lotName");
        model.orderId       = KISDictionaryHaveKey(dic, @"orderId");
        model.batchCode     = KISDictionaryHaveKey(dic, @"batchCode");
        model.amount        = KISDictionaryHaveKey(dic, @"amount");
        model.aneAmount     = KISDictionaryHaveKey(dic, @"oneAmount");
        model.lotMulti      = KISDictionaryHaveKey(dic, @"lotMulti");
        model.betNum        = KISDictionaryHaveKey(dic, @"betNum");
        model.play          = KISDictionaryHaveKey(dic, @"play");
        model.betCode       = KISDictionaryHaveKey(dic, @"betCode");
        model.orderTime     = KISDictionaryHaveKey(dic, @"orderTime");
        model.prizeAmt      = KISDictionaryHaveKey(dic, @"prizeAmt");
        model.prizeState    = KISDictionaryHaveKey(dic, @"prizeState");
        model.winCode       = KISDictionaryHaveKey(dic, @"winCode");
        model.stateMemo     = KISDictionaryHaveKey(dic, @"stateMemo");
        model.isRepeatBuy   = KISDictionaryHaveKey(dic, @"isRepeatBuy");
        [nsArray addObject:model];
        [model release];
    }
    [self.quetyBetArray addObjectsFromArray:nsArray];
    [nsArray release];
    [betTableView reloadData];
    
    totalPageCount              = [KISDictionaryHaveKey(betDic, @"totalPage") intValue];
    startY                      = betTableView.contentSize.height;
    
    centerY                     = betTableView.contentSize.height - 640;
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
#pragma mark ------ queryBet methods
- (void)queryBetBackButtonClick:(id)sender
{
    [self.delegate queryBetViewDisappear:self];
}
#pragma mark --------- bet tableView delegate &dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.quetyBetArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dequeCell = @"celled";
    QueryWinningTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell =[[[QueryWinningTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
    }
    cell.winState = @"1";
    cell.betModel =[self.quetyBetArray objectAtIndex:indexPath.row];
    [cell queryWinContentViewCreate];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self queryBetDetailViewModel:[self.quetyBetArray objectAtIndex:indexPath.row]];
}
- (void)queryDetailCloseButton:(id)sender
{
    [queryDetailView removeFromSuperview];
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
        [self sendReuestBetQueryLotWithPage:curPageIndex];
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
