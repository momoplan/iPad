//
//  QueryTogetherViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryTogetherViewController.h"
#import "CommonRecordStatus.h"

@interface QueryTogetherViewController ()

@end

@implementation QueryTogetherViewController
@synthesize delegate;
@synthesize queryTogeArray;
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
//    self.delegate = nil;
    [detailBgView release];
    [queryTogeArray release],queryTogeArray = nil;
    [togethTabelView release];
    [refreshView release];
    [togeTypeString release];
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
    
    togeTypeString = @"1";
    [self queryTogetherTitleView];
    [self queryTogetherTableView];
    [self queryTogetherCellDetailView];
    [self queryTogetherRequestWithPage:0];//数据请求
//    togeTypeString = @"2";
//    [self sendQueryRequestAutoJoinWithPage:0];

//    [self queryAutoJoinDetailView];
}

#pragma mark -------- together view
/* 标题 */
- (void)queryTogetherTitleView
{
   [self.view addSubview:getTopLableWithTitle(@"合买查询")];
    
    UIButton *queryTogetherBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    queryTogetherBackBtn.frame      = CGRectMake(0, 1, 76, 76);
    [queryTogetherBackBtn setImage:[UIImage imageNamed:@"narBack.png"] forState:UIControlStateNormal];
    [queryTogetherBackBtn addTarget:self action:@selector(queryTogetherBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryTogetherBackBtn];
    
//    UIView * headView           =[[UIView alloc]initWithFrame:CGRectMake(0, 75, 908, 80)];
//    headView.backgroundColor    = RGBCOLOR(244, 244, 244);
//    [self.view addSubview:headView];
//    [headView release];
    
#define TagTogetherButton100 100
    
//    UIButton * launchBtn        =[UIButton buttonWithType:UIButtonTypeCustom];
//    launchBtn.frame             = CGRectMake(20, 10, 150, 60);
//    [launchBtn setTitle:@"合买查询" forState:UIControlStateNormal];
//    [launchBtn setTitleColor:[UIColor blackColor] forState:btnNormal];
//    [launchBtn addTarget:self action:@selector(queryTogetherLaunchOrDocumentary:) forControlEvents:UIControlEventTouchUpInside];
//    launchBtn.tag               = TagTogetherButton100;
//    [launchBtn setBackgroundImage:RYCImageNamed(@"basketSelect.png") forState:UIControlStateSelected];
//    launchBtn.selected = YES;
//    [headView addSubview:launchBtn];
//    
//    UIButton * docBtn           =[UIButton buttonWithType:UIButtonTypeCustom];
//    docBtn.frame                = CGRectMake(launchBtn.frame.size.width+launchBtn.frame.origin.x, 10, 150, 60);
//    [docBtn setTitleColor:[UIColor blackColor] forState:btnNormal];
//    docBtn.tag                  = TagTogetherButton100 +1;
//    [docBtn setBackgroundImage:RYCImageNamed(@"basketSelect.png") forState:UIControlStateSelected];
//    [docBtn setTitle:@"跟单查询" forState:UIControlStateNormal];
//    [docBtn addTarget:self action:@selector(queryTogetherLaunchOrDocumentary:) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:docBtn];
}
/* 合买列表 */
- (void)queryTogetherTableView
{
    self.queryTogeArray         = [[NSMutableArray alloc]init];
    togethTabelView             =[[UITableView alloc]initWithFrame:CGRectMake(0, 70, 908, 648) style:UITableViewStylePlain];
    togethTabelView.delegate    = self;
    togethTabelView.dataSource  = self;
    [self.view addSubview:togethTabelView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 0;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 710, 600, REFRESH_HEADER_HEIGHT)];
    [togethTabelView addSubview:refreshView];
    refreshView.myScrollView            = togethTabelView;
    [refreshView stopLoading:NO];
}
/* 合买详情 */
- (void)queryTogetherCellDetailView
{
    detailBgView =[[QueryTogetherDetailView alloc]initWithFrame:CGRectMake(550, 120, 360, 550)];
    detailBgView.delegate = self;
}
/*  跟单详情 */
- (void)queryAutoJoinDetailView
{
    UIView * joinDetailView = [[UIView alloc]initWithFrame:CGRectMake(550, 120, 360, 550)];
    joinDetailView.backgroundColor = RGBCOLOR(244, 244, 244);
    
    UIImageView *imgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryDetailBg.png"]];
    imgView.frame = CGRectMake(0, 0,joinDetailView.frame.size.width,joinDetailView.frame.size.height);
    [joinDetailView addSubview:imgView];
    [imgView release];
        
    UILabel *titLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, joinDetailView.frame.size.width, 30)];
    titLabel.backgroundColor =[UIColor clearColor];
    titLabel.text = @"跟单详情";
    titLabel.textAlignment = NSTextAlignmentCenter;
    [joinDetailView addSubview:titLabel];
    [titLabel release];
    
    UIButton *closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(305, 0, 55, 55);
    [closeBtn setImage:[UIImage imageNamed:@"queryclose.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(queryAutoJoinDetailCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [joinDetailView addSubview:closeBtn];

#define TagAutoJoinLabel300 300
    
    NSArray * namArray = @[@"跟单名人:",@"战绩:",@"定制时间:",@"状态:",@"跟单类型:",@"定制金额:",@"定制次数:",@"强制参与:"];
    for (int i=0; i<namArray.count; i++) {
        UILabel * rigLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50+(40*i), 120, 30)];
        rigLabel.text = [namArray objectAtIndex:i];
        rigLabel.textAlignment = NSTextAlignmentCenter;
        rigLabel.textColor = [UIColor blueColor];
        [joinDetailView addSubview:rigLabel];
        [rigLabel release];
        
        UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(rigLabel.frame.origin.x+rigLabel.frame.size.width, rigLabel.frame.origin.y, 200, 30)];
        messLabel.tag =  TagAutoJoinLabel300 + i;
        [joinDetailView addSubview:messLabel];
        [messLabel release];
        
    }
    
    
}
#pragma mark ---------- RYCNetManager delegate
/* 合买 查询 请求 */
- (void)queryTogetherRequestWithPage:(int )pageIndex
{
    // 合买查询
    NSMutableDictionary * mDict =[[NSMutableDictionary alloc]init];
    [mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDict setObject:@"select" forKey:@"command"];
    [mDict setObject:@"caseLotBuyList" forKey:@"requestType"];
    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    [mDict setObject:@"9" forKey:@"maxresult"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeQueryCaseLot showProgress:YES];
    [mDict release];
}
/*  跟单查询 */
- (void)sendQueryRequestAutoJoinWithPage:(int)pageIndex
{
    NSMutableDictionary* mDict = [[NSMutableDictionary alloc]init];
	[mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDict setObject:@"autoJoin" forKey:@"command"];
    [mDict setObject:@"selectAutoJoin" forKey:@"requestType"];
    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    [mDict setObject:@"9" forKey:@"maxresult"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeQueryCaseLot_AutoOrder showProgress:YES];
    [mDict release];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryCaseLot:// 合买查询
        {
            [self queryTogetherTableDataDistionary:dataDic];
        }
            break;
        case ASINetworkRequestTypeQueryCaseLot_AutoOrder://跟单
        {
            [self queryLotAutoOrderDataTidyDic:dataDic];
        }
            break;
        case ASINetworkRequestTypeQueryCaseLotDetail://合买详情
        {
            [self queryTogetherDataTidyDictionary:dataDic];
        }
            break;
        default:
            break;
    }
}
/*  合买查询数据 整理 */
- (void)queryTogetherTableDataDistionary:(NSDictionary *)mDic
{
    NSMutableArray *muArray =[[NSMutableArray alloc]init];
    NSArray * result =KISDictionaryHaveKey(mDic, @"result");
    for (int i=0; i<result.count; i++) {
        NSDictionary * dic =[result objectAtIndex:i];
        QueryTogetherCellModel *model = [[QueryTogetherCellModel alloc]init];
        model.caseLotId         = KISDictionaryHaveKey(dic, @"caseLotId");
        model.starter           = KISDictionaryHaveKey(dic, @"starter");
        model.lotNo             = KISDictionaryHaveKey(dic, @"lotNo");
        model.lotName           = KISDictionaryHaveKey(dic, @"lotName");
        model.buyAmt            = KISDictionaryHaveKey(dic, @"buyAmt");
        model.prizeAmt          = KISDictionaryHaveKey(dic, @"prizeAmt");
        model.displayState      = KISDictionaryHaveKey(dic, @"displayState");
        model.buyTime           = KISDictionaryHaveKey(dic, @"buyTime");
        model.prizeState        = KISDictionaryHaveKey(dic, @"prizeState");
        [muArray addObject:model];
        [model release];
    }
    if (curPageIndex == 0) {
        [self.queryTogeArray removeAllObjects];
    }
    [self.queryTogeArray addObjectsFromArray:muArray]; ;
    [muArray release];
    [togethTabelView reloadData];
    
    totalPageCount              = [KISDictionaryHaveKey(mDic, @"totalPage") intValue];
    startY                      = togethTabelView.contentSize.height;
    
    centerY                     = togethTabelView.contentSize.height - 660;
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
- (void)queryLotAutoOrderDataTidyDic:(NSDictionary *)mDic
{
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    NSArray * result = KISDictionaryHaveKey(mDic, @"result");
    for (int i=0; i<result.count; i++) {
        NSDictionary *dic =[result objectAtIndex:i];
        QueryTogetherDocumentaryModel *model = [[QueryTogetherDocumentaryModel alloc]init];
        model.tradeId = KISDictionaryHaveKey(dic, @"id");
        model.starter           = KISDictionaryHaveKey(dic, @"starter");
        model.starterUserNo     = KISDictionaryHaveKey(dic, @"starterUserNo");
        
        NSDictionary *palyIcon  = KISDictionaryHaveKey(dic, @"displayIcon");
        model.goldStar          = KISDictionaryHaveKey(palyIcon, @"goldStar");
        model.graygoldStar      = KISDictionaryHaveKey(palyIcon, @"graygoldStar");
        model.diamond           = KISDictionaryHaveKey(palyIcon, @"diamond");
        model.graydiamond       = KISDictionaryHaveKey(palyIcon, @"graydiamond");
        model.cup               = KISDictionaryHaveKey(palyIcon, @"cup");
        model.graycup           = KISDictionaryHaveKey(palyIcon, @"graycup");
        model.crown             = KISDictionaryHaveKey(palyIcon, @"crown");
        model.graycrown         = KISDictionaryHaveKey(palyIcon, @"graycrown");
        
        model.lotNo             = KISDictionaryHaveKey(dic, @"lotNo");
        model.lotName           = KISDictionaryHaveKey(dic, @"lotName");
        model.times             = KISDictionaryHaveKey(dic, @"times");
        model.joinAmt           = KISDictionaryHaveKey(dic, @"joinAmt");
        model.safeAmt           = KISDictionaryHaveKey(dic, @"safeAmt");
        model.maxAmt            = KISDictionaryHaveKey(dic, @"maxAmt");
        model.percent           = KISDictionaryHaveKey(dic, @"percent");
        model.joinType          = KISDictionaryHaveKey(dic, @"joinType");
        model.forceJoin         = KISDictionaryHaveKey(dic, @"forceJoin");
        model.createTime        =KISDictionaryHaveKey(dic, @"createTime");
        model.state             = KISDictionaryHaveKey(dic, @"state");
        [muArray addObject:model];
        [model release];
    }
    if (curPageIndex ==0) {
        [self.queryTogeArray removeAllObjects];
    }
    [self.queryTogeArray addObjectsFromArray:muArray];
    [muArray release];
    [togethTabelView reloadData];
}
/*  合买详情 请求 */
- (void)queryTogetherDetailRequsetCaseId:(NSString *)caseId
{
    NSMutableDictionary * dic = (NSMutableDictionary*)@{@"command" : @"select",@"requestType":@"caseLotDetail",@"id":caseId,@"userno":[UserLoginData sharedManager].userNo};
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:dic withRequestType:ASINetworkRequestTypeQueryCaseLotDetail showProgress:YES];
}
/*  合买 详情 数据整理 */
- (void)queryTogetherDataTidyDictionary:(NSDictionary *)mDic
{
    NSDictionary * dic = KISDictionaryHaveKey(mDic, @"result");
    QueryTogetherDetailModel * model =[[QueryTogetherDetailModel alloc]init];
    NSDictionary *palyIcon  = KISDictionaryHaveKey(dic, @"displayIcon");
    model.goldStar          = KISDictionaryHaveKey(palyIcon, @"goldStar");
    model.graygoldStar      = KISDictionaryHaveKey(palyIcon, @"graygoldStar");
    model.diamond           = KISDictionaryHaveKey(palyIcon, @"diamond");
    model.graydiamond       = KISDictionaryHaveKey(palyIcon, @"graydiamond");
    model.cup               = KISDictionaryHaveKey(palyIcon, @"cup");
    model.graycup           = KISDictionaryHaveKey(palyIcon, @"graycup");
    model.crown             = KISDictionaryHaveKey(palyIcon, @"crown");
    model.graycrown         = KISDictionaryHaveKey(palyIcon, @"graycrown");

    model.caseLotId         = KISDictionaryHaveKey(dic, @"caseLotId");
    model.starter           = KISDictionaryHaveKey(dic, @"starter");
    model.lotNo             = KISDictionaryHaveKey(dic, @"lotNo");
    model.lotName           = KISDictionaryHaveKey(dic, @"lotName");
    model.lotMulti          = KISDictionaryHaveKey(dic, @"lotMulti");
    model.batchCode         = KISDictionaryHaveKey(dic, @"batchCode");
    if ([CommonRecordStatus lotNoISJC:KISDictionaryHaveKey(dic, @"lotNo")]) {//竞彩 北单
         model.betCodeHtml  = [self buildJCBetCodeHtml:KISDictionaryHaveKey(dic, @"betCodeJson")];
    }
    else
        model.betCodeHtml       = KISDictionaryHaveKey(dic, @"betCodeHtml");
    model.betCodeJson       = KISDictionaryHaveKey(dic, @"betCodeJson");
    model.display           = KISDictionaryHaveKey(dic, @"display");
    model.visibility        = KISDictionaryHaveKey(dic, @"visibility");
    model.totalAmt          = KISDictionaryHaveKey(dic, @"totalAmt");
    model.safeAmt           = KISDictionaryHaveKey(dic, @"safeAmt");
    model.hasBuyAmt         = KISDictionaryHaveKey(dic, @"hasBuyAmt");
    model.remainderAmt      = [dic objectForKey:@"remainderAmt"];// KISDictionaryHaveKey(dic, @"remainderAmt");
    model.minAmt            = KISDictionaryHaveKey(dic, @"minAmt");
    model.buyAmtByStarter   = KISDictionaryHaveKey(dic, @"buyAmtByStarter");
    model.commisionRatio    = KISDictionaryHaveKey(dic, @"commisionRatio");
    model.participantCount  = KISDictionaryHaveKey(dic, @"participantCount");
    model.buyProgress       = [dic objectForKey:@"buyProgress"];// KISDictionaryHaveKey(dic, @"buyProgress");
    model.safeProgress      = KISDictionaryHaveKey(dic, @"safeProgress");
    model.description       = KISDictionaryHaveKey(dic, @"description");
    model.displayState      = KISDictionaryHaveKey(dic, @"displayState");
    model.winCode           = KISDictionaryHaveKey(dic, @"winCode");
    model.endTime           = KISDictionaryHaveKey(dic, @"endTime");
    model.cancelCaselot     = KISDictionaryHaveKey(dic, @"cancelCaselot");
    model.canAutoJoin       = KISDictionaryHaveKey(dic, @"canAutoJoin");
    [detailBgView togetherDetailDataModel:model];
    [self.view addSubview:detailBgView];
    [model release];
}

