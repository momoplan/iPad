//
//  ActivityCenterViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-3.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "ActivityCenterViewController.h"

@interface ActivityCenterViewController ()

@end

@implementation ActivityCenterViewController
@synthesize delegate;
@synthesize acTitleArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark =============== viewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setActivityTitleView];
    [self setActivityTableContentView];
    [self requestActivityTitleInfoWithPageIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
//    [acTitleArray release],acTitleArray = nil;
    [acTableView release];
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
#pragma mark ================= view

- (void)setActivityTitleView
{
    [super tabBarBackgroundImageViewWith:self.view];

   [self.view addSubview:getTopLableWithTitle(@"活动中心")];
    
    UIButton * fundBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    fundBackBtn.frame =CGRectMake(10, 1, 75, 75);
    [fundBackBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [fundBackBtn addTarget:self action:@selector(activityBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fundBackBtn];

}
#define TAG_CONTENT_LABEL 201
#define TAG_CONTENT_TEXTVIEW  202
- (void)setActivityTableContentView
{
    self.acTitleArray                   = [[NSMutableArray alloc]init];
    acTableView                         = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, 350, 647) style:UITableViewStylePlain];
    acTableView.delegate                = self;
    acTableView.dataSource              = self;
    [self.view addSubview:acTableView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 1;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 720, 382, REFRESH_HEADER_HEIGHT)];
    [acTableView addSubview:refreshView];
    refreshView.myScrollView            = acTableView;
    [refreshView stopLoading:NO];
    
    
    UIView *acContentView               = [[UIView alloc]initWithFrame:CGRectMake(acTableView.frame.size.width, acTableView.frame.origin.y, 908-acTableView.frame.size.width, acTableView.frame.size.height-3)];
    acContentView.backgroundColor       = RGBCOLOR(244, 244, 244);
    [self.view addSubview:acContentView];
    [acContentView release];
    
    UILabel * contentTitleLabel         = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, acContentView.frame.size.width, 40)];
    contentTitleLabel.backgroundColor   = [UIColor clearColor];
    contentTitleLabel.textColor         = [UIColor redColor];
    contentTitleLabel.tag               = TAG_CONTENT_LABEL;
    contentTitleLabel.font              = [UIFont boldSystemFontOfSize:20];
    contentTitleLabel.textAlignment     = NSTextAlignmentCenter;
    [acContentView addSubview:contentTitleLabel];
    [contentTitleLabel release];
    
    UIImageView * backbg                = [[UIImageView alloc]initWithFrame:CGRectMake(30, contentTitleLabel.frame.size.height, contentTitleLabel.frame.size.width-60, 2)];
    backbg.backgroundColor              = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [acContentView addSubview:backbg];
    [backbg release];
    
    UITextView * contentTextView        = [[UITextView alloc]initWithFrame:CGRectMake(10, 45, acContentView.frame.size.width-20, 615)];
    contentTextView.backgroundColor     = [UIColor clearColor];
    contentTextView.tag                 = TAG_CONTENT_TEXTVIEW;
    contentTextView.font                = [UIFont systemFontOfSize:17];
    contentTextView.editable            = NO;
    [acContentView addSubview:contentTextView];
    [contentTextView release];
}
#pragma mark ================= methods
- (void)activityBackButtonAction:(id)sender
{
    [self.delegate activityCenterViewDisappear:self];
}
#pragma mark =================  tableView deleagte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.acTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dequeCell = @"celled";
    MoreActivityTableViewCell * cell =(MoreActivityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell = [[[MoreActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dequeCell]autorelease];
        
//        UIView * selecetView = [[UIView alloc]init];
//        selecetView.backgroundColor = RGBCOLOR(237, 239, 214);
//        cell.selectedBackgroundView = selecetView;
//        [selecetView release];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [tableView selectRowAtIndexPath:firstPath animated:NO scrollPosition:UITableViewScrollPositionTop];//默认选中一行
    
    cell.tModel = [self.acTitleArray objectAtIndex:indexPath.row];
    [cell activityTitleCellRefresh];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreActivityTitleModel * model =[self.acTitleArray objectAtIndex:indexPath.row];
    [self requestActivityContentInfoWithID:model.activityId];
}
#pragma mark ================= notification menthod
- (void)netSuccessWithResult:(NSDictionary*)parserDict tag:(NSInteger)requestTag
{
    DLog(@"活动中心-------- %@",parserDict);
    switch (requestTag) {
        case ASINetworkReqestTypeGetActivityTitle://
        {
            [self activityTitleInfoDataTidy:parserDict];
        }
            break;
        case ASINetworkReqestTypeGetActivityContent:
        {
            [self activityContentInfoDataTidy:parserDict];
        }
            break;
        default:
            break;
    }
}

- (void)requestActivityTitleInfoWithPageIndex:(int )pageIndex
{
    NSMutableDictionary *mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"information"      forKey:@"command"];
    [mDic setObject:@"activityTitle"    forKey:@"newsType"];
    [mDic setObject:[NSString stringWithFormat:@"%d",pageIndex]forKey:@"pageindex"];
    [mDic setObject:@"7"                forKey:@"maxresult"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;

    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkReqestTypeGetActivityTitle showProgress:YES];
}
- (void)requestActivityContentInfoWithID:(NSString *)ID
{
    NSMutableDictionary *mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"information"      forKey:@"command"];
    [mDic setObject:@"activityContent"  forKey:@"newsType"];
    [mDic setObject:ID                  forKey:@"activityId"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkReqestTypeGetActivityContent showProgress:YES];
}
- (void)activityTitleInfoDataTidy:(NSDictionary *)dataDic
{
    NSMutableArray * array  = [[NSMutableArray alloc]init];
    NSArray * result        = KISDictionaryHaveKey(dataDic, @"result");
    for (int i=0; i<result.count; i++) {
        NSDictionary  *dic  = [result objectAtIndex:i];
        MoreActivityTitleModel *model =[[MoreActivityTitleModel alloc]init];
        model.activityId    = KISDictionaryHaveKey(dic, @"activityId");
        model.title         = KISDictionaryHaveKey(dic, @"title");
        model.introduce     = KISDictionaryHaveKey(dic, @"introduce");
        model.activityTime  = KISDictionaryHaveKey(dic, @"activityTime");
        model.isEnd         = KISDictionaryHaveKey(dic, @"isEnd");
        [array addObject:model];
        [model release];
    }
    [self.acTitleArray addObjectsFromArray:array];
    [array release];
    [acTableView reloadData];
    
    totalPageCount              = [KISDictionaryHaveKey(dataDic, @"totalPage") intValue];
    startY                      = acTableView.contentSize.height;
    
    centerY                     = acTableView.contentSize.height - 700;
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

    if (self.acTitleArray.count !=0) {
        MoreActivityTitleModel * model = [self.acTitleArray objectAtIndex:0];
        [self requestActivityContentInfoWithID:model.activityId];
    }
  
}

- (void)activityContentInfoDataTidy:(NSDictionary *)dataDic
{
    UILabel *label = (UILabel *)[self.view viewWithTag:TAG_CONTENT_LABEL];
    label.text = KISDictionaryHaveKey(dataDic, @"title");
    
    UITextView * textView =(UITextView *)[self.view viewWithTag:TAG_CONTENT_TEXTVIEW];
    textView.text = KISDictionaryHaveKey(dataDic, @"content");
}

#pragma mark   ------------------------- scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(curPageIndex == 1)
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
        [self requestActivityTitleInfoWithPageIndex:curPageIndex];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

@end
