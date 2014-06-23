//
//  TotalBuyViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "TotalBuyViewController.h"

@interface TotalBuyViewController ()

@end

@implementation TotalBuyViewController
@synthesize totalDataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc{
    [totalTableView release];
    [totalDataArray release],totalDataArray = nil;
    
    [orderString release];
    [refreshView release];
    [super dealloc];

}
#pragma mark ------------ controller  methods
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
//    self.view.backgroundColor = RGBCOLOR(244, 155, 155);
	// Do any additional setup after loading the view.
    [self.view addSubview:getTopLableWithTitle(@"合买大厅")];
    
    UIView * topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 68, 908, 42)];
    topBgView.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"total_top_button_bg.png")];
    [self.view addSubview:topBgView];
    [topBgView release];

    /* 排序调整 */
    [self arrangeAdjustView];
    
    self.totalDataArray         = [[NSMutableArray alloc]init];
    totalTableView              = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, 908, 610)];
    totalTableView.delegate     = self;
    totalTableView.dataSource   = self;
    [self.view                  addSubview:totalTableView];
    
    totalPageCount              = 0;
    curPageIndex                = 0;

    refreshView                 = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 720, 382, REFRESH_HEADER_HEIGHT)];
    [totalTableView addSubview:refreshView];
    refreshView.myScrollView    = totalTableView;
    [refreshView stopLoading:NO];
    [refreshView setRefreshViewFrame];
    
    isProgressOrder             = YES;
    isParticipantCountOrder     = NO;
    isTotalAmtOrder             = NO;
    orderString                 = @"1";
    [self totalBuyViewDataRequesetPage:0];
    [self topButtonStateRefresh];
    /* 方案筛选 */
