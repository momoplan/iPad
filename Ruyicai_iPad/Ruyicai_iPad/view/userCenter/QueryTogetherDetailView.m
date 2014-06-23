//
//  QueryTogetherDetailView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-30.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryTogetherDetailView.h"
#import "UserCenterTogetherFowllerCell.h"

@implementation QueryTogetherDetailView
@synthesize delegate;
@synthesize detModel;
@synthesize participationArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =[UIColor whiteColor];
        
        UIImageView *imgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryDetailBg.png"]];
        imgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:imgView];
        [imgView release];
        
     
        UILabel *titLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
        titLabel.backgroundColor =[UIColor clearColor];
        titLabel.text = @"合买详情";
        titLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titLabel];
        [titLabel release];
        
        togetherDetailView =[[UIScrollView alloc]initWithFrame:CGRectMake(5, 50, frame.size.width-10, 490)];
        togetherDetailView.backgroundColor =[UIColor clearColor];
        togetherDetailView.contentSize = CGSizeMake(frame.size.width-10, 900);
        [self addSubview:togetherDetailView];
        
           
        UIButton *closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(305, 0, 55, 55);
        [closeBtn setImage:[UIImage imageNamed:@"queryclose.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(queryTogetherDetailCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        
        
        [self sponsorLabelMessage];//发起人信息
        [self schemeInfomation];//方案信息
        [self schemeContent];//方案内容
        [self participationPersonnel];// 参与人员列表
        
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    [detModel release],detModel = nil;
    [personTableView release];
//    [participationArray release],participationArray = nil;
    
    [sponLabel release];
    [contentWebView release];
    [numberLabel release];
    [super dealloc];

}
#pragma mark ---------- view
/* 发起人 信息 */
- (void)sponsorLabelMessage
{
    UILabel *titleLabel         =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
    titleLabel.text             = @"发起人信息";
    titleLabel.backgroundColor  = [UIColor clearColor];
    [togetherDetailView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel * tetLabel          = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 100, 20)];
    tetLabel.text               = @"发起人:";
    tetLabel.textAlignment      = NSTextAlignmentCenter;
    tetLabel.backgroundColor    = titleLabel.backgroundColor;
    tetLabel.textColor          =[UIColor blueColor];
    [togetherDetailView addSubview:tetLabel];
    [tetLabel release];
    
    UILabel *recLabel           =[[UILabel alloc]initWithFrame:CGRectMake(20, 70, 100, 20)];
    recLabel.text = @"战 绩:";
    recLabel.textAlignment      = NSTextAlignmentCenter;
    recLabel.backgroundColor    = titleLabel.backgroundColor;
    recLabel.textColor          = tetLabel.textColor;
    [togetherDetailView addSubview:recLabel];
    [recLabel release];
    
    sponLabel                   = [[UILabel alloc]initWithFrame:CGRectMake(tetLabel.frame.origin.x + tetLabel.frame.size.width, tetLabel.frame.origin.y, 200, 20)];
    sponLabel.textAlignment     = NSTextAlignmentCenter;
    sponLabel.backgroundColor   = titleLabel.backgroundColor;
    [togetherDetailView addSubview:sponLabel];
    
   
    
}
/* 方案信息 */
- (void)schemeInfomation
{
    UILabel * titLabel          =[[UILabel alloc]initWithFrame:CGRectMake(10, 120, 150, 20)];
    titLabel.text               = @"方案信息";
    titLabel.font               =[UIFont boldSystemFontOfSize:16];
    titLabel.backgroundColor    = [UIColor clearColor];
    [togetherDetailView addSubview:titLabel];
    [titLabel release];
#define TagSchemeInfoLabel200 200
    NSArray *leArray            =[[NSArray alloc]initWithObjects:@"彩种:",@"截止时间:",@"方案金额:",@"方案期号:",@"方案编号:",@"认购金额:",@"保底金额:",@"方案进度:",@"方案状态:",@"剩余金额:",@"参与人数:",@"发起人提成:",@"方案描述:", nil];
  
    for (int i=0; i<leArray.count; i++) {
        UILabel *leftLabel      = [[UILabel alloc]initWithFrame:CGRectMake(5, 150+(30*i), 150, 20)];
        leftLabel.text          = [NSString stringWithFormat:@"%@",[leArray objectAtIndex:i]];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.textColor     = [UIColor blueColor];
        leftLabel.backgroundColor = [UIColor clearColor];
        [togetherDetailView addSubview:leftLabel];
        [leftLabel release];
        
        UILabel *rightLabel     =[[UILabel alloc]initWithFrame:CGRectMake(150, leftLabel.frame.origin.y, 200, 20)];
        rightLabel.tag          = TagSchemeInfoLabel200+i;
        rightLabel.backgroundColor = [UIColor clearColor];
        [togetherDetailView addSubview:rightLabel];
        [rightLabel release];
    }
    [leArray release];
}
/* 方案内容 */
- (void)schemeContent
{
    UILabel *titLabel           =[[UILabel alloc]initWithFrame:CGRectMake(10, 550, 150, 20)];   
    titLabel.font               =[UIFont boldSystemFontOfSize:16];
    titLabel.backgroundColor    = [UIColor clearColor];

    titLabel.text               = @"方案内容";
    [togetherDetailView addSubview:titLabel];
    [titLabel release];
    
    contentWebView             =[[UIWebView alloc]initWithFrame:CGRectMake(20, 570, 300, 100)];

    contentWebView.backgroundColor = [UIColor clearColor];
    UIScrollView *scroller = [contentWebView.subviews objectAtIndex:0];//去掉阴影
    if (scroller) {
        for (UIView *v in [scroller subviews]) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
    }
    [togetherDetailView addSubview:contentWebView];
    
    UILabel *numTitLabel        = [[UILabel alloc]initWithFrame:CGRectMake(20, contentWebView.frame.origin.y+contentWebView.frame.size.height + 10, 120, 20)];
    numTitLabel.text            = @"开奖号码:";
    numTitLabel.backgroundColor = titLabel.backgroundColor;

    numTitLabel.textColor       = [UIColor blackColor];
    [togetherDetailView addSubview:numTitLabel];
    [numTitLabel release];
    
    numberLabel                 = [[UILabel alloc]initWithFrame:CGRectMake(numTitLabel.frame.origin.x + numTitLabel.frame.size.width, numTitLabel.frame.origin.y, 200, 20)];
    numberLabel.backgroundColor = titLabel.backgroundColor;

    numberLabel.textColor       = [UIColor blackColor];
    [togetherDetailView addSubview:numberLabel];
}
/*  参与人员 */
- (void)participationPersonnel
{
    UILabel *titLabel           =   [[UILabel alloc]initWithFrame:CGRectMake(10, 720, 150, 20)];
    titLabel.text               = @"参与人员";
    titLabel.backgroundColor    = [UIColor clearColor];
    titLabel.font               = [UIFont boldSystemFontOfSize:16];
    [togetherDetailView addSubview:titLabel];
    [titLabel release];

    self.participationArray     =[[NSMutableArray alloc]init];
    
    personTableView             =[[UITableView alloc]initWithFrame:CGRectMake(20, titLabel.frame.origin.y+titLabel.frame.size.height, 300, 150) style:UITableViewStylePlain];
    personTableView.delegate    = self;
    personTableView.dataSource  = self;
    [togetherDetailView addSubview:personTableView];
    
}
/* 详情关闭 */
- (void)queryTogetherDetailCloseButton:(id)sender
{
    [self.delegate queryTogetherDeTailDisappear:self];
}
#pragma mark ----------- model
- (void)togetherDetailDataModel:(QueryTogetherDetailModel *)model
{
    self.detModel = [model retain];
    
    sponLabel.text = detModel.starter;
    
    
    int widthIndex = 0;
    icoHeightIndex = 0;
    DLog(@" model %@",model);
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"crown.png" ICONUM:[detModel.crown intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycrown.png" ICONUM:[detModel.graycrown intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"cup.png" ICONUM:[detModel.cup intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycup.png" ICONUM:[detModel.graycup intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"diamond.png" ICONUM:[detModel.diamond intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graydiamond.png" ICONUM:[detModel.graydiamond intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"goldStar.png" ICONUM:[detModel.goldStar intValue]];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graygoldStar.png" ICONUM:[detModel.graygoldStar intValue]];
    
    NSString * buyProgress = [NSString stringWithFormat:@"%.2f%%",[detModel.buyProgress floatValue]*1.0];
    NSString * playState = nil; //1:认购中;2:满员;3:成功;4:撤单;5:流单;6:已中奖
    switch ([detModel.displayState intValue]) {
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
    NSArray *riArray = @[detModel.lotName,
                         detModel.endTime,
                         [NSString stringWithFormat:@"%.2f元", [detModel.totalAmt intValue]/100.0],
                         detModel.batchCode,
                         detModel.caseLotId,
                         [NSString stringWithFormat:@"%.2f元",[detModel.hasBuyAmt intValue]/100.0],
                         [NSString stringWithFormat:@"%.2f元",[detModel.safeAmt intValue]/100.0],
                         buyProgress,
                         playState,
                         [NSString stringWithFormat:@"%.2f元",[detModel.remainderAmt intValue]/100.0],
                         detModel.participantCount,
                         [NSString stringWithFormat:@"%@%%",detModel.commisionRatio],
                         detModel.description];

    for (int i=0; i<riArray.count; i++) {
        UILabel * label = (UILabel *)[togetherDetailView viewWithTag:TagSchemeInfoLabel200+i];
        label .text =[NSString stringWithFormat:@"%@", [[riArray objectAtIndex:i] length] > 0 ? [riArray objectAtIndex:i] : @"无"];
    }
    
    [contentWebView loadHTMLString:detModel.betCodeHtml baseURL:nil];
    numberLabel.text            = [detModel.winCode length] > 0 ? detModel.winCode : @"无";
    
    [self togetherDetailParticipationRequestPage:0];//参与人员 请求
    
}
-(NSInteger)creatIcoImage:(NSInteger)widthIndex ICONAME:(NSString*)icoName ICONUM:(NSInteger)icoNum
{
    NSInteger width = widthIndex;
    if (icoNum > 0) {
        if (width > 100) {
            icoHeightIndex = 30;
            width  = 120;
        }
        UIImageView*  ico = [[UIImageView alloc] initWithFrame:CGRectMake(120+width,70,23,23)];
        ico.image = [UIImage imageNamed:icoName];
        [ico setBackgroundColor:[UIColor clearColor]];
        [togetherDetailView addSubview:ico];
        [ico release];
        
        if (icoNum > 1) {
            UILabel* icoNumLable = [[UILabel alloc] initWithFrame:CGRectMake(ico.frame.origin.x + 5, 70 + 5, 23, 23)];
            icoNumLable.backgroundColor = [UIColor clearColor];
            icoNumLable.textAlignment = NSTextAlignmentRight;
            icoNumLable.text = [NSString stringWithFormat:@"%d",icoNum];
            icoNumLable.textColor = [UIColor colorWithRed:148.0/255.0 green:118.0/255.0 blue:0.0/255.0 alpha:1.0];
            icoNumLable.font = [UIFont systemFontOfSize:12];
            [togetherDetailView addSubview:icoNumLable];
            [icoNumLable release];
        }
        width += 28;
    }
    
    return width;
}

/*  参与人员 数据请求 */
- (void)togetherDetailParticipationRequestPage:(int)pageIndex
{
    NSMutableDictionary * mDic  = [[NSMutableDictionary alloc]init];
    [mDic setObject:@"QueryLot" forKey:@"command"];
    [mDic setObject:@"caseLotBuys" forKey:@"type"];
    [mDic setObject:detModel.caseLotId forKey:@"caseid"];
    [mDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];
    [mDic setObject:@"10" forKey:@"maxresult"];
    if ([UserLoginData sharedManager].hasLogin) {
        [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    }
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkReqestTypeGetLotDate showProgress:NO];
    [mDic release];
}

#pragma mark -------- notification methods
/* 通知中心 回调函数 */
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkReqestTypeGetLotDate:
        {
            [self togetherParticipationDataDictionary:dataDic];
        }
            break;
        default:
            break;
        
    }
}
/*  参与人员 数组 */
- (void)togetherParticipationDataDictionary:(NSDictionary *)mDic
{
    [self.participationArray removeAllObjects];
    [personTableView reloadData];

    NSArray *result = KISDictionaryHaveKey(mDic, @"result");
    for (int i=0; i<result.count; i++) {
        NSDictionary * dic =[result objectAtIndex:i];

        [self.participationArray addObject:dic];
    }
    [personTableView reloadData];
}
#pragma mark -------------- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.participationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dequeCell =@"celled";
    UserCenterTogetherFowllerCell * cell =[tableView dequeueReusableCellWithIdentifier:dequeCell];
    
    if (cell == nil) {
        cell =[[[UserCenterTogetherFowllerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
    }
    cell.nameLabel.text = KISDictionaryHaveKey([self.participationArray objectAtIndex:indexPath.row], @"nickName");
    cell.costLabel.text = [NSString stringWithFormat: @"%.2f元",[KISDictionaryHaveKey([self.participationArray objectAtIndex:indexPath.row], @"buyAmt") intValue]/100.0];;
    cell.timeLabel.text = KISDictionaryHaveKey([self.participationArray objectAtIndex:indexPath.row], @"buyTime");
    
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
