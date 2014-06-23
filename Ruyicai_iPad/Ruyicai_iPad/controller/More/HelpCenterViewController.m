//
//  HelpCenterViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-2.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "HelpCenterViewController.h"

@interface HelpCenterViewController ()

@end

@implementation HelpCenterViewController
@synthesize delegate;
@synthesize titleArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark ============= viewcontroller

- (void)dealloc
{
    [titleArray release],titleArray = nil;
    [leftTabelView release];
    [refreshView release];
    
    [super dealloc];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self setHelpTitleView];
    [self setHelpHeadView];
    [self setHelpContentView];
    typeString  = @"1";
    [self requestHelpInfoWithPageIndex:1];
}
#pragma mark ============== view
/*  标题 */
- (void)setHelpTitleView
{
    [super tabBarBackgroundImageViewWith:self.view];
    [self.view addSubview:getTopLableWithTitle(@"帮助中心")];
}
/*  顶部 */
#define TAG_HEAD_BUTTON 100
- (void)setHelpHeadView
{
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 68, 908, 77)];
    headView.backgroundColor  = [UIColor colorWithPatternImage:RYCImageNamed(@"total_detail_top_bg.png")];
    [self.view addSubview:headView];
    [headView release];
    
    //返回按钮
    UIButton * DLTBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    DLTBackBtn.frame = CGRectMake(0, 0, 75, 77);
    [DLTBackBtn setImage:RYCImageNamed(@"viewback") forState:UIControlStateNormal];
    [DLTBackBtn addTarget:self action:@selector(helpPickViewBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:DLTBackBtn];
    
    NSArray *itemAry = @[@"功能指引",@"特色功能",@"彩票玩法",@"常见问题",@"彩票术语"];
    for (int i=0 ; i<itemAry.count; i++) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[itemAry objectAtIndex:i ] forState:btnNormal];
        [btn setTitleColor:[UIColor blackColor] forState:btnNormal];
        btn.tag     = TAG_HEAD_BUTTON+i;
        [btn setBackgroundImage:RYCImageNamed(@"draw_cell_tab_btn.png") forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
        }

        [btn addTarget:self action:@selector(helpHeadButtonAction:) forControlEvents:btnTouch];
        [btn setFrame:CGRectMake(100+(132*i), 20, 132, 57)];
        [headView addSubview:btn];
        
    }
    
}
#define TAG_CONTENT_LABEL 199
#define TAG_CONTENT_TEXTVIEW 198
- (void)setHelpContentView
{
 
    self.titleArray             = [[NSMutableArray alloc]init];
    leftTabelView               =[[UITableView alloc]initWithFrame:CGRectMake(0, 145, 350, 650 - 85) style:UITableViewStylePlain];
    leftTabelView.delegate      = self;
    leftTabelView.dataSource    = self;
    leftTabelView.rowHeight = 45;
    [self.view addSubview:leftTabelView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 1;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 720, 382, REFRESH_HEADER_HEIGHT)];
    [leftTabelView addSubview:refreshView];
    refreshView.myScrollView            = leftTabelView;
    [refreshView stopLoading:NO];

    
    UIView *contView = [[UIView alloc]initWithFrame:CGRectMake(leftTabelView.frame.size.width, leftTabelView.frame.origin.y, 908-leftTabelView.frame.size.width, leftTabelView.frame.size.height)];
    contView.backgroundColor  = RGBCOLOR(244, 244, 244);
    [self.view addSubview:contView];
    [contView release];
    
    
    UILabel * titleLabel        = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 908-leftTabelView.frame.size.width, 30)];
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.textColor        = RGBCOLOR(150, 100, 75);
    titleLabel.backgroundColor  = RGBCOLOR(244, 244, 244);
    titleLabel.font             = [UIFont boldSystemFontOfSize:20];
    titleLabel.tag              = TAG_CONTENT_LABEL;
    [contView addSubview:titleLabel];
    [titleLabel release];
    
    UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 40, contView.frame.size.width, 2)];
    lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [contView addSubview:lineView];
    [lineView release];
    
    UITextView * contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height + 2, titleLabel.frame.size.width, leftTabelView.frame.size.height - 35)];
    contentTextView.font        = [UIFont systemFontOfSize:17];
    contentTextView.tag         = TAG_CONTENT_TEXTVIEW;
    contentTextView.editable    = YES;
    contentTextView.backgroundColor = RGBCOLOR(244, 244, 244);
    contentTextView.editable = NO;
    [contView addSubview:contentTextView];
    [contentTextView release];
}

