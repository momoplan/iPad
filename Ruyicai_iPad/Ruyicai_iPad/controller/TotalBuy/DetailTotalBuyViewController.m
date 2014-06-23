//
//  DetailTotalBuyViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-19.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "DetailTotalBuyViewController.h"
#import "CommonRecordStatus.h"

@interface DetailTotalBuyViewController ()

@end

@implementation DetailTotalBuyViewController
@synthesize delegate;
@synthesize togeModel;
@synthesize cellModel;
@synthesize detailPartDataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark ------- controller
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:Nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:Nil];
    
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    detailPartDataArray = [[NSMutableArray alloc] init];
    
    self.isJoinOK = NO;
	// Do any additional setup after loading the view.    
    [self detailTitleView]; //标题view
    [self totalDetailViewCreate];

    [self totalBuyDetailDataRequest];//数据请求

}
- (void)dealloc
{
    [togeModel              release],togeModel = nil;
    [cellModel              release],cellModel = nil;
    [detailPartDataArray    release],detailPartDataArray = nil;

    [subTextField           release];
    [subPerLabel            release];
    [miniTextField          release];
    [headView               release];
    [partTableView          release];

    [super dealloc];

}
#pragma mark -----------   view
- (void)totalDetailViewCreate
{
    [self subscribeView];//认购
    [self detailMinimunView];//保底
    [self detailProjectContentView];//方案内容
    [self detailParticipationView];//参与人员
    [self detailimmediatelyView];//立即认购
    [self detailProjectMessageView];//方案详情
}
/*  标题 */
- (void)detailTitleView
{
    [super tabBarBackgroundImageViewWith:self.view];
    
   [self.view addSubview:getTopLableWithTitle(@"方案详情")];
    
    headView                            = [[UIView alloc]initWithFrame:CGRectMake(0, 69, 908, 77)];
    headView.backgroundColor            = [UIColor colorWithPatternImage:RYCImageNamed(@"total_detail_top_bg.png")];
    [self.view addSubview:headView];
    
    UIButton *detBackBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
    detBackBtn.frame                    = CGRectMake(0, 0, 76, 76);
    [detBackBtn setImage:RYCImageNamed(@"backBtn-nor.png") forState:btnNormal];
    [detBackBtn setImage:RYCImageNamed(@"backBtn-click.png") forState:UIControlStateHighlighted];
    [detBackBtn addTarget:self action:@selector(detailBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:detBackBtn];
    
    UIImageView * kindImg               = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 60, 60)];
    NSString    * imageString           = @"";
    NSString    * lotNoStr = cellModel.lotNo;
    if ([cellModel.lotNo isEqualToString:kLotNoSSQ]) {
        imageString                     = @"ssq.png";
    }else if ([cellModel.lotNo isEqualToString:kLotNoDLT])
    {
        imageString                     = @"dlt.png";
    }else if ([cellModel.lotNo isEqualToString:kLotNoFC3D])
    {
        imageString                     = @"fc3d.png";
        
    }else if ([lotNoStr isEqualToString:kLotNoJCZQ ]||[lotNoStr isEqualToString:kLotNoJCZQ_RQ ] || [lotNoStr isEqualToString: kLotNoJCZQ_SPF ] || [lotNoStr isEqualToString:kLotNoJCZQ_ZJQ ] || [lotNoStr isEqualToString:kLotNoJCZQ_SCORE ] || [lotNoStr isEqualToString:kLotNoJCZQ_HALF ] ||[lotNoStr isEqualToString:kLotNoJCLQ_CONFUSION ]||[lotNoStr isEqualToString:kLotNoJCZQ_CONFUSION ])
    {
        imageString                     = @"jczu.png";
    }else if ([lotNoStr isEqualToString:kLotNoBJDC ]||[lotNoStr isEqualToString:kLotNoBJDC_RQSPF ]||[lotNoStr isEqualToString:kLotNoBJDC_JQS ]||[lotNoStr isEqualToString:kLotNoBJDC_HalfAndAll ]||[lotNoStr isEqualToString:kLotNoBJDC_SXDS ]||[lotNoStr isEqualToString:kLotNoBJDC_Score])
    {
        imageString                     = @"bjdc.png";
    }else if ([lotNoStr isEqualToString:kLotNoPLS])
    {
        imageString                     = @"pl3.png";
    }else if([lotNoStr isEqualToString:kLotNoPL5])
    {
        imageString                     = @"pailie5.png";
    }else if([lotNoStr isEqualToString:kLotNoQXC])
    {
        imageString                     = @"qxc.png";
    }else if([lotNoStr isEqualToString:kLotNoZC]||[lotNoStr isEqualToString:kLotNoJQC ]||[lotNoStr isEqualToString:kLotNoLCB ]||[lotNoStr isEqualToString:kLotNoSFC ]||[lotNoStr isEqualToString:kLotNoRX9 ])
    {
        imageString                     = @"sfc.png";
    }else if ([lotNoStr isEqualToString:kLotNoJCLQ ]||[lotNoStr isEqualToString:kLotNoJCLQ_SF ]||[lotNoStr isEqualToString:kLotNoJCLQ_RF ]||[lotNoStr isEqualToString:kLotNoJCLQ_SFC ]||[lotNoStr isEqualToString:kLotNoJCLQ_DXF])
    {
        imageString                     = @"jclq.png";
    }else if ([cellModel.lotNo isEqualToString:kLotNoQLC])
    {
        imageString                     = @"qlc.png";
    }else if ([cellModel.lotNo isEqualToString:kLotNoGD115])
    {
        imageString                     = @"gz11x5.png";
    }
    kindImg.image                       = [UIImage imageNamed:imageString];
    [headView                          addSubview:kindImg];
    [kindImg release];
    
    UILabel *launchLabel                = [[UILabel alloc]initWithFrame:CGRectMake(kindImg.frame.origin.x + kindImg.frame.size.width +10, kindImg.frame.origin.y, 400, 25)];
    launchLabel.backgroundColor         = [UIColor clearColor];
    launchLabel.textColor               = [UIColor grayColor];
    launchLabel.text                    = [NSString stringWithFormat:@"合买发起人:   %@",cellModel.starter];
    [headView addSubview:launchLabel];
    [launchLabel release];
    
    UILabel  *gradeLabel                = [[UILabel alloc]initWithFrame:CGRectMake(launchLabel.frame.origin.x, launchLabel.frame.origin.y+30, 120, 25)];
    gradeLabel.backgroundColor          = [UIColor clearColor];
    gradeLabel.textColor                = [UIColor grayColor];
    gradeLabel.text                     = @"发起人等级：";
    [headView addSubview:gradeLabel];
    [gradeLabel release];
    
    int widthIndex = 0;
    icoHeightIndex = 0;
    DLog(@" model %@",cellModel);
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"crown.png" ICONUM:[cellModel.crown intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycrown.png" ICONUM:[cellModel.graycrown intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"cup.png" ICONUM:[cellModel.cup intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycup.png" ICONUM:[cellModel.graycup intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"diamond.png" ICONUM:[cellModel.diamond intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graydiamond.png" ICONUM:[cellModel.graydiamond intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"goldStar.png" ICONUM:[cellModel.goldStar intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graygoldStar.png" ICONUM:[cellModel.graygoldStar intValue]];
}
-(NSInteger)creatIcoImage:(NSInteger)widthIndex ICONAME:(NSString*)icoName ICONUM:(NSInteger)icoNum
{
    NSInteger width = widthIndex;
    if (icoNum > 0) {
        if (width > 100) {
            icoHeightIndex = 30;
            width  = 120;
        }
        UIImageView*  ico = [[UIImageView alloc] initWithFrame:CGRectMake(250+width,40,23,23)];
        ico.image = RYCImageNamed(icoName);
        [ico setBackgroundColor:[UIColor clearColor]];
        [headView addSubview:ico];
        [ico release];
        
        if (icoNum > 1) {
            UILabel* icoNumLable = [[UILabel alloc] initWithFrame:CGRectMake(ico.frame.origin.x + 5, 40 + 5, 23, 23)];
            icoNumLable.backgroundColor = [UIColor clearColor];
            icoNumLable.textAlignment = NSTextAlignmentRight;
            icoNumLable.text = [NSString stringWithFormat:@"%d",icoNum];
            icoNumLable.textColor = [UIColor colorWithRed:148.0/255.0 green:118.0/255.0 blue:0.0/255.0 alpha:1.0];
            icoNumLable.font = [UIFont systemFontOfSize:12];
            [headView addSubview:icoNumLable];
            [icoNumLable release];
        }
        width += 28;
    }
    
    return width;
}

/*  认购  */
- (void)subscribeView
{
    UIView * subView            = [[UIView alloc]initWithFrame:CGRectMake(0, 145, 600, 98)];
    subView.backgroundColor     = [UIColor whiteColor];
    [self.view addSubview:subView];
    [subView release];
    
    UILabel *subLabel           = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 25)];
    subLabel.text               = @"我要认购:";
    subLabel.backgroundColor    = [UIColor clearColor];
    [subView addSubview:subLabel];
    [subLabel release];
    