- (NSString*)buildJCBetCodeHtml:(NSDictionary*)betResultDic
{
    NSString* tempString = @"";
    if (![@"true" isEqualToString:[betResultDic objectForKey:@"display"]])
    {
        if ([@"1" isEqualToString:[betResultDic objectForKey:@"visibility"]]) {
            tempString = @"保密";
        }
        else if ([@"2" isEqualToString:[betResultDic objectForKey:@"visibility"]]) {
            tempString = @"对所有人截止后公开";
        }
        else if ([@"3" isEqualToString:[betResultDic objectForKey:@"visibility"]]) {
            tempString = @"对跟单者立即公开";
        }
        else if ([@"4" isEqualToString:[betResultDic objectForKey:@"visibility"]]) {
            tempString = @"对跟单者截止后公开";
        }
        else
        {
            tempString = @"暂无";
        }

        return tempString;
    }
    NSArray* betResultArray = [betResultDic objectForKey:@"result"];
    for (int i = 0; i < [betResultArray count]; i++) {
        NSDictionary* tempDic = [betResultArray objectAtIndex:i];
        if (i == 0) {
            tempString = [tempString stringByAppendingFormat:@"玩法：%@<br/>",KISDictionaryHaveKey(tempDic, @"play")];
        }
        tempString = [tempString stringByAppendingFormat:@"%@ ",KISDictionaryHaveKey(tempDic, @"teamId")];
        tempString = [tempString stringByAppendingFormat:@"%@ VS %@<br/>",KISDictionaryHaveKey(tempDic, @"homeTeam"), KISDictionaryHaveKey(tempDic, @"guestTeam")];
        
        NSString* betString = [KISDictionaryHaveKey(tempDic, @"betContentHtml") stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "];
        tempString = [tempString stringByAppendingFormat:@"您的投注：%@ <br/>",betString];
        
        if ([KISDictionaryHaveKey(tempDic, @"homeScore") length] > 0) {
            tempString = [tempString stringByAppendingFormat:@"全场比分：%@ : %@<br/>",KISDictionaryHaveKey(tempDic, @"homeScore"), KISDictionaryHaveKey(tempDic, @"guestScore")];
        }
        else
            tempString = [tempString stringByAppendingString:@"全场比分：未开<br/>"];

        tempString = [tempString stringByAppendingFormat:@"赛果：%@ <br/>",[KISDictionaryHaveKey(tempDic, @"matchResult") length] > 0 ? KISDictionaryHaveKey(tempDic, @"matchResult") : @"未开"];
        
        tempString = [tempString stringByAppendingString:@"<br/>"];
    }
    return tempString;
}
#pragma mark --------- detail delegate
-(void)queryTogetherDeTailDisappear:(UIView *)view
{
    [view removeFromSuperview];
}
#pragma mark -------- together methods
/* 返回按钮 */
- (void)queryTogetherBackButtonClick:(id)sender
{
    [detailBgView removeFromSuperview];
    [self.delegate queryTogetherViewDisappear:self];
}
- (void)queryAutoJoinDetailCloseButton:(id)sender
{
    
}
/* 发起合买 or 跟单 */
- (void)queryTogetherLaunchOrDocumentary:(id)sender
{
    UIButton * button = (UIButton *)sender;
    UIButton * lauBtn = (UIButton *)[self.view viewWithTag:TagTogetherButton100];
    UIButton * docBtn = (UIButton *)[self.view viewWithTag:TagTogetherButton100+1];
    curPageIndex =0;
    if (button.tag == TagTogetherButton100) {
        lauBtn.selected = YES;
        docBtn.selected = NO;
        [self queryTogetherRequestWithPage:curPageIndex];
        togeTypeString = @"1";
    }else{
        lauBtn.selected = NO;
        docBtn.selected = YES;
        [self sendQueryRequestAutoJoinWithPage:curPageIndex];
        togeTypeString = @"2";
    }
}
#pragma mark ------ together tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.queryTogeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell = @"celled";
    static NSString * docDequeCell = @"docCelled";
    if ([togeTypeString isEqualToString:@"1"]) {
         QueryTogetherTableViewCell * cell =(QueryTogetherTableViewCell*)[tableView dequeueReusableCellWithIdentifier:dequeCell];
        if (cell == nil) {
            cell =[[[QueryTogetherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
        }
        cell.togeModel = [self.queryTogeArray objectAtIndex:indexPath.row];
        [cell queryTogetherCellRefresh];
        return cell;

    }else
    {
     TogetherDocumentaryTableCell*   cell =(TogetherDocumentaryTableCell*)[tableView dequeueReusableCellWithIdentifier:docDequeCell];
        if (cell == nil) {
            cell =[[[TogetherDocumentaryTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:docDequeCell]autorelease];
        }
        cell.docModel =[self.queryTogeArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        [cell refreshTogetherDocumentaryCell];
        return cell;
    }

    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([togeTypeString isEqualToString:@"1"]) {
        QueryTogetherCellModel *model =[self.queryTogeArray objectAtIndex:indexPath.row];
        [self queryTogetherDetailRequsetCaseId:model.caseLotId];
    }
   
}
#pragma mark ------------------- togetherDocumentaryCellDelegate
- (void)queryTogetherDocTabelCellShowDetail:(QueryTogetherDocumentaryModel *)model
{
    
}
- (void)queryTOgetherTabelCellChangeState:(QueryTogetherDocumentaryModel *)model
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self queryTogetherRequestWithPage:curPageIndex];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}
@end
