//
//  QueryPresentViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryPresentViewController.h"

@interface QueryPresentViewController ()

@end

@implementation QueryPresentViewController
@synthesize delegate;
@synthesize queryGiftArray;
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
//    [queryGiftArray release];
//    self.queryGiftArray = nil;
    [presentBackView release];
    [presentTableView release];
    if (cLabel) {
        [cLabel release];
    }
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
   
    
    [self queryPresentTitleView];
    [self queryPresentTableView];//赠送列表
    [self queryPresentDetailCreate];
    
    isGift = @"1";
    [self queryPresentRequestDataWithPage:1];
}

#pragma mark ---------- present View
- (void)queryPresentTitleView
{
   
    [self.view addSubview:getTopLableWithTitle(@"赠彩查询")];
    
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 70, 908, 67)];
    headView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:headView];
    [headView release];
    
    UIButton *queryPresentBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    queryPresentBackBtn.frame = CGRectMake(0, 1, 76, 76);
    [queryPresentBackBtn setImage:[UIImage imageNamed:@"narBack.png"] forState:UIControlStateNormal];
    [queryPresentBackBtn addTarget:self action:@selector(queryPresentBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryPresentBackBtn];
    
#define TagPresentButton101 101
    UIButton *grantBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    grantBtn.frame = CGRectMake(20,10, 132, 57);
    grantBtn.tag =TagPresentButton101;
    [grantBtn setTitle:@"赠出的彩票" forState:UIControlStateNormal];
    [grantBtn addTarget:self action:@selector(queryPresentGrantOrSend:)
       forControlEvents:UIControlEventTouchUpInside];
    [grantBtn setTitleColor:[UIColor blackColor] forState:btnNormal];
    [grantBtn setBackgroundImage:RYCImageNamed(@"draw_cell_tab_btn.png") forState:UIControlStateSelected];
    grantBtn.selected = YES;
    [headView addSubview:grantBtn];
    
    UIButton *sendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(grantBtn.frame.origin.x+grantBtn.frame.size.width, 10, 132, 57);
    sendBtn.tag = TagPresentButton101 +1;
    [sendBtn setTitleColor:[UIColor blackColor] forState:btnNormal];
    [sendBtn setBackgroundImage:RYCImageNamed(@"draw_cell_tab_btn.png") forState:UIControlStateSelected];
    [sendBtn setTitle:@"收到的彩票" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(queryPresentGrantOrSend:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:sendBtn];
    

}
- (void)queryPresentTableView
{
    presentBackView                     = [[UIView alloc]initWithFrame:CGRectMake(0, 137, 908, 582)];
    presentBackView.backgroundColor     = [UIColor whiteColor];
    [self.view addSubview: presentBackView];
    
    self.queryGiftArray                 = [[NSMutableArray alloc]init];
    presentTableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 908, 582) style:UITableViewStylePlain];
    presentTableView.delegate           = self;
    presentTableView.dataSource         = self;
    [presentBackView addSubview:presentTableView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 0;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 710, 600, REFRESH_HEADER_HEIGHT)];
    [presentTableView addSubview:refreshView];
    refreshView.myScrollView            = presentTableView;
    [refreshView stopLoading:NO];

}
- (void)queryPresentDetailCreate
{
    presentDetailView           =[[UIView alloc]initWithFrame:CGRectMake(550, 120, 360, 550)];
    UIImageView *imgView        =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryDetailBg.png"]];
    imgView.frame               = CGRectMake(0, 0, presentDetailView.frame.size.width, presentDetailView.frame.size.height);
    [presentDetailView addSubview:imgView];
    [imgView release];
    
    UIButton *closeBtn          =[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame              = CGRectMake(305, 0, 55, 55);
    [closeBtn setImage:[UIImage imageNamed:@"queryclose.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(queryDetailCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [presentDetailView addSubview:closeBtn]; //125162466
    
    UILabel *preTitLabel        =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, presentDetailView.frame.size.width, 55)];
    preTitLabel.text            = @"赠彩详情";
    preTitLabel.textAlignment   = NSTextAlignmentCenter;
    preTitLabel.backgroundColor =[UIColor clearColor];
    [presentDetailView addSubview:preTitLabel];
    [preTitLabel release];
    
    NSArray * leArray =[[NSArray alloc]initWithObjects:@"彩种:",@"期号:",@"订单号:",@"受赠人:",@"赠彩时间:",@"金额:",@"倍数:",@"注数:",@"出票状态:",@"开奖号码:",@"投注内容:",nil];
   
#define TagDetailLabel200 200
    for (int i=0; i<leArray.count; i++) {
        UILabel *detailLabel            =[[UILabel alloc]initWithFrame:CGRectMake(10, 60+(40*i), 100, 25)];
        detailLabel.text                = [leArray objectAtIndex:i];
        detailLabel.backgroundColor     =[UIColor clearColor];
        detailLabel.textColor           =[UIColor blueColor];
        detailLabel.textAlignment       = NSTextAlignmentCenter;
        [presentDetailView addSubview:detailLabel];
        [detailLabel release];
        
        UILabel *messLabel              =[[UILabel alloc]initWithFrame:CGRectMake(110, detailLabel.frame.origin.y, 200, 25)];
        messLabel.backgroundColor       =[UIColor clearColor];
        messLabel.tag                   = TagDetailLabel200+i;
        [presentDetailView addSubview:messLabel];
        [messLabel release];
    }
    [leArray release];
    
    UITextView *contentTextView         =[[UITextView alloc]initWithFrame:CGRectMake(110, 460, 200, 70)];
    contentTextView.font                = [UIFont systemFontOfSize:17];
    contentTextView.editable            = NO;
    contentTextView.backgroundColor     = [UIColor clearColor];
    contentTextView.tag                 = TagDetailLabel200+99;
    [presentDetailView addSubview:contentTextView];
    [contentTextView release];
}
- (void)queryPresentDetailViewGiftModel:(QueryGiftTableCellModel*)model
{

    NSArray *riArray = @[model.lotName,
                         model.batchCode,
                         model.orderId,
                         [model.gifted isEqualToString:@"1"] ? model.toMobileId : model.giftMobileId,
                         model.orderTime,
                         [NSString stringWithFormat:@"%.2f元",[ model.amount intValue]/100.0],
                         [NSString stringWithFormat:@"%@倍", model.lotMulti],
                         [NSString stringWithFormat:@"%@注",model.betNum],
                         model.stateMemo,
                         model.winCode,@"",];
    for (int i=0; i<riArray.count; i++) {
        UILabel * label = (UILabel *)[presentDetailView viewWithTag:TagDetailLabel200+i];
        label.text =[riArray objectAtIndex:i];
    }
    UITextView  *textView = (UITextView *)[presentDetailView viewWithTag:TagDetailLabel200+99];
    textView.editable    = YES;
    textView.text = model.betCode;
    
    [self.view addSubview:presentDetailView];

    
}
#pragma mark ---------- RYCNetManager delegate
- (void)queryPresentRequestDataWithPage:(int)pageIndex
{
    NSMutableDictionary * mDict =[[NSMutableDictionary alloc]init];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    if([isGift isEqualToString:@"1"])
	{
		[mDict setObject:@"gift" forKey:@"type"];
	}
	else
	{
		[mDict setObject:@"gifted" forKey:@"type"];
	}
	[mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDict setObject:@"9" forKey:@"maxresult"];
    [mDict setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeQueryGift showProgress:YES];
    [mDict release];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryGift://
        {
            [self queryGiftTabelDataDictionary:dataDic];
        }
            break;
        default:
            break;
    }
}
/* 赠送 查询 数据处理 */
- (void)queryGiftTabelDataDictionary:(NSDictionary *)dataDic
{
    NSString * errorCode = KISDictionaryHaveKey(dataDic, @"error_code");
    if ([errorCode isEqualToString:@"0047"]) {//无记录
       cLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 150, 320, 50)];
        cLabel.text = @"无记录";
        cLabel.textAlignment = NSTextAlignmentCenter;
        cLabel.textColor = [UIColor grayColor];
        cLabel.font = [UIFont boldSystemFontOfSize:25];
        cLabel.backgroundColor = [UIColor clearColor];
        [presentBackView addSubview:cLabel];
        [presentTableView removeFromSuperview];
        return;
    }
    if (cLabel) {
        [cLabel removeFromSuperview];
    }
    [presentBackView addSubview:presentTableView];
    NSMutableArray * muArray =[[NSMutableArray alloc]init];
    NSArray * result =KISDictionaryHaveKey(dataDic, @"result");
    for (int i=0; i<result.count; i++) {
        NSDictionary * dic =[result objectAtIndex:i];
        QueryGiftTableCellModel *model =[[QueryGiftTableCellModel alloc]init];
        model.orderId       = KISDictionaryHaveKey(dic, @"orderId");
        model.gifted        = isGift;
        model.toMobileId    = KISDictionaryHaveKey(dic, @"toMobileId");
        model.giftMobileId  = KISDictionaryHaveKey(dic, @"giftMobileId");
        model.orderTime     = KISDictionaryHaveKey(dic, @"orderTime");
        model.amount        = KISDictionaryHaveKey(dic, @"amount");
        model.batchCode     = KISDictionaryHaveKey(dic, @"batchCode");
        model.lotMulti      = KISDictionaryHaveKey(dic, @"lotMulti");
        model.betNum        = KISDictionaryHaveKey(dic, @"betNum");
        model.betCode       = KISDictionaryHaveKey(dic, @"betCode");
        model.lotNo         = KISDictionaryHaveKey(dic, @"lotNo");
        model.lotName       = KISDictionaryHaveKey(dic, @"lotName");
        model.stateMemo     = KISDictionaryHaveKey(dic, @"stateMemo");
        model.prizeState    = KISDictionaryHaveKey(dic, @"prizeState");
        model.winCode       = KISDictionaryHaveKey(dic, @"winCode" );
        [muArray addObject:model];
        [model release];
    }
    if (curPageIndex == 1) {
        [self.queryGiftArray removeAllObjects];
    }
    [self.queryGiftArray addObjectsFromArray:muArray];
    [muArray release];
    [presentTableView reloadData];
    
    totalPageCount              = [KISDictionaryHaveKey(dataDic, @"totalPage") intValue];
    startY                      = presentTableView.contentSize.height;
    
    centerY                     = presentTableView.contentSize.height - 680;
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
#pragma mark -------- present methods
/*  销毁当前viewController */
- (void)queryPresentBackButtonClick:(id)sender
{
    [self.delegate queryPresentViewDisappear:self];
}
/*  赠出的 or 收到的 */
- (void)queryPresentGrantOrSend:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [self queryDetailCloseButton:nil];
    UIButton * gitBtn = (UIButton *)[self.view viewWithTag:TagPresentButton101];
    UIButton * senBtn = (UIButton *)[self.view viewWithTag:TagPresentButton101+1];
    if (TagPresentButton101 == btn.tag ) {//赠出得
        gitBtn.selected = YES;
        senBtn.selected = NO;
        isGift = @"1";
    }else{
        isGift = @"2";
        gitBtn.selected = NO;
        senBtn.selected = YES;
    }
    curPageIndex =1;
    [self queryPresentRequestDataWithPage:curPageIndex];
}
/* 关闭详情view */
- (void)queryDetailCloseButton:(id)sender
{
    [presentDetailView removeFromSuperview];
}
#pragma mark -------- present tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.queryGiftArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dequeCell =@"celled";
    QueryPresentTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell =[[[QueryPresentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
    }
    cell.giftModel = [self.queryGiftArray objectAtIndex:indexPath.row];
    [cell queryPresentCellRefresh];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self queryPresentDetailViewGiftModel:[self.queryGiftArray objectAtIndex:indexPath.row]];
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
        [self queryPresentRequestDataWithPage:curPageIndex];
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