#define TagDetailTextField100  100
    int  subInt = 1;
    subTextField                = [[UITextField alloc]initWithFrame:CGRectMake(subLabel.frame.origin.x + subLabel.frame.size.width, subLabel.frame.origin.y-5, 150, 40)];
    subTextField.text           = [NSString stringWithFormat:@"%d",subInt];
    subTextField.delegate       = self;
    subTextField.tag            = TagDetailTextField100 +1;
    subTextField.borderStyle    = UITextBorderStyleRoundedRect;
    subTextField.contentVerticalAlignment = 0;
    [subView addSubview:subTextField];
    
#define  TagDetailLabel200 200
    subPerLabel                 = [[UILabel alloc]initWithFrame:CGRectMake(subTextField.frame.origin.x +subTextField.frame.size.width+10, subTextField.frame.origin.y, 200, 30)];
    subPerLabel.tag             = TagDetailLabel200;
    subPerLabel.text            = [NSString stringWithFormat: @"元    占总额%0.2f%%",0.0];
    subPerLabel.backgroundColor = [UIColor clearColor];
    [subView addSubview:subPerLabel];
    
    UILabel *subDesLabel        = [[UILabel alloc]initWithFrame:CGRectMake(subTextField.frame.origin.x, subTextField.frame.origin.y+40, 400, 30)];
    subDesLabel.backgroundColor = [UIColor clearColor];
    subDesLabel.tag = TagDetailLabel200+1;
    subDesLabel.text            = [NSString stringWithFormat:@"剩余%.2f元 可认购，至少认购%.f元",[togeModel.remainderAmt intValue]/100.0, [togeModel.minAmt doubleValue]/100];
    subDesLabel.textColor       =[UIColor redColor];
    [subView addSubview:subDesLabel];
    [subDesLabel release];
    
}
/*  保底 */
- (void)detailMinimunView
{
    UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 243, 600, 2)];
    lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [self.view addSubview:lineView];
    [lineView release];
    
    UIView *miniView            = [[UIView alloc]initWithFrame:CGRectMake(0, 245, 600, 80)];
    miniView.backgroundColor    = RGBCOLOR(255,255,255);
    [self.view addSubview:miniView];
    [miniView release];
    
    UILabel *miniLabel          = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 30)];
    miniLabel.text              = @"我要保底:";
    miniLabel.backgroundColor   = [UIColor clearColor];
    [miniView addSubview:miniLabel];
    [miniLabel release];
    
    miniTextField               = [[UITextField alloc]initWithFrame:CGRectMake(miniLabel.frame.origin.x+miniLabel.frame.size.width, miniLabel.frame.origin.y-5, 150, 40)];
    miniTextField.text          = @"0";
    miniTextField.delegate      = self;
    miniTextField.tag           = TagDetailTextField100 +2;
    miniTextField.borderStyle   = UITextBorderStyleRoundedRect;
    miniTextField.contentVerticalAlignment = 0;
    [miniView addSubview:miniTextField];
    
    UILabel *miniPerLabel       = [[UILabel alloc]initWithFrame:CGRectMake(miniTextField.frame.origin.x+miniTextField.frame.size.width+10, miniLabel.frame.origin.y, 200, 30)];
    miniPerLabel.backgroundColor=[UIColor clearColor];
    miniPerLabel.text           =[NSString stringWithFormat:@"元"];//    占总额%0.2f%%",0.0
    [miniView addSubview:miniPerLabel];
    [miniPerLabel release];
    
