//
//  QueryWinningViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-25.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryWinningViewController.h"
#import "RCLabel.h"
#import "JC_SeeDetailTableViewCell.h"
#import "ZC_LCB_SeeDetailTableViewCell.h"
#import "ZC_SeeDetailTableViewCell.h"

@interface QueryWinningViewController ()

@end

@implementation QueryWinningViewController
@synthesize  queryWinDataArray;
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
    [queryDetailView release];
    [refreshView release];
    [noRecordView release];
    [queryWinDataArray release],queryWinDataArray = nil;
    [winTabelView release];
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
    
    [self queryWinTitleView];
    [self queryWinTabelView];//中奖列表
    [self queryWinDetailView];
    
    [self sendWinQueryLotWithPage:0];
   
}
#pragma mark --------- view
/*  标题 */
- (void)queryWinTitleView
{
    
   [self.view addSubview:getTopLableWithTitle(@"中奖查询")];
    
    UIButton *integralBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    integralBackBtn.frame = CGRectMake(0, 0, 76, 77);
    [integralBackBtn setImage:[UIImage imageNamed:@"narBack.png"] forState:UIControlStateNormal];
    [integralBackBtn addTarget:self action:@selector(queryWinBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:integralBackBtn];
}
/*  中奖信息列表 */
- (void)queryWinTabelView
{
    self.queryWinDataArray              = [[NSMutableArray alloc]init];
    winTabelView                        = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, 908, 645) style:UITableViewStylePlain];
    winTabelView.delegate               = self;
    winTabelView.dataSource             = self;
    winTabelView.separatorStyle         = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:winTabelView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 0;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 720, 600, REFRESH_HEADER_HEIGHT)];
    [winTabelView addSubview:refreshView];
    refreshView.myScrollView            = winTabelView;
    [refreshView stopLoading:NO];
}
/* 中奖相亲 信息 */
- (void)queryWinDetailView
{
     queryDetailView =[[UIScrollView alloc]initWithFrame:CGRectMake(550, 100, 360, 600)];
    queryDetailView.backgroundColor =[UIColor clearColor];

    UIImageView *imgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryDetailBg.png"]];
    imgView.frame = CGRectMake(0, 0, queryDetailView.frame.size.width, queryDetailView.frame.size.height);
    [queryDetailView addSubview:imgView];
    [imgView release];
    
    UIButton *closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(305, 0, 55, 55);
    [closeBtn setImage:[UIImage imageNamed:@"queryclose.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(queryDetailCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [queryDetailView addSubview:closeBtn]; //125162466
    
    UILabel *winTitLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, queryDetailView.frame.size.width, 55)];
    winTitLabel.text = @"中奖详情";
    winTitLabel.textAlignment = NSTextAlignmentCenter;
    winTitLabel.backgroundColor =[UIColor clearColor];
    [queryDetailView addSubview:winTitLabel];
    [winTitLabel release];
    
    NSArray * winTetArray =[[NSArray alloc]initWithObjects:@"彩种类型:",@"期号:",@"订单号:",@"投注时间",@"兑奖时间:",@"倍数:",@"注数:",@"投注金额:",@"中奖金额:",@"开奖号码:",@"投注内容:", nil];
#define TagWinDetailLabel100 100
   for (int i=0; i<winTetArray.count; i++) {
        UILabel *detailLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 60+(40*i), 100, 25)];
        detailLabel.text = [winTetArray objectAtIndex:i];
        detailLabel.backgroundColor =[UIColor clearColor];
        detailLabel.textColor = RGBCOLOR(91, 132, 172);
        detailLabel.textAlignment = NSTextAlignmentCenter;
        [queryDetailView addSubview:detailLabel];
        [detailLabel release];
        
        UILabel *messLabel =[[UILabel alloc]initWithFrame:CGRectMake(110, detailLabel.frame.origin.y, 200, 25)];
        messLabel.backgroundColor =[UIColor clearColor];
        messLabel.tag = TagWinDetailLabel100 +i;
        [queryDetailView addSubview:messLabel];
        [messLabel release];
    }
    [winTetArray release];
    
    UIScrollView *contentTextView =[[UIScrollView alloc]initWithFrame:CGRectMake(10, 485, 340, 100)];
    contentTextView.tag = TagWinDetailLabel100+99;