//    [self projectScreenView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---------------- viewCreate
- (void)arrangeAdjustView
{
#define TAG_ARRANGE_BUTTON 100
        
    NSArray *array = @[@"参与进度",@"人气排序",@"方案总额"];
    for (int i=0; i<array.count; i++) {
        UIButton * scheduleBtn      = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        scheduleBtn.frame           = CGRectMake(0+(198*i), 68, 198, 42);
        [scheduleBtn                setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [scheduleBtn setTitleColor:[UIColor grayColor] forState:btnNormal];
        scheduleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [scheduleBtn setBackgroundImage:RYCImageNamed(@"total_top_button_mid.png") forState:btnNormal];
        [scheduleBtn                addTarget:self action:@selector(totalbuyArrageAdjustButton:) forControlEvents:UIControlEventTouchUpInside];
        scheduleBtn.tag             = TAG_ARRANGE_BUTTON + 1 + i;
        [self.view                  addSubview:scheduleBtn];
    }
        
}
- (void)projectScreenView
{
    UIView * projectView        = [[UIView alloc]initWithFrame:CGRectMake(610, 70, 300, 650)];
    projectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:projectView];
    [projectView release];
    
    UILabel *projectLabel       = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 280, 40)];
    projectLabel.text           = @"方案筛选";
    projectLabel.font           = [UIFont systemFontOfSize:20];
    [projectView addSubview:projectLabel];
    [projectLabel release];
    
    UIButton *kindScreenBtn     = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    kindScreenBtn.frame         = CGRectMake(40, 50, 100, 40);
    [kindScreenBtn              setTitle:@"彩种筛选" forState:UIControlStateNormal];
    [projectView addSubview:kindScreenBtn];
    
    UIButton * moneyScreenBtn   = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moneyScreenBtn.frame        = CGRectMake(160, kindScreenBtn.frame.origin.y, kindScreenBtn.frame.size.width, kindScreenBtn.frame.size.height);
    [moneyScreenBtn             setTitle:@"方案金额" forState:UIControlStateNormal];
    [projectView addSubview:moneyScreenBtn];
    
    UISearchBar *proSearchBar   = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 90, 300, 50)];
    proSearchBar.placeholder    = @"输入昵称、手机、ID 搜索";
    [projectView addSubview:proSearchBar];
    [proSearchBar release];
    
    UILabel *famlabel           = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 300, 30)];
    famlabel.backgroundColor    = [UIColor clearColor];
    famlabel.text = @"合买名人:";
    [projectView addSubview:famlabel];
    [famlabel release];
    
    UITextView * nameTextView           = [[UITextView alloc]initWithFrame:CGRectMake(0, 180, projectLabel.frame.size.width, 150)];
    nameTextView.userInteractionEnabled = NO;
    nameTextView.backgroundColor        = [UIColor clearColor];
    nameTextView.textColor              = [UIColor blueColor];
    nameTextView.text                   = @"城市狼人 城市狼人  ";
    nameTextView.font                   = [UIFont systemFontOfSize:17];
    [projectView addSubview:nameTextView];
    [nameTextView release];
    
}
#pragma mark --------------- view methods
- (void)totalbuyArrageAdjustButton:(id)sender
{
    /* 必填	totalAmt按总额排序，buyAmt按认购金额排序，
     progress按进度排序，participantCount按参与人数排序*/
    UIButton * btn          = (UIButton *)sender;
    switch (btn.tag - TAG_ARRANGE_BUTTON) {
        case 1://参与进度
        {
        
            orderString     = @"1";
            isProgressOrder =!isProgressOrder;
        }
            break;
        case 2://人气排行
        {
            orderString     = @"2";
            isParticipantCountOrder
                            = !isParticipantCountOrder;

        }
            break;
        case 3://方案总额
        {
            orderString     = @"3";
            isTotalAmtOrder = !isTotalAmtOrder;

        }
            break;
        default:
            break;
    }
    
    [self topButtonStateRefresh];
    curPageIndex            = 0;
    [self totalBuyViewDataRequesetPage:curPageIndex];
}
- (void)topButtonStateRefresh
{
    UIButton * schBtn = (UIButton *)[self.view viewWithTag:TAG_ARRANGE_BUTTON+1];
    UIButton * peobtn = (UIButton *)[self.view viewWithTag:TAG_ARRANGE_BUTTON+2];
    UIButton * totbtn = (UIButton *)[self.view viewWithTag:TAG_ARRANGE_BUTTON+3];
    
    switch ([orderString intValue]) {
        case 1:
        {
            if (!isProgressOrder) {
                 [schBtn setBackgroundImage:RYCImageNamed(@"total_top_button_shang.png") forState:btnNormal];
            }else{
                 [schBtn setBackgroundImage:RYCImageNamed(@"total_top_button_xia.png") forState:btnNormal];
            }
            
            [peobtn setBackgroundImage:RYCImageNamed(@"total_top_button_mid.png") forState:btnNormal];
            [totbtn setBackgroundImage:RYCImageNamed(@"total_top_button_mid.png") forState:btnNormal];
        }
            break;
        case 2:
        {
            if (!isParticipantCountOrder) {
                 [peobtn setBackgroundImage:RYCImageNamed(@"total_top_button_shang.png") forState:btnNormal];
            }else
            {
                 [peobtn setBackgroundImage:RYCImageNamed(@"total_top_button_xia.png") forState:btnNormal];
            }
           
            [schBtn setBackgroundImage:RYCImageNamed(@"total_top_button_mid.png") forState:btnNormal];
            [totbtn setBackgroundImage:RYCImageNamed(@"total_top_button_mid.png") forState:btnNormal];
        }
            break;
        case 3:
        {
            if (!isTotalAmtOrder) {
                [totbtn setBackgroundImage:RYCImageNamed(@"total_top_button_shang.png") forState:btnNormal];
            }else
            {
                [totbtn setBackgroundImage:RYCImageNamed(@"total_top_button_xia.png") forState:btnNormal];
            }
            [peobtn setBackgroundImage:RYCImageNamed(@"total_top_button_mid.png") forState:btnNormal];
            [schBtn setBackgroundImage:RYCImageNamed(@"total_top_button_mid.png") forState:btnNormal];
        }
            break;
        default:
            break;
    }
}
#pragma mark -------------- request methods
/*  合买大厅 返回数据 */
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryAllCaseLot:
        {
            [self totalBuyViewDataTidyDictionary:dataDic];
        }
            break;
        default:
            break;
    }
}
/*  合买大厅 数据请求 */
- (void)totalBuyViewDataRequesetPage:(int) pageIndex
//- (void)totalBuyViewDataRequesetOrderBy:(NSString *)orderBy orderDir:(BOOL )orderDir
{
    NSMutableDictionary * mDic =[[NSMutableDictionary alloc]init];
    [mDic setObject:@"QueryLot" forKey:@"command"];
    [mDic setObject:@"querycaselot" forKey:@"type"];
    //totalAmt按总额排序，buyAmt按认购金额排序，progress按进度排序，participantCount按参与人数排序
    NSString * orderBy  = @"";
    BOOL orderDir       = YES;
    switch ([orderString intValue]) {
        case 1:
        {
            orderBy = @"progress";
            orderDir = isProgressOrder;
        }
            break;
         case 2:
        {
            orderBy = @"participantCount";
            orderDir = isParticipantCountOrder;
        }
            break;
        case 3:
        {
            orderBy = @"totalAmt";
            orderDir = isTotalAmtOrder;
        }
            break;
        default:
            break;
    }
    [mDic setObject:orderBy forKey:@"orderBy"];
    if (orderDir) {
        [mDic setObject:@"DESC" forKey:@"orderDir"];//DESC降序，ASC升序

    }else{
        [mDic setObject:@"ASC" forKey:@"orderDir"];//DESC降序，ASC升序

    }
    [mDic setObject:@"8" forKey:@"maxresult"];
    [mDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"
     ];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeQueryAllCaseLot showProgress:YES];