//    UILabel *miniDesLabel =[[UILabel alloc]initWithFrame:CGRectMake(miniTextField.frame.origin.x, miniTextField.frame.origin.y+50, 300, 30)];
//    miniDesLabel.backgroundColor =[UIColor clearColor];
//    miniDesLabel.text = [NSString stringWithFormat:@"剩余%d元可保底",209];
//    miniDesLabel.textColor =[UIColor redColor];
//    [miniView addSubview:miniDesLabel];
//    [miniDesLabel release];
    
}
/* 方案内容 */
- (void)detailProjectContentView
{
    UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 325, 600, 2)];
    lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [self.view addSubview:lineView];
    [lineView release];
    
    UIView *contentView             =[[UIView alloc]initWithFrame:CGRectMake(0, 327, 600, 158)];
    contentView.backgroundColor     = RGBCOLOR(255, 255, 255);
    [self.view addSubview:contentView];
    [contentView release];
    
    UILabel *contentLabel           =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    contentLabel.text               = @"方案内容:";//togeModel.betCodeHtml
    contentLabel.backgroundColor    =[UIColor clearColor];
    [contentView addSubview:contentLabel];
    [contentLabel release];
#define TagDetailWebView300 300
    UIWebView * webView             = [[UIWebView alloc]initWithFrame:CGRectMake(110, 5, 460, 150)];
    webView.backgroundColor         = [UIColor clearColor];
    [webView  setOpaque:NO];
    webView.tag = TagDetailWebView300;
    UIScrollView *scroller = [webView.subviews objectAtIndex:0];//去掉阴影
    if (scroller) {
        for (UIView *v in [scroller subviews]) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
    }
    [contentView addSubview:webView];
    [webView release];

}
/* 参与人员 */
- (void)detailParticipationView
{
    UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 485, 600, 2)];
    lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [self.view addSubview:lineView];
    [lineView release];
    
    UIView *partView    =[[UIView alloc]initWithFrame:CGRectMake(0, 487, 600, 230)];
    [self.view addSubview:partView];
    partView.backgroundColor = RGBCOLOR(255, 255, 255);
    [partView release];
    
    UILabel *parLabel           =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    parLabel.text               = @"参与人员";
    parLabel.backgroundColor    = [UIColor clearColor];
    [partView addSubview:parLabel];
    [parLabel release];
    
    partTableView =[[UITableView alloc]initWithFrame:CGRectMake(10, 30, 580, 130) style:UITableViewStylePlain];
    partTableView.delegate = self;
    partTableView.dataSource = self;
    partTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [partView addSubview:partTableView];
    
    m_refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0,30 + partTableView.frame.size.height, 320, REFRESH_HEADER_HEIGHT)];
    [partTableView addSubview:m_refreshView];
    m_refreshView.myScrollView = partTableView;
    [m_refreshView stopLoading:NO];
    [m_refreshView setRefreshViewFrame];
}
/* 立即认购 */
- (void)detailimmediatelyView
{
    UIView * botttomView = [[UIView alloc]initWithFrame:CGRectMake(0, 647, 600, 75)];
    botttomView.backgroundColor =[UIColor colorWithPatternImage:RYCImageNamed(@"result_down_bg.png")];
    [self.view addSubview:botttomView];
    [botttomView release];
    
    UIButton * immeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    immeButton.frame = CGRectMake(200, 660, 150, 46);
    [immeButton setBackgroundImage:RYCImageNamed(@"buyNormal.png") forState:btnNormal];
    [immeButton setBackgroundImage:RYCImageNamed(@"buyClick.png") forState:UIControlStateHighlighted];
    [immeButton setTitleColor:RGBCOLOR(255, 255, 255) forState:btnNormal];
    immeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [immeButton setTitle:@"立即认购" forState:UIControlStateNormal];
    [immeButton addTarget:self action:@selector(detailTOtalImmeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:immeButton]; 
}
/*  方案详情 */
- (void)detailProjectMessageView
{
    UIView *messageView =[[UIView alloc]initWithFrame:CGRectMake(600, 145, 309, 575)];
    [self.view addSubview:messageView];
    messageView.backgroundColor =RGBCOLOR(244, 244, 244);
    [messageView release];
    
    UIView *topBgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, messageView.frame.size.width, 44)];
    topBgView.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"basketBg.png")];
    [messageView addSubview:topBgView];
    [topBgView release];
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 100, 20)];
    label.text = @"方案详情";
    label.backgroundColor =[UIColor clearColor];
    [messageView addSubview:label];
    [label release];
    
    NSArray * titArray =[[NSArray alloc]initWithObjects:@"彩种:",@"截止时间:",@"方案金额:",@"方案编号:",@"认购金额:",@"保底金额:",@"方案进度:",@"方案状态:",@"剩余金额:",@"参与人数:",@"发起人提成:",@"方案描述:", nil];