//    contentTextView.backgroundColor  =[UIColor whiteColor];
//    contentTextView.editable = NO;
//    contentTextView.font = [UIFont systemFontOfSize:17];
    [queryDetailView addSubview:contentTextView];
    [contentTextView release];

}
- (void)queryWinNoRecordView
{
    noRecordView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 900, 640)];
    noRecordView.backgroundColor = RGBCOLOR(255, 255, 255);
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 200, 30)];
    textLabel.text = @"无记录";
    textLabel.font = [UIFont boldSystemFontOfSize:20];
    [noRecordView addSubview:textLabel];
    [textLabel release];
}
#pragma mark ---------- RYCNetManager delegate
- (void)sendWinQueryLotWithPage:(int)pageIndex
{
    /* 中奖查询 */
    NSMutableDictionary * mDic =[[NSMutableDictionary alloc]init];
//    [mDic setObject:@"QueryLot" forKey:@"command"];
//    [mDic setObject:@"win" forKey:@"type"];
    [mDic setObject:@"select" forKey:@"command"];
    [mDic setObject:@"winList" forKey:@"requestType"];
    [mDic setObject:@"10" forKey:@"maxresult"];
    [mDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeQueryLotWin showProgress:YES];
    [mDic release];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryLotWin://
        {
            [self queryWinnTabelDataDic:dataDic];
        }
            break;
        case ASINetworkRequestTypeQueryCaseLotDetail://投注内容
        {
            if (ErrorCode(dataDic)) {
                [self showBetContent:KISDictionaryHaveKey(dataDic, @"result")];
            }
        }break;
        default:
            break;
    }
}
/* 请求返回数据 数组化  */
- (void)queryWinnTabelDataDic:(NSDictionary *)mDic
{
//    if (RecordCodeNull(mDic)) {
//        [winTabelView removeFromSuperview];
//        [self.view addSubview:noRecordView];
//        return;
//    }
    if (ErrorCode(mDic)) {
        [noRecordView removeFromSuperview];
        [self.view addSubview:winTabelView];
        NSMutableArray *nArray =[[NSMutableArray alloc]init];
        NSArray * result =[mDic objectForKey:@"result"];
        for (int i=0; i<result.count; i++) {
            NSDictionary *dic   = [result objectAtIndex:i];
            QueryWinningCellModel *model =[[QueryWinningCellModel alloc]init];
            model.orderId       = [dic objectForKey:@"orderId"];
            model.lotNo         = [dic objectForKey:@"lotNo"];
            model.lotName       = [dic objectForKey:@"lotName"];
            model.lotMulti      = [dic objectForKey:@"lotMulti"];
            model.betNum        = [dic objectForKey:@"betNum"];
            model.betCode       = [dic objectForKey:@"betCode"];
            model.amount        = [dic objectForKey:@"amount"];
            model.winAmount     = [dic objectForKey:@"prizeAmt"];
            model.batchCode     = [dic objectForKey:@"batchCode"];
            model.sellTime      = [dic objectForKey:@"orderTime"];
            model.cashTime      = [dic objectForKey:@"cashTime"];
            model.winCode       = [dic objectForKey:@"winCode"];
            [nArray addObject:model];
            [model release];
        }
        [self.queryWinDataArray addObjectsFromArray:nArray];
        [nArray release];
        [winTabelView reloadData];
        
        totalPageCount              = [KISDictionaryHaveKey(mDic, @"totalPage") intValue];
        startY                      = winTabelView.contentSize.height;
        
        centerY                     = winTabelView.contentSize.height - 640;
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
/* 中奖详情 显示 */
- (void)queryWinQueryDetailView:(QueryWinningCellModel *)model
{
    [self.view addSubview:queryDetailView];
    
    self.clickLotNo = model.lotNo;
    
     NSArray * messArray =[[NSArray alloc]initWithObjects:model.lotName,
                           model.batchCode,
                           model.orderId,
                           model.sellTime,
                           model.cashTime ,
                           [NSString stringWithFormat:@"%@倍", model.lotMulti],
                           [NSString stringWithFormat:@"%@注", model.betNum],
                           [NSString stringWithFormat:@"%0.2f元",[model.amount intValue]/100.0],
                           [NSString stringWithFormat:@"%0.2f元",[model.winAmount intValue]/100.0],
                           model.winCode,nil];
    for (int i=0; i<messArray.count; i++) {
        UILabel * messLabel = (UILabel *)[queryDetailView viewWithTag:TagWinDetailLabel100+i];
        messLabel.text =[[messArray objectAtIndex:i] length] > 0 ? [messArray objectAtIndex:i] : @"无";

    }
    [messArray release];
    
//    UITextView * contentTextView = (UITextView *)[queryDetailView viewWithTag:TagWinDetailLabel100+99];
//    contentTextView.text = model.betCode;
   
    [[queryDetailView viewWithTag:TagWinDetailLabel100+99] removeFromSuperview];
    UIScrollView *contentTextView =[[UIScrollView alloc]initWithFrame:CGRectMake(10, 485, 340, 100)];
    contentTextView.tag = TagWinDetailLabel100+99;
    [queryDetailView addSubview:contentTextView];
    [contentTextView release];

    //投注内容展示
    NSMutableDictionary * mDic =[[NSMutableDictionary alloc]init];
    [mDic setObject:@"select" forKey:@"command"];
    [mDic setObject:@"betCodeAnalysis" forKey:@"requestType"];
    [mDic setObject:model.orderId forKey:@"id"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeQueryCaseLotDetail showProgress:YES];
}

- (void)showBetContent:(NSDictionary*)betcontenDic
{
    NSDictionary* betCodeJson = KISDictionaryHaveKey(betcontenDic, @"betCodeJson");
    if ([self.clickLotNo isEqualToString:kLotNoJCLQ_SF] ||
        [self.clickLotNo isEqualToString:kLotNoJCLQ_RF] ||
        [self.clickLotNo isEqualToString:kLotNoJCLQ_SFC] ||
        [self.clickLotNo isEqualToString:kLotNoJCLQ_DXF] ||
        [self.clickLotNo isEqualToString:kLotNoJCLQ_CONFUSION] ||
        
        [self.clickLotNo isEqualToString:kLotNoJCZQ_RQ] ||
        [self.clickLotNo isEqualToString:kLotNoJCZQ_SPF] ||
        [self.clickLotNo isEqualToString:kLotNoJCZQ_ZJQ] ||
        [self.clickLotNo isEqualToString:kLotNoJCZQ_SCORE] ||
        [self.clickLotNo isEqualToString:kLotNoJCZQ_HALF] ||
        [self.clickLotNo isEqualToString:kLotNoJCZQ_CONFUSION]||
        
        [self.clickLotNo isEqualToString:kLotNoBJDC_RQSPF]||
        [self.clickLotNo isEqualToString:kLotNoBJDC_JQS]||
        [self.clickLotNo isEqualToString:kLotNoBJDC_Score]||
        [self.clickLotNo isEqualToString:kLotNoBJDC_HalfAndAll]||
        [self.clickLotNo isEqualToString:kLotNoBJDC_SXDS])//竞彩  北京单场
    {
        float heigth = 0;
        NSArray* resultArray = [betCodeJson objectForKey:@"result"];
        if ([@"true" isEqualToString:[betCodeJson objectForKey:@"display"]])//玩法
        {
            if ([resultArray count] > 0) {
                NSString *temp_paly = KISNullValue(resultArray, 0, @"play");
                if (![temp_paly isEqualToString:@""]) {
                    NSArray* wanFa_array = [temp_paly componentsSeparatedByString:@","];
                    heigth += 20 * ([wanFa_array count]/5) + 30 + 30;//30是编号行
                }
            }
        }
        NSMutableArray* contentHeigth = [[NSMutableArray alloc] initWithCapacity:1];

        [contentHeigth addObject:[NSString stringWithFormat:@"%f", heigth]];//第一位是玩法高度
        
        for (int k = 0; k < [resultArray count]; k++) {
            if([self.clickLotNo isEqualToString:kLotNoJCZQ_GYJ])//算赔率总高度
            {
                NSString *betData= KISNullValue(resultArray, k,@"peiLv");//如果倍数高 赔率返回不同值就多
                
                RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(10,10,300,10)];
                betData = [betData stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
                RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:betData];
                tempLabel.componentsAndPlainText = componentsDS;
                CGSize optimalSize = [tempLabel optimumSize];
                [contentHeigth addObject:[NSString stringWithFormat:@"%f", MAX(optimalSize.height, 35)]];
                
                heigth += MAX(optimalSize.height, 35);
            }
            else
            {
                NSString *betData= KISNullValue(resultArray, k,@"betContentHtml");//投注内容
                
                RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(10,10,300,10)];
                betData = [betData stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
                RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:betData];
                tempLabel.componentsAndPlainText = componentsDS;
                CGSize optimalSize = [tempLabel optimumSize];
                
                RCLabel *matchResult = [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, 70, 10)];
                matchResult.textAlignment = RTTextAlignmentCenter;
                RTLabelComponentsStructure *matchResultDS = [RCLabel extractTextStyle:KISNullValue(resultArray, k,@"matchResult")];
                matchResult.componentsAndPlainText = matchResultDS;
                CGSize resultSize = [matchResult optimumSize];
                
                float hig = MAX(optimalSize.height, resultSize.height+20);//20为比分高
                [contentHeigth addObject:[NSString stringWithFormat:@"%f", MAX(hig, 60)]];
                heigth += MAX(hig, 60);
            }
        }
        
        UIScrollView * contentTextView = (UIScrollView *)[queryDetailView viewWithTag:TagWinDetailLabel100+99];
        contentTextView.contentSize = CGSizeMake(340, heigth + 20);
        
        JC_SeeDetailTableViewCell* jc = [[JC_SeeDetailTableViewCell alloc] initWithFrame:CGRectMake(10, 0, 300, heigth + 20)];
        jc.contentStr = [betCodeJson objectForKey:@"result"];
        jc.jc_lotNo = self.clickLotNo;
        jc.contentHeight = contentHeigth;
        [jc setBackgroundColor:[UIColor clearColor]];
        
        [contentTextView addSubview:jc];

    }
    else if([self.clickLotNo isEqualToString:kLotNoSFC] || [self.clickLotNo isEqualToString:kLotNoJQC] || [self.clickLotNo isEqualToString:kLotNoRX9] || [self.clickLotNo isEqualToString:kLotNoLCB])//足彩
    {
        NSArray* resultArray = [[[betCodeJson objectForKey:@"result"] objectAtIndex: 0] objectForKey:@"result"];
        //计算 表格的高度，根据 我的投注内容多少来定
        int tableHeight = zcCellHeight * [resultArray count] + 80;
        UIScrollView * contentTextView = (UIScrollView *)[queryDetailView viewWithTag:TagWinDetailLabel100+99];
        contentTextView.contentSize = CGSizeMake(340, tableHeight);
        

        if([self.clickLotNo isEqualToString:kLotNoLCB] || [self.clickLotNo isEqualToString:kLotNoJQC])
        {
            ZC_LCB_SeeDetailTableViewCell* zc_lcb = [[ZC_LCB_SeeDetailTableViewCell alloc] initWithFrame:CGRectMake(10, 0, 300, tableHeight)];
            zc_lcb.contentStr =  resultArray;
            zc_lcb.isZC_JQC = NO;
            zc_lcb.play = [[[betCodeJson objectForKey:@"result"] objectAtIndex: 0] objectForKey:@"play"];
            if([self.clickLotNo isEqualToString:kLotNoJQC])
            {
                zc_lcb.isZC_JQC = YES;
            }
            [zc_lcb setBackgroundColor:[UIColor clearColor]];
            
            [contentTextView addSubview:zc_lcb];
        }
        else
        {
            ZC_SeeDetailTableViewCell* zc = [[ZC_SeeDetailTableViewCell alloc] initWithFrame:CGRectMake(10, 0, 300, tableHeight)];
            zc.contentStr = resultArray;
            zc.play = [[[betCodeJson objectForKey:@"result"] objectAtIndex: 0] objectForKey:@"play"];
            [zc setBackgroundColor:[UIColor clearColor]];
            
            [contentTextView addSubview:zc];
        }
    }
    else//数字彩
    {
        NSString *tempContentstr = KISDictionaryHaveKey(betcontenDic, @"betCodeHtml");
        
        RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(10,10,300,10)];
        tempContentstr = [tempContentstr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        tempContentstr = [tempContentstr stringByReplacingOccurrencesOfString:@"," withString:@"，"];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:tempContentstr];
        tempLabel.componentsAndPlainText = componentsDS;
        CGSize optimalSize = [tempLabel optimumSize];
        tempLabel.frame = CGRectMake(10, 10, 320, optimalSize.height);
        
        UIScrollView * contentTextView = (UIScrollView *)[queryDetailView viewWithTag:TagWinDetailLabel100+99];
        contentTextView.contentSize = CGSizeMake(340, optimalSize.height);
        [contentTextView addSubview:tempLabel];
        [tempLabel release];
    }
}
#pragma mark ----------- methods
/* 返回 释放 */
- (void)queryWinBackButtonClick:(id)sender
{
    [self.delegate queryWinningViewDisappear:self];
    
}
#pragma mark- ------------ queryWin delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.queryWinDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell = @"celled";
    QueryWinningTableViewCell * cell = (QueryWinningTableViewCell*) [tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell =[[[QueryWinningTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
  
        }
    cell.winModel =[self.queryWinDataArray objectAtIndex:indexPath.row];
    cell.winState = @"2";
    [cell queryWinContentViewCreate];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == winTabelView) {
        [self queryWinQueryDetailView:[self.queryWinDataArray objectAtIndex:indexPath.row]];
    }
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
        [self sendWinQueryLotWithPage:curPageIndex];
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
