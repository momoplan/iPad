//
//  LotteryDatailView.m
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "LotteryDatailView.h"
#import "CommonRecordStatus.h"


@implementation LotteryDatailView
@synthesize detailData = m_detailData;
@synthesize batchCodeLabel = m_batchCodeLabel;
@synthesize openPrizeDateLabel = m_openPrizeDateLabel;
@synthesize ballView = m_ballView;
@synthesize xiaoLiangLabel = m_xiaoLiangLabel;
@synthesize jiangChiLabel = m_jiangChiLabel;
@synthesize formView = m_formView;
@synthesize formHeadView = m_formHeadView;
@synthesize myScrollView = m_myScrollView;
@synthesize lotNo = m_lotNo;
- (void) dealloc
{
    [m_myScrollView release];
    [m_formHeadView release];
    [m_formView release];
    [m_batchCodeLabel release];
    [m_openPrizeDateLabel release];
    [m_ballView release];
    [m_xiaoLiangLabel release];
    [m_jiangChiLabel release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //开奖详情
        [self setLotteryDetail];
        
        //开奖详细
        [self setLotteryInfo];
    }
    return self;
}

//开奖详情
- (void) setLotteryDetail
{
    UILabel *lotteryDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 100, 40)];
    lotteryDetailLabel.text = @"开奖详情";
    lotteryDetailLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:lotteryDetailLabel];
    [lotteryDetailLabel release];
    
    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 390, 120)];
    yellowView.backgroundColor = RGBCOLOR(255, 246, 228);
    [self addSubview:yellowView];
    
    //期号
    m_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 390, 40)];
    m_batchCodeLabel.backgroundColor = [UIColor clearColor];
    m_batchCodeLabel.textAlignment = NSTextAlignmentLeft;
    [yellowView addSubview:m_batchCodeLabel];
    
    //开奖日期
    m_openPrizeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 390, 40)];
    m_openPrizeDateLabel.backgroundColor = [UIColor clearColor];
    m_openPrizeDateLabel.textAlignment = NSTextAlignmentLeft;
    [yellowView addSubview:m_openPrizeDateLabel];
    
    //小球
    m_ballView = [[LotteryBallCommonView alloc] initWithFrame:CGRectMake(10, 70, 390, 40)];
    [yellowView addSubview:m_ballView];
    [yellowView release];
    
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, 390, 70)];
    grayView.backgroundColor = RGBCOLOR(238, 238, 238);
    [self addSubview:grayView];
    //本期销量
    m_xiaoLiangLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 390, 40)];
    m_xiaoLiangLabel.backgroundColor = [UIColor clearColor];
    m_xiaoLiangLabel.textAlignment = NSTextAlignmentLeft;
    [grayView addSubview:m_xiaoLiangLabel];
    
    //奖池滚存
    m_jiangChiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 390, 40)];
    m_jiangChiLabel.backgroundColor = [UIColor clearColor];
    m_jiangChiLabel.textAlignment = NSTextAlignmentLeft;
    [grayView addSubview:m_jiangChiLabel];
    [grayView release];
}


//开奖详细
- (void) setLotteryInfo
{
    //表头
    m_formHeadView = [[UIView alloc] initWithFrame:CGRectMake(10, 230, 380, 300)];
    
    UILabel *lotteryDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 40)];
    lotteryDetailLabel.text = @"开奖详细";
    lotteryDetailLabel.font = [UIFont systemFontOfSize:18];
    [m_formHeadView addSubview:lotteryDetailLabel];
    [lotteryDetailLabel release];
    
    CustomFormView *headForm = [[CustomFormView alloc] initWithFrame:CGRectMake(0, 40, 380, 40)];
    headForm.row = 1;
    headForm.vertical = 3;
    
    NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:1];
    [rowArray addObject:@"40"];
    headForm.rowHeithArray = [NSArray arrayWithArray:rowArray];
    
    NSMutableArray *verticalArray = [NSMutableArray arrayWithCapacity:1];
    [verticalArray addObject:@"100"];
    [verticalArray addObject:@"135"];
    [verticalArray addObject:@"135"];
    headForm.vWidthArray = [NSArray arrayWithArray:verticalArray];
    headForm.titleBgColor = RGBCOLOR(238, 238, 238);
    [headForm drawCell];
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:1];
    [contentArray addObject:@"奖项"];
    [contentArray addObject:@"中奖注数（注）"];
    [contentArray addObject:@"单注金额（元）"];
    [headForm setFormCellContentWithArray:contentArray];
    
    [m_formHeadView addSubview:headForm];
    [headForm release];
    [self addSubview:m_formHeadView];
}