#define TagProjectMessageLabel400 400
    for (int i=0; i<titArray.count; i++) {
       
        /* 左边标题*/
        UILabel *titLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 50+(40*i), 120, 25)];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.backgroundColor =[UIColor clearColor];
        titLabel.textColor = RGBCOLOR(91, 132, 172);
        titLabel.text =[titArray objectAtIndex:i];
        [messageView addSubview:titLabel];
        [titLabel release];
        /* 右边内容 */
        UILabel *mesLabel =[[UILabel alloc]initWithFrame:CGRectMake(titLabel.frame.size.width, titLabel.frame.origin.y, 200, 25)];
        if (i == titArray.count - 1) {
            mesLabel.frame = CGRectMake(10, titLabel.frame.origin.y+20, 300, 60);
            mesLabel.numberOfLines = 0;
        }
        mesLabel.backgroundColor =[UIColor clearColor];
        mesLabel.tag = TagProjectMessageLabel400+i;
        if (2==i ||4==i ||5==i ||8==i ||10==i) {
            mesLabel.textColor =[UIColor redColor];
        }
        [messageView addSubview:mesLabel];
        [mesLabel release];
        
        UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 44+(40*i), messageView.frame.size.width, 2)];
        lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
        [messageView addSubview:lineView];
        [lineView release];
    }
    [titArray release];

}
#pragma mark -------------- requeset methods

