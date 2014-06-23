//
//  BuyLotteryNumberViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-10-18.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "BuyLotteryNumberViewController.h"

@interface BuyLotteryNumberViewController ()

@end

@implementation BuyLotteryNumberViewController
@synthesize numLotNo;
@synthesize lotteryArray;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];

    [self LotteryRequestQueryLotPage:1];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
}
- (void)dealloc
{
    [numLotNo release],numLotNo = nil;
    [lotNumTableView    release];
    [refreshView        release];
    [lotteryArray release],numLotNo = nil;
    [super dealloc];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor clearColor];
    UIImageView * bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 467, 735)];
    bgImage.image = RYCImageNamed(@"detailView_bg.png");
    [self.view addSubview:bgImage];
    [bgImage release];
    
    self.lotteryArray = [[NSMutableArray alloc]init];
    
    UIButton * backBtn          = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame               = CGRectMake(20, 10, 60, 40);
    [backBtn setTitle:@"返回" forState:btnNormal];
    [backBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:btnNormal];
//    [backBtn setBackgroundImage:RYCImageNamed(@"detail_back_nor.png") forState:btnNormal];
//    [backBtn setBackgroundImage:RYCImageNamed(@"detail_back_click.png") forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [backBtn addTarget:self action:@selector(viewBack:) forControlEvents:btnTouch];
    [self.view addSubview:backBtn];
    
    
    UILabel *titleLabel         = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 100, 40)];
    titleLabel.font             = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.text             = @"开奖号码";
    titleLabel.textColor        = RGBCOLOR(255, 255, 255);
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    totalPageCount              = 0;
    curPageIndex                = 1;
    startY                      = 0;
    centerY                     = 0;
    
    lotNumTableView             = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, 457, 665) style:UITableViewStylePlain];
    lotNumTableView.delegate    = self;
    lotNumTableView.dataSource  = self;
    [lotNumTableView setRowHeight:90];
    [self.view addSubview:lotNumTableView];
    
    refreshView                 = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 695, 450, REFRESH_HEADER_HEIGHT)];
    [lotNumTableView addSubview:refreshView];
    refreshView.myScrollView    = lotNumTableView;
    [refreshView stopLoading:NO];
    [refreshView setRefreshViewFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---------- RYCNetManager delegate
- (void)LotteryRequestQueryLotPage:(int)pageIndex
{
    curPageIndex = pageIndex;
    NSMutableDictionary *mDict =[[[NSMutableDictionary alloc]init]autorelease];
    [mDict setObject:numLotNo      forKey:@"lotno"];
	[mDict setObject:@"winInfoList" forKey:@"type"];
    [mDict setObject:@"QueryLot"    forKey:@"command"];
    [mDict setObject:[NSString stringWithFormat:@"%d",pageIndex]
                                    forKey:@"pageindex"];
    [mDict setObject:@"10"          forKey:@"maxresult"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeGetLotteryInfoList showProgress:YES];
    
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    DLog(@"得到数据 -------- %@",dataDic);
    switch (requestTag) {
        case ASINetworkRequestTypeGetLotteryInfoList:
        {
            [self lotteryNumberTableViewDataFromDic:dataDic];
        }
            break;
                   default:
            break;
    }
}
- (void)lotteryNumberTableViewDataFromDic:(NSDictionary *)dateDic
{
    NSString * errorCode = KISDictionaryHaveKey(dateDic, @"error_code");
    if ([errorCode isEqualToString:@"0000"]) { //数据获取成功        
        NSArray *result =KISDictionaryHaveKey(dateDic, @"result");
        totalPageCount = [KISDictionaryHaveKey(dateDic, @"totalPage") intValue];
        [lotteryArray addObjectsFromArray:result];
        [lotNumTableView reloadData];
        
        
//        lotNumTableView.contentSize = CGSizeMake(320, 90 * curPageSize + startY);
        
        startY = lotNumTableView.contentSize.height;
        
        centerY = lotNumTableView.contentSize.height - 630;
        NSLog(@"  lotNumTableView.contentSize.height %f 00000000centerY %f",lotNumTableView.contentSize.height,centerY);
        curPageIndex++;
        
        if(curPageIndex == totalPageCount + 1)
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
#pragma mark --------------------- methods
- (void)viewBack:(id)sender
{
    [self.delegate buyLotteryNumberViewDisappear:self];
}

#pragma mark ------------------------  tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lotteryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell =@"celled";
    BuyLotteryTableCell * cell =(BuyLotteryTableCell*)[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell = [[[BuyLotteryTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (lotteryArray.count !=0) {
        cell.cellDataDic = [lotteryArray objectAtIndex:indexPath.row];
        cell.cellLotNo  = numLotNo;
        [cell lotteryCellBallRefresh];
    }
   
    return cell;
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
    if(curPageIndex <= totalPageCount)
    {
        [self LotteryRequestQueryLotPage:curPageIndex];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}
@end