//    [mDic release];
}
/* 合买大厅 数据 整理 */
- (void)totalBuyViewDataTidyDictionary:(NSDictionary *)mDic
{
    NSString * errorCode        = KISDictionaryHaveKey(mDic, @"error_code");
    if ([errorCode isEqualToString:@"0000"]) { //数据获取成功
        
        NSMutableArray * muArray    = [[NSMutableArray alloc]init];
        NSArray * result            = KISDictionaryHaveKey(mDic, @"result");

        for (int i=0; i<result.count; i++) {
            NSDictionary *dic       = [result objectAtIndex:i];
            TotalBuyViewCellModel *model
                                    = [[TotalBuyViewCellModel alloc]init];
            model.caseLotId         = KISDictionaryHaveKey(dic, @"caseLotId");
            model.lotNo             = KISDictionaryHaveKey(dic, @"lotNo");
            model.lotName           = KISDictionaryHaveKey(dic, @"lotName");
            model.batchCode         = KISDictionaryHaveKey(dic, @"batchCode");
            model.starter           = KISDictionaryHaveKey(dic, @"starter");
            model.starterUserNo     = KISDictionaryHaveKey(dic, @"starterUserNo");
            model.totalAmt          = KISDictionaryHaveKey(dic, @"totalAmt");
            model.safeAmt           = KISDictionaryHaveKey(dic, @"safeAmt");
            model.buyAmt            = KISDictionaryHaveKey(dic, @"buyAmt");
            model.progress          = KISDictionaryHaveKey(dic, @"progress");
            model.safeRate          = KISDictionaryHaveKey(dic, @"safeRate");
            model.displayIcon       = KISDictionaryHaveKey(dic, @"displayIcon");
            model.isTop             = KISDictionaryHaveKey(dic, @"isTop");
            
            NSDictionary *palyIcon  = KISDictionaryHaveKey(dic, @"displayIcon");
            model.goldStar          = KISDictionaryHaveKey(palyIcon, @"goldStar");
            model.graygoldStar      = KISDictionaryHaveKey(palyIcon, @"graygoldStar");
            model.diamond           = KISDictionaryHaveKey(palyIcon, @"diamond");
            model.graydiamond       = KISDictionaryHaveKey(palyIcon, @"graydiamond");
            model.cup               = KISDictionaryHaveKey(palyIcon, @"cup");
            model.graycup           = KISDictionaryHaveKey(palyIcon, @"graycup");
            model.crown             = KISDictionaryHaveKey(palyIcon, @"crown");
            model.graycrown         = KISDictionaryHaveKey(palyIcon, @"graycrown");
            
            [muArray addObject:model];
            [model release];
            
        }
        if (curPageIndex ==0) {
            [self.totalDataArray removeAllObjects];
        }
        [self.totalDataArray addObjectsFromArray:muArray];
        [muArray release];
        [totalTableView reloadData];
        
        totalPageCount              = [KISDictionaryHaveKey(mDic, @"totalPage") intValue];

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
#pragma mark ---------------- tableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalDataArray.count;
    
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * celled = @"celled";
    TotalBuyViewCell  * cell = (TotalBuyViewCell *)[tableView dequeueReusableCellWithIdentifier:celled];
    if(cell == nil){
        cell                = [[[TotalBuyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celled]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (indexPath.row %2 == 0) {
        cell.backgroundView.backgroundColor    = [UIColor whiteColor];
    }else
    {
        cell.backgroundView.backgroundColor    = RGBCOLOR(244, 244, 244);
    }
    cell.model              = [self.totalDataArray objectAtIndex:indexPath.row];
    [cell totalBuyCellRefresh];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailTotalBuyViewController *detailTotal = [[DetailTotalBuyViewController alloc]init];
    detailTotal.delegate        = self;
    detailTotal.cellModel       = [self.totalDataArray objectAtIndex:indexPath.row];
    detailTotal.view.frame      = CGRectMake(0, -1, 910, 720);
    [self.view addSubview:detailTotal.view];
    
    CATransition *transition    = [CATransition animation];
    transition.duration         = .5;
    transition.timingFunction   = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type             = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    transition.subtype          = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
    [detailTotal.view.layer addAnimation:transition forKey:nil];

}

#pragma mark   ------------------------- scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
        [self totalBuyViewDataRequesetPage:curPageIndex];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

#pragma mark ----------- detailTotal
- (void)detailTotalBuyViewDisappear:(DetailTotalBuyViewController *)viewController
{
    [UIView animateWithDuration:0.5 animations:^(void){
        CGPoint point = viewController.view.center;
        point.x += 1000;
        viewController.view.center = point;
    }completion:^(BOOL isFinish){
        if (isFinish) {
            if (viewController.isJoinOK) {
                curPageIndex = 0;
                [self startRefresh:Nil];
            }
            [viewController.view removeFromSuperview];
            [viewController release];
        }
    }];
}
@end