/* 合买详情 请求 */
- (void)totalBuyDetailDataRequest
{
    NSMutableDictionary * mDic = [[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"select" forKey:@"command"];
    [mDic setObject:@"caseLotDetail" forKey:@"requestType"];
    [mDic setObject:cellModel.caseLotId forKey:@"id"];
    if ([self isSuccessLogin]) {
        [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    }
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeQueryCaseLotDetail showProgress:YES];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryCaseLotDetail: //合买详情
        {
            DLog(@" 合买详情 -------- %@",dataDic);
            [self totalDetailViewDataTidyDictionary:dataDic];
        }
            break;
        case ASINetworkReqestTypeGetLotDate:// 参与人员
        {
            DLog(@" 参与人员 -------- %@",dataDic);
            if (ErrorCode(dataDic)) {
                [self totalDetailParticipationDataDictionary:dataDic];
            }
            else
                [m_refreshView stopLoading:YES];
        }
            break;
        case ASINetworkRequestTypeBetCaseLot://参与合买
        {
            DLog(@" 参与和买 -------- %@",dataDic);

            [self totalDetailImmediatelyBuyDictionary:dataDic];
        }
            break;
        default:
            break;
    }
    
}


/* 根据请求数据  布局视图 */
- (void)totalDetailViewDataTidyDictionary:(NSDictionary *)tDic
{
    NSDictionary * dic      = KISDictionaryHaveKey(tDic, @"result");
    QueryTogetherDetailModel * model
                            =[[QueryTogetherDetailModel alloc]init];
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
        model.betCodeHtml       = KISDictionaryHaveKey(dic, @"betCodeHtml");    model.betCodeJson       = KISDictionaryHaveKey(dic, @"betCodeJson");
    model.display           = KISDictionaryHaveKey(dic, @"display");
    model.visibility        = KISDictionaryHaveKey(dic, @"visibility");
    // betCodeJson json 数据
    
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
    // 专家战绩
    NSDictionary *palyIcon  = KISDictionaryHaveKey(dic, @"displayIcon");
    model.goldStar          = KISDictionaryHaveKey(palyIcon, @"goldStar");
    model.graygoldStar      = KISDictionaryHaveKey(palyIcon, @"graygoldStar");
    model.diamond           = KISDictionaryHaveKey(palyIcon, @"diamond");
    model.graydiamond       = KISDictionaryHaveKey(palyIcon, @"graydiamond");
    model.cup               = KISDictionaryHaveKey(palyIcon, @"cup");
    model.graycup           = KISDictionaryHaveKey(palyIcon, @"graycup");
    model.crown             = KISDictionaryHaveKey(palyIcon, @"crown");
    model.graycrown         = KISDictionaryHaveKey(palyIcon, @"graycrown");
    
    model.description       = KISDictionaryHaveKey(dic, @"description");
    model.displayState      = KISDictionaryHaveKey(dic, @"displayState");
    model.winCode           = KISDictionaryHaveKey(dic, @"winCode");
    model.endTime           = KISDictionaryHaveKey(dic, @"endTime");
    model.cancelCaselot     = KISDictionaryHaveKey(dic, @"cancelCaselot");
    model.canAutoJoin       = KISDictionaryHaveKey(dic, @"canAutoJoin");
    model.url               = KISDictionaryHaveKey(dic, @"url");
    
    self.togeModel          = [model retain];
    [model release];
    [self totalDetailViewDataRefresh];
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
        tempString = [tempString stringByAppendingFormat:@"投注：%@ <br/>",betString];
        
//        if ([KISDictionaryHaveKey(tempDic, @"homeScore") length] > 0) {
//            tempString = [tempString stringByAppendingFormat:@"全场比分：%@ : %@<br/>",KISDictionaryHaveKey(tempDic, @"homeScore"), KISDictionaryHaveKey(tempDic, @"guestScore")];
//        }
//        else
//            tempString = [tempString stringByAppendingString:@"全场比分：未开<br/>"];
//        
//        tempString = [tempString stringByAppendingFormat:@"赛果：%@ <br/>",[KISDictionaryHaveKey(tempDic, @"matchResult") length] > 0 ? KISDictionaryHaveKey(tempDic, @"matchResult") : @"未开"];
        
        tempString = [tempString stringByAppendingString:@"<br/>"];
    }
    return tempString;
}