#pragma mark ============== methods
/* 返回 */
- (void)helpPickViewBackButtonAction:(id)sender
{
    [self.delegate  helpCenterViewDisappear:self];
    
}
/*  种类切换 */
- (void)helpHeadButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    [self refreshButtonImg:button.tag];
    
    typeString = [NSString stringWithFormat:@"%d", button.tag - TAG_HEAD_BUTTON + 1];
    curPageIndex =1;
    [self  requestHelpInfoWithPageIndex:curPageIndex];

}
- (void)refreshButtonImg:(int)buttpnTag
{
    for (int i = 0; i < 5; i++) {
        UIButton* tempButton = (UIButton*)[self.view viewWithTag:TAG_HEAD_BUTTON + i];
        if (buttpnTag == tempButton.tag) {
            tempButton.selected = YES;
        }
        else
            tempButton.selected = NO;
    }
}
#pragma mark ===================  tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell = @"celled";
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dequeCell]autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

//    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [tableView selectRowAtIndexPath:firstPath animated:NO scrollPosition:UITableViewScrollPositionTop];//默认选中一行
    
    NSDictionary * dic      = [self.titleArray objectAtIndex:indexPath.row];
    cell.textLabel.text     = KISDictionaryHaveKey(dic, @"title");
    cell.textLabel.font     = [UIFont systemFontOfSize:18];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dic =[self.titleArray objectAtIndex:indexPath.row];
    [self requestHelpContentWithId:KISDictionaryHaveKey(dic, @"id")];
}
#pragma mark ===============  notification methods
//type 1：功能指引；2：特色功能；3：彩票玩法；4：常见问题；5：彩票术语
- (void)requestHelpInfoWithPageIndex:( int )pageIndex
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"information" forKey:@"command"];
    [mDic setObject:@"helpCenterTitle" forKey:@"newsType"];
    [mDic setObject:typeString forKey:@"type"];
    [mDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];
    [mDic setObject:@"17" forKey:@"maxresult"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager]netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeHelpInformation showProgress:YES];
}
- (void)requestHelpContentWithId:(NSString *)newID
{
     NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"information" forKey:@"command"];
    [mDic setObject:@"helpCenterContent" forKey:@"newsType"];
    [mDic setObject:newID forKey:@"id"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeHelpContent showProgress:YES];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    DLog(@"帮助中心-------- %@",dataDic);
    switch (requestTag) {
        case ASINetworkRequestTypeHelpInformation://
        {
            [self helpInfomationRequestTidy:dataDic];
        }
            break;
        case ASINetworkRequestTypeHelpContent:
        {
            [self helpContentRequestTidy:dataDic];
        }
            break;
        default:
            break;
    }
}
- (void)helpInfomationRequestTidy:(NSDictionary *)mDic
{
    NSArray *array =KISDictionaryHaveKey(mDic, @"result");
    if (curPageIndex == 1) {
        [self.titleArray removeAllObjects];
    }
    [self.titleArray addObjectsFromArray:array];
    [leftTabelView reloadData];
    
    
    totalPageCount              = [KISDictionaryHaveKey(mDic, @"totalPage") intValue];
    startY                      = leftTabelView.contentSize.height;
    centerY                     = leftTabelView.contentSize.height- 16*35;
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

    
    if (self.titleArray.count !=0) {
        NSDictionary * dic =[self.titleArray objectAtIndex:0];
        [self requestHelpContentWithId:KISDictionaryHaveKey(dic, @"id")];
        
    }
}
- (void)helpContentRequestTidy:(NSDictionary *)mDic
{
    UILabel * label = (UILabel *)[self.view viewWithTag:TAG_CONTENT_LABEL];
    label.text = KISDictionaryHaveKey(mDic, @"title");
    UITextView * textView = (UITextView *)[self.view viewWithTag:TAG_CONTENT_TEXTVIEW];
    textView.text = KISDictionaryHaveKey(mDic, @"content");
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
        [self requestHelpInfoWithPageIndex:curPageIndex];
    }
    else
    {
        [refreshView stopLoading:YES];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}


@end

