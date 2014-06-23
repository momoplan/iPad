//
//  LotteryInformationViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "LotteryInformationViewController.h"

@interface LotteryInformationViewController ()

@end

@implementation LotteryInformationViewController
@synthesize delegate;
@synthesize newsTitleAry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark =================== viewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setInfoTitleView];
    [self setInfoHeaderView];
    [self setInfoDetailView];//详情
    typeString = @"1";
    [self requestNewsInfoWithPage:1];
}
- (void)dealloc
{
    [newsTitleAry release],newsTitleAry = nil;
    
    [contentView release];
    [titleTableView release];
    
    [super dealloc];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ===================== view
/* 标题 */
- (void)setInfoTitleView
{
    [super tabBarBackgroundImageViewWith:self.view];
    [self.view addSubview:getTopLableWithTitle(@"彩票资讯")];

}
/*  顶部 */
#define TAG_HEAD_BUTTON 100
- (void)setInfoHeaderView
{
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 68, 908, 77)];
    headView.backgroundColor        = [UIColor colorWithPatternImage:RYCImageNamed(@"total_detail_top_bg.png")];
    [self.view addSubview:headView];
    [headView release];
    
    //返回按钮
    UIButton * DLTBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    DLTBackBtn.frame = CGRectMake(0, 0, 75, 76);
    [DLTBackBtn setImage:RYCImageNamed(@"viewback.png") forState:UIControlStateNormal];
    [DLTBackBtn addTarget:self action:@selector(infoPickViewBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:DLTBackBtn];

    NSArray *itemAry = @[@"彩民趣闻",@"专家分析",@"足彩天地",@"如意公告"];
    for (int i=0 ; i<itemAry.count; i++) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[itemAry objectAtIndex:i] forState:btnNormal];
        [btn setTitleColor:[UIColor blackColor] forState:btnNormal];
        [btn setBackgroundImage:RYCImageNamed(@"draw_cell_tab_btn.png") forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
        }
        btn.tag     = TAG_HEAD_BUTTON + i;
        [btn addTarget:self action:@selector(infoHeadButtonAction:) forControlEvents:btnTouch];
        [btn setFrame:CGRectMake(100+(132*i), 20, 132, 57)];
        [headView addSubview:btn];
    }
}
/* 详情 */
#define TAG_CONTENT_LABEL 199
#define TAG_CONTENT_TEXTVIEW 198
- (void)setInfoDetailView
{
    self.newsTitleAry = [[NSMutableArray alloc]init];
    
    titleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 145, 350, 573) style:UITableViewStylePlain];
    titleTableView.delegate = self;
    titleTableView.dataSource = self;
    [self.view addSubview:titleTableView];
    
    contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(titleTableView.frame.size.width, titleTableView.frame.origin.y, 558, titleTableView.frame.size.height);
    contentView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:contentView];
    
    UILabel * titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 10,558, 30)];
    titleLabel.tag = TAG_CONTENT_LABEL;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGBCOLOR(150, 100, 70);
    [contentView addSubview:titleLabel];
    [titleLabel release];
    
    UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(30, 40, contentView.frame.size.width-60, 2)];
    lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [contentView addSubview:lineView];
    [lineView release];
    
    UITextView * contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 45, titleLabel.frame.size.width-20, 520)];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.tag = TAG_CONTENT_TEXTVIEW;
    contentTextView.editable = NO;
    contentTextView.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:contentTextView];
    [contentTextView release];

}
#pragma mark ================== methods
/*  返回*/
- (void)infoPickViewBackButtonAction:(id)sender
{
    [self.delegate lotteryInfoViewDisappear:self];
}
/* 资讯分类 */
- (void)infoHeadButtonAction:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [self refreshButtonImg:btn.tag];
    typeString = [NSString stringWithFormat:@"%d", btn.tag - TAG_HEAD_BUTTON + 1];

    [self  requestNewsInfoWithPage:1];
}
- (void)refreshButtonImg:(int)buttpnTag
{
    for (int i = 0; i < 4; i++) {
        UIButton* tempButton = (UIButton*)[self.view viewWithTag:TAG_HEAD_BUTTON + i];
        if (buttpnTag == tempButton.tag) {
            tempButton.selected = YES;
        }
        else
            tempButton.selected = NO;
    }
}
#pragma mark =============== tableView  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.newsTitleAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell = @"celled";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];


//        UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
//        imageView.image =[UIImage imageNamed:@"queryWinCellClick.png"];
//        cell.selectedBackgroundView = imageView;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
//    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [tableView selectRowAtIndexPath:firstPath animated:NO scrollPosition:UITableViewScrollPositionTop];//默认选中一行
    
    NSDictionary *dic = [self.newsTitleAry objectAtIndex:indexPath.row];
    cell.textLabel.text = KISDictionaryHaveKey(dic, @"title");
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.newsTitleAry objectAtIndex:indexPath.row];
    [self requestNewsContentWithId:KISDictionaryHaveKey(dic, @"newsId")];
}
#pragma mark ===============  notification methods
- (void)requestNewsInfoWithPage:(int )curPage
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"information" forKey:@"command"];
    [mDic setObject:@"title" forKey:@"newsType"];
    [mDic setObject:typeString forKey:@"type"];
    [mDic setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"pageindex"];
    [mDic setObject:@"17" forKey:@"maxresult"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager]netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeGetInformation showProgress:YES];
}
- (void)requestNewsContentWithId:(NSString *)newID
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"information" forKey:@"command"];
    [mDic setObject:@"content" forKey:@"newsType"];
    [mDic setObject:newID forKey:@"newsId"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeGetInformationContent showProgress:YES];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    DLog(@"新闻 查询-------- %@",dataDic);

    switch (requestTag) {
        case ASINetworkRequestTypeGetInformation://
        {
            [self newInfomationRequestTidy:dataDic];
        }
            break;
        case ASINetworkRequestTypeGetInformationContent:
        {
            [self newContentRequestTidy:dataDic];
        }
            break;
        default:
            break;
    }
}
- (void)newInfomationRequestTidy:(NSDictionary *)mDic
{
    NSArray * array = KISDictionaryHaveKey(mDic, @"news");
//    if (1 == curPageIndex) {
        [self.newsTitleAry removeAllObjects];
//    }
    [self.newsTitleAry addObjectsFromArray:array];
    [titleTableView reloadData];
    
    NSDictionary * dic = [self.newsTitleAry objectAtIndex:0];
    [self requestNewsContentWithId:KISDictionaryHaveKey(dic, @"newsId")];
}
- (void)newContentRequestTidy:(NSDictionary *)contDic
{
    UILabel * label = (UILabel *)[self.view viewWithTag:TAG_CONTENT_LABEL];
    label.text = KISDictionaryHaveKey(contDic, @"title");
    UITextView * textView = (UITextView *)[self.view viewWithTag:TAG_CONTENT_TEXTVIEW];
    textView.text = KISDictionaryHaveKey(contDic, @"content");

}

@end