/*  参与人员 数组 */
- (void)totalDetailParticipationDataDictionary:(NSDictionary *)mDic
{
    NSMutableArray *muArray     = [[NSMutableArray alloc]init];
    NSArray *result = KISDictionaryHaveKey(mDic, @"result");
    for (int i=0; i<result.count; i++) {
        NSDictionary * dic      = [result objectAtIndex:i];
        TogetherParticipationModel *model = [[TogetherParticipationModel alloc]init];
        model.nickName          = KISDictionaryHaveKey(dic, @"nickName");
        model.buyAmt            = KISDictionaryHaveKey(dic, @"buyAmt");
        model.buyTime           = KISDictionaryHaveKey(dic, @"buyTime");
        model.cancelCaselotbuy  = KISDictionaryHaveKey(dic, @"cancelCaselotbuy");
        model.state             = KISDictionaryHaveKey(dic, @"state");
        [muArray addObject:model];
        [model release];
    }
    [self.detailPartDataArray addObjectsFromArray:muArray];
    [muArray release];
    [partTableView reloadData];
    
    m_joinDataPageTotal = [KISDictionaryHaveKey(mDic, @"totalPage") integerValue];
    m_currentJoinDataPage ++;
    if(m_currentJoinDataPage == m_joinDataPageTotal)
    {
        [m_refreshView stopLoading:YES];
    }
    else
    {
        [m_refreshView stopLoading:NO];
    }
    [m_refreshView setRefreshViewFrame];
}
/* 立即 认购 */
- (void)totalDetailImmediatelyBuyDictionary:(NSDictionary *)mDic
{
    NSString * errCode = KISDictionaryHaveKey(mDic, @"error_code");
    NSString * message = KISDictionaryHaveKey(mDic, @"message");
    if ([errCode isEqualToString:@"0000"]) {
        
        self.isJoinOK = YES;
        
        [self detailBackButton:Nil];
        [self showAlertWithMessage:@"参与合买成功"];
    }else
    {
        [self showAlertWithMessage:message];
    }
}