- (void) refleshView
{
    NSString *temp_batchCode  = KISDictionaryHaveKey(m_detailData, @"batchCode");
    NSString *temp_openPrizeNo = KISDictionaryHaveKey(m_detailData, @"winNo");
    NSString *temp_lotNo = KISDictionaryHaveKey(m_detailData, @"lotNo");
    NSString *temp_openPrizeDate = KISDictionaryHaveKey(m_detailData, @"openTime");
    NSString *temp_sellTotalAmount = KISDictionaryHaveKey(m_detailData, @"sellTotalAmount");
    NSString *temp_prizePoolTotalAmount = KISDictionaryHaveKey(m_detailData, @"prizePoolTotalAmount");
    if ([temp_sellTotalAmount isEqualToString:@""]) {
        temp_sellTotalAmount = [NSString stringWithFormat:@"0"];
    }
    
    if ([temp_prizePoolTotalAmount isEqualToString:@""]) {
        temp_prizePoolTotalAmount = [NSString stringWithFormat:@"0"];
    }
    
    m_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期",temp_batchCode];
    m_openPrizeDateLabel.text = [NSString stringWithFormat:@"开奖日期：%@",temp_openPrizeDate];
    
    NSString *lotTitle = [[CommonRecordStatus commonRecordStatusManager] lotTitleWithLotNo:temp_lotNo];
    [m_ballView drawBallWithLotteryCode:temp_openPrizeNo lotteryTitle:lotTitle scope:0.8];
    
    m_xiaoLiangLabel.text = [NSString stringWithFormat:@"本期销量：%@元",temp_sellTotalAmount];
    m_jiangChiLabel.text = [NSString stringWithFormat:@"奖池滚存：%@元",temp_prizePoolTotalAmount];
    
    //画表
    if (m_myScrollView == nil) {
        [self createFormWithLotNo:temp_lotNo];
    }
    //刷新表格内容
    [m_formView setFormCellContentWithArray:[self getCellContentWithLotNo:temp_lotNo]];
}

#pragma mark 画表
- (void) createFormWithLotNo:(NSString*) lotNo
{
    m_myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 310, 380, 340)];
    [self addSubview:m_myScrollView];
    
    m_formView = [[CustomFormView alloc] initWithFrame:CGRectMake(0, 0, 380, 600)];
    [self setFormRowAndVerticalWithLotNo:lotNo];
    m_formView.lineColor = [UIColor grayColor];
    
    //设置滑动和不滑动
    if (m_formView.row <= 8) 
        m_myScrollView.contentSize = CGSizeMake(380, 340);
    else
        m_myScrollView.contentSize = CGSizeMake(380, 600);
    
    //没有表格时
    if (m_formView.row <= 0) {
        m_formHeadView.hidden = YES;
    }
    
    NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < m_formView.row; i++) {
        [rowArray addObject:@"35"];
    }
    m_formView.rowHeithArray = [NSArray arrayWithArray:rowArray];
    
    NSMutableArray *verticalArray = [NSMutableArray arrayWithCapacity:1];
    [verticalArray addObject:@"100"];
    [verticalArray addObject:@"135"];
    [verticalArray addObject:@"135"];
    m_formView.vWidthArray = [NSArray arrayWithArray:verticalArray];
    
    //绘制单元格
    [m_formView drawCell];
    [m_myScrollView addSubview:m_formView];
}