- (void)queryFollowersWithPage:(NSInteger)page
{
    // 参与人员
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"QueryLot" forKey:@"command"];
    [mDic setObject:@"caseLotBuys" forKey:@"type"];
    [mDic setObject:togeModel.caseLotId forKey:@"caseid"];
    [mDic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageindex"];
    [mDic setObject:@"10" forKey:@"maxresult"];
    if ([UserLoginData sharedManager].hasLogin) {
        [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    }
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkReqestTypeGetLotDate showProgress:NO];
}
/*  数据更新 */
- (void)totalDetailViewDataRefresh
{
    // 认购
    int  subInt = 1;
    int intTotle = [togeModel.totalAmt intValue]/100;
    subPerLabel.text            = [NSString stringWithFormat: @"元    占总额%0.2f%%",(subInt*1.0/intTotle)*100];
    // 保底
    UILabel * subLabel = (UILabel *)[self.view viewWithTag:TagDetailLabel200+1];
    subLabel.text            = [NSString stringWithFormat:@"剩余%.2f元 可认购，至少认购%.lf元",[togeModel.remainderAmt intValue]/100.0, [togeModel.minAmt doubleValue]/100.0];
    // 方案内容
    UIWebView *webView = (UIWebView *)[self.view viewWithTag:TagDetailWebView300];
    [webView loadHTMLString:togeModel.betCodeHtml baseURL:nil];
     // 参与人员
    [self queryFollowersWithPage:0];
    
    // 方案详情
    NSString * playState = nil;
    //1:认购中;2:满员;3:成功;4:撤单;5:流单;6:已中奖
    switch ([togeModel.displayState intValue]) {
        case 1:
            playState = @"认购中";
            break;
        case 2:
            playState = @"满员";
            break;
        case 3:
            playState = @"成功";
            break;
        case 4:
            playState = @"撤单";
            break;
        case 5:
            playState = @"流单";
            break;
        case 6:
            playState = @"已中奖";
            break;
        default:
            break;
    }
    NSArray * messArray = @[togeModel.lotName,
                            togeModel.endTime,
                            [NSString stringWithFormat:@"%0.2f元", [togeModel.totalAmt intValue]/100.0],
                            togeModel.caseLotId,
                            [NSString stringWithFormat:@"%.2f元" ,[togeModel.hasBuyAmt intValue]/100.0],
                            [NSString stringWithFormat:@"%.2f元",[togeModel.safeAmt intValue]/100.0],
                            [NSString stringWithFormat:@"%@%%",togeModel.buyProgress], playState,
                            [NSString stringWithFormat:@"%.2f元",[togeModel.remainderAmt intValue]/100.0],
                            [NSString stringWithFormat:@"%@人", togeModel.participantCount],
                            [NSString stringWithFormat:@"%@%%",togeModel.commisionRatio],
                            togeModel.description,];

    for (int i=0; i<messArray.count; i++) {
        UILabel * messLabel = (UILabel *)[self.view viewWithTag:TagProjectMessageLabel400+i];
        messLabel.text = [messArray objectAtIndex:i];
    }
}
#pragma mark ---------- textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    double intText      = [textField.text doubleValue];
    int remInt          =[togeModel.remainderAmt intValue]/100;//剩余金额

    if (subTextField == textField) {//认购
        if (intText >= (remInt - ([miniTextField.text doubleValue]))) {
            intText = MAX(remInt - [miniTextField.text doubleValue], 0);
        }
        textField.text  = [NSString stringWithFormat:@"%.lf",intText];
        
        int totalInt        = [togeModel.totalAmt intValue]/100;
        subPerLabel.text    = [NSString stringWithFormat: @"元     占总额%.2f%%",(intText*1.0/totalInt)*100];
    }
    else if (miniTextField == textField)//保底
    {
        double leaveSafe = [togeModel.totalAmt doubleValue]/100 - [togeModel.hasBuyAmt doubleValue]/100 - [togeModel.safeAmt doubleValue]/100 - [subTextField.text doubleValue];
        if (intText > leaveSafe) {
            intText = MAX(leaveSafe, 0);
        }
        textField.text  = [NSString stringWithFormat:@"%.lf",intText];
    }

    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string//只允许输入数字所以，(限制输入英文和数字的话，就可以把这个定义为：#define kAlphaNum   @”ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789″)。
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
}
#pragma mark ---------- detailView methods
- (void)detailBackButton:(id)sender
{
    [self.delegate detailTotalBuyViewDisappear:self];
}
- (void)detailTOtalImmeButton:(id)sender
{
    
    if (![self isSuccessLogin]) {
        LoginViewController *login =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        login.delegate = self;
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:login animated:YES completion:^{
            
        }];
        [login release];
        return ;
    }
    
    if (0 == subTextField.text.length || 0 == miniTextField.text.length)
    {
        [self showAlertWithMessage:@"认购或保底金额不允许为空"];
        return;
    }
    if (0 ==[subTextField.text intValue] && 0 ==[miniTextField.text intValue])
    {
        [self showAlertWithMessage: @"认购和保底金额不允许都为零"];
        return;
    }
    if (![self HMCheckTextField]) {
        return;
    }
    
    if ([subTextField.text intValue]*100 >[togeModel.remainderAmt intValue]) {
       [ self showAlertWithMessage:[NSString stringWithFormat:@"剩余可认购金额为 %@ 元",togeModel.remainderAmt]];
    }

    
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
    [mDic setObject:@"betLot" forKey:@"command"];
    [mDic setObject:@"betcase" forKey:@"bettype"];
    [mDic setObject:togeModel.caseLotId forKey:@"caseid"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDic setObject:[NSString stringWithFormat:@"%d", [subTextField.text intValue] * 100] forKey:@"amount"];
	[mDic setObject:[NSString stringWithFormat:@"%d", [miniTextField.text intValue] * 100] forKey:@"safeAmt"];
    NSString* phoneName = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveUserNameKey];
    
    if(phoneName && [phoneName isEqualToString:@"15847754382"])
    {
        [self wapBetWithDic:mDic];
    }
    else
    {
        [RYCNetworkManager sharedManager].netDelegate = self;
        [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeBetCaseLot showProgress:YES];
    }
    [mDic release];
}

- (void)wapBetWithDic:(NSDictionary*)dataDic
{
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:dataDic];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    NSString *AESstring = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];
    
    NSString *sendStr = kRuYiCaiHMSafari;
    NSString *allStr = [sendStr stringByAppendingString:AESstring];
    NSLog(@"safari:%@ ", allStr);
    
    NSString *strUrl = [allStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)HMCheckTextField
{
//    NSString* subString = subTextField.text;
//    for (int i = 0; i < subString.length; i++)
//    {
//        UniChar chr = [subString characterAtIndex:i];
//        if (chr < '0' || chr > '9')
//        {
//            [self showAlertWithMessage:@"认购金额须为整数" ];
//            return NO;
//        }
//    }
//    NSString* minString = miniTextField.text;
//    for (int i = 0; i < minString.length; i++)
//    {
//        UniChar chr = [minString characterAtIndex:i];
//        if (chr < '0' || chr > '9')
//        {
//            [self showAlertWithMessage:@"保底金额须为整数" ];
//            return NO;
//        }
//    }
    double remInt  = [togeModel.remainderAmt doubleValue]/100;//剩余金额
    double minInt = [togeModel.minAmt doubleValue]/100;//最低认购
    
    if (remInt >= minInt) {//剩余的比最低的多
        if ([subTextField.text doubleValue] < minInt && [subTextField.text doubleValue] != 0) {//认购少于最低
            [self showAlertWithMessage:[NSString stringWithFormat:@"最低认购%.lf元", minInt]];
            return NO;
        }
    }
    else
    {
        if ([subTextField.text doubleValue] != remInt) {//认购少于最低
            [self showAlertWithMessage:[NSString stringWithFormat:@"剩余%.lf元必须全部认购", remInt]];
            return NO;
        }
    }
    if([subTextField.text doubleValue] == 0 && [miniTextField.text doubleValue] == 0)
    {
        [self showAlertWithMessage:@"认购和保底不能同时为0！"];
        return NO;
    }
    return YES;
}
#pragma mark ------------ loginViewDelegate
- (void)loginViewSuccessLogin
{
    
}
#pragma mark ------------- partTableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.detailPartDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *celled = @"celled";
    DetailTotalViewPartCell * cell =(DetailTotalViewPartCell *)[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell == nil) {
        cell =[[[DetailTotalViewPartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celled]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model =[self.detailPartDataArray objectAtIndex:indexPath.row];
    [cell detailTotalPartCellRefresh];
    return cell;
    
}
#pragma mark   ------------------------- scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [m_refreshView viewdidScroll:scrollView];
}
#pragma mark --------------------------  pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [m_refreshView viewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [m_refreshView didEndDragging:scrollView];
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if(m_currentJoinDataPage < m_joinDataPageTotal)
    {
        [self queryFollowersWithPage:m_currentJoinDataPage];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[m_refreshView stopLoading:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