//设置表格的行数和列数
- (void) setFormRowAndVerticalWithLotNo:(NSString*) lotNo
{
    if ([lotNo isEqualToString:kLotNoSSQ]) {
        m_formView.row = 6;
        m_formView.vertical = 3;
    }
    else if([lotNo isEqualToString:kLotNoQLC])
    {
        m_formView.row = 7;
        m_formView.vertical = 3;
    }
    else if([lotNo isEqualToString:kLotNoFC3D])
    {
        m_formView.row = 3;
        m_formView.vertical = 3;
    }
    else if([lotNo isEqualToString:kLotNo115])
    {
        m_formView.row = 0;
        m_formView.vertical = 0;
    }
    else if([lotNo isEqualToString:kLotNoSSC])
    {
        m_formView.row = 0;
        m_formView.vertical = 0;
    }
    else if([lotNo isEqualToString:kLotNoDLT])
    {
        m_formView.row = 15;
        m_formView.vertical = 3;
    }
    else
    {
        m_formView.row = 0;
        m_formView.vertical = 0;
    }
}


//获取表内容
- (NSMutableArray*) getCellContentWithLotNo:(NSString*)lotNo
{
    NSMutableArray *cellContentArray = [NSMutableArray arrayWithCapacity:1];
    if ([lotNo isEqualToString:kLotNoSSQ]) {
        [cellContentArray addObject:@"一等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"onePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"onePrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"二等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"twoPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"twoPrizeAmt")doubleValue]/100]];
        [cellContentArray addObject:@"三等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"threePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"threePrizeAmt")doubleValue]/100]];
        [cellContentArray addObject:@"四等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"fourPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"fourPrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"五等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"fivePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"fivePrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"六等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"sixPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"sixPrizeAmt") doubleValue]/100]];
    }
    else if([lotNo isEqualToString:kLotNoQLC])
    {
        [cellContentArray addObject:@"一等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"onePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"onePrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"二等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"twoPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"twoPrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"三等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"threePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"threePrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"四等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"fourPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"fourPrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"五等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"fivePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"fivePrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"六等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"sixPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"sixPrizeAmt")  doubleValue]/100]];
        [cellContentArray addObject:@"七等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"sevenPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"sevenPrizeAmt") doubleValue]/100]];
    }
    else if([lotNo isEqualToString:kLotNoFC3D])
    {
        [cellContentArray addObject:@"一等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"onePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"onePrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"二等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"twoPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"twoPrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"三等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"threePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"threePrizeAmt") doubleValue]/100]];
    }
    else if([lotNo isEqualToString:kLotNo115])
    {
        cellContentArray = nil;
    }
    else if([lotNo isEqualToString:kLotNoSSC])
    {
        cellContentArray = nil;
    }
    else if([lotNo isEqualToString:kLotNoDLT])
    {
        [cellContentArray addObject:@"一等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"onePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"onePrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"追加"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"onePrizeZJNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"onePrizeZJAmt") doubleValue]/100]];
        [cellContentArray addObject:@"二等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"twoPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"twoPrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"追加"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"twoPrizeZJNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"twoPrizeZJAmt") doubleValue]/100]];
        [cellContentArray addObject:@"三等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"threePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"threePrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"追加"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"threePrizeZJNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"threePrizeZJAmt") doubleValue]/100]];
        [cellContentArray addObject:@"四等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"fourPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"fourPrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"追加"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"fourPrizeZJNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"fourPrizeZJAmt") doubleValue]/100]];
        [cellContentArray addObject:@"五等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"fivePrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"fivePrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"追加"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"fivePrizeZJNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"fivePrizeZJAmt") doubleValue]/100]];
        [cellContentArray addObject:@"六等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"sixPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"sixPrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"追加"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"sixPrizeZJNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"sixPrizeZJAmt") doubleValue]/100]];
        [cellContentArray addObject:@"七等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"sevenPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"sevenPrizeAmt") doubleValue]/100]];
        [cellContentArray addObject:@"追加"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"sevenPrizeZJNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"sevenPrizeZJAmt") doubleValue]/100]];
        [cellContentArray addObject:@"八等奖"];
        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"eightPrizeNum")];
        [cellContentArray addObject:[NSString stringWithFormat:@"%.lf",[KISDictionaryHaveKey(m_detailData, @"eightPrizeAmt") doubleValue]/100]];
//        [cellContentArray addObject:@"12选2"];
//        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"twelveSelect2PrizeNum")];
//        [cellContentArray addObject:KISDictionaryHaveKey(m_detailData, @"twelveSelect2PrizeAmt")];
    }
    else
    {
        cellContentArray = nil;
    }
    
    return cellContentArray;
}

@end
