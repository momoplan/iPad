//
//  PickNumBasketView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "PickNumBasketView.h"
#import "LoginViewController.h"
@implementation PickNumBasketView
@synthesize numDataArray;
@synthesize lotNo; //彩种
@synthesize thisBatchCode; // 期号
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code】
          }
    return self;
}

- (void)dealloc
{
    [numDataArray release],numDataArray =nil;
    [basketView release];
    [basketBetView release];
    [basketChaseView release];
    [basketTogethoerView release];
    [basketSendView release];
    [numTableView release];
    [numDataArray release];
    
    self.delegate = nil;
    [lotNo release],lotNo = nil;
    [thisBatchCode release],thisBatchCode = nil;
    
    [super dealloc];
}


#pragma mark ================= view 
/* 号码篮 */
#define TagItemButton100 100
- (void)pickNumberBasketViewItem:(NSArray *)itemArray
{
    //号码篮 整体视图
    basketView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 308, 460)];
    basketView.contentSize = CGSizeMake(308, 460);
    basketView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self addSubview:basketView];
    
    //投注类型 按钮
    UIImageView * itemBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, basketView.frame.size.width, 40)];
    itemBackImg.image = RYCImageNamed(@"basketBg.png");
    [basketView addSubview:itemBackImg];
    [itemBackImg release];
    CGFloat width = basketView.frame.size.width/itemArray.count ;
    for (int i=0; i<itemArray.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width*i, 2, width, 40);
        [btn setBackgroundImage:RYCImageNamed(@"basketSelect.png") forState:UIControlStateSelected];
        if (i==0) {
            btn.selected = YES;
        }
        btn.tag = TagItemButton100  + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(basketKindButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[itemArray objectAtIndex:i] forState:UIControlStateNormal];
        [basketView addSubview:btn];
    }
    
    UIButton  * tableButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tableButton.frame = CGRectMake(10, 45, basketView.frame.size.width-20, 35);
    [tableButton setBackgroundImage:RYCImageNamed(@"basketTableOpen.png") forState:btnNormal];
    [tableButton setBackgroundImage:RYCImageNamed(@"basketTableClose.png") forState:UIControlStateHighlighted];
    [tableButton addTarget:self action:@selector(basketTableButtonAction:) forControlEvents:btnTouch];
    [basketView addSubview:tableButton];
    
    UILabel * titLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 55, 100, 20)];
    titLabel.backgroundColor  = [UIColor clearColor];
    titLabel.text = @"号码篮";
    [basketView addSubview:titLabel];
    [titLabel release];
    
    self.numDataArray       = [[NSMutableArray alloc]init];
    //号码显示 列表   
    numTableView            = [[UITableView alloc]initWithFrame:CGRectMake(10, 80, basketView.frame.size.width-20, 260) style:UITableViewStylePlain];
    numTableView.delegate   = self;
    numTableView.dataSource = self;
    numTableView.rowHeight  = 50;
    [basketView addSubview:numTableView];
    
    // 投注
    basketBetView = [[UIView alloc]initWithFrame:CGRectMake(0, 350, basketView.frame.size.width, 60)];
    [basketView addSubview:basketBetView];
    [self mulViewAddToView:basketBetView];
    // 追号
    basketChaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 355, basketView.frame.size.width, 300)];
    [self mulViewAddToView:basketChaseView];
    [self stageViewAddToView:basketChaseView];
    
    //合买
    basketTogethoerView =[[UIView alloc]initWithFrame:CGRectMake(0, 355, basketView.frame.size.width, 400)];
    [self mulViewAddToView:basketTogethoerView];
    [self mulViewTogetherView:basketTogethoerView];
    
    //赠送
    basketSendView = [[UIView alloc]initWithFrame:CGRectMake(0, 355, basketView.frame.size.width, 300)];
    [self mulViewAddToView:basketSendView];
    [self sendViewAddToView:basketSendView];
    
    [self pickNumBuyView];
}
/*  倍数 */
//MARK: 倍数tag
#define TagMulCutButton540 540
#define TagMulTextField530 530
#define TagMulAddButton541 541

- (void)mulViewAddToView:(UIView *)betView
{
    UIView* mulView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, basketView.frame.size.width, 30)];
    mulView.backgroundColor = [UIColor clearColor];
    [betView addSubview:mulView];
    [mulView release];
    
    UILabel * titLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 35, 20)];
    titLabel.text = @"倍数";
    titLabel.backgroundColor = [UIColor clearColor];
    [mulView addSubview:titLabel];
    [titLabel release];
    
    UIButton * cutBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setImage:RYCImageNamed(@"jian_normal.png") forState:UIControlStateNormal];
    [cutBtn setImage:RYCImageNamed(@"jian_click.png") forState:UIControlStateHighlighted];
    cutBtn.frame = CGRectMake(titLabel.frame.size.width+15 ,0, 30, 30);
    cutBtn.tag = TagMulCutButton540;
    [cutBtn addTarget:self action:@selector(mulViewCutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [mulView addSubview:cutBtn];
    
    mulCount =1;
    betType = @"1";

    UITextField * mulTextField =[[UITextField alloc]initWithFrame:CGRectMake(cutBtn.frame.origin.x + cutBtn.frame.size.width+5, 2, 70, 26)];
    mulTextField.tag = TagMulTextField530;
    mulTextField.text = [NSString stringWithFormat:@"%d",mulCount];
    mulTextField.borderStyle = UITextBorderStyleLine;
    mulTextField.delegate = self;
    [mulView addSubview:mulTextField];
    [mulTextField release];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:RYCImageNamed(@"jia_normal.png") forState:UIControlStateNormal];
    [addBtn setImage:RYCImageNamed(@"jia_click.png") forState:UIControlStateHighlighted];
    addBtn.frame = CGRectMake(mulTextField.frame.origin.x+mulTextField.frame.size.width+5, cutBtn.frame.origin.y, 30, 30);
    addBtn.tag = TagMulAddButton541;
    [addBtn addTarget:self action:@selector(mulViewAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [mulView addSubview:addBtn];
    
    UILabel * signLabel =[[UILabel alloc]initWithFrame:CGRectMake(addBtn.frame.origin.x+addBtn.frame.size.width, titLabel.frame.origin.y, 120, 20)];
    signLabel.backgroundColor =[UIColor clearColor];
    signLabel.text = [NSString stringWithFormat:@"(最高%d倍)",BetMaxMulCount];
    [mulView addSubview:signLabel];
    [signLabel release];
    
}
/* 期数 */
#define TagStageCutButton542 542
#define TagStageTextField531  531
#define TagStageAddButton543 543

- (void)stageViewAddToView:(UIView *)view
{
    UIView *stageView   =[[UIView alloc]initWithFrame:CGRectMake(0, 35, view.frame.size.width, 200)];
    [view  addSubview:stageView];
    [stageView release];
    
    UILabel * titLabel          =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 35, 20)];
    titLabel.backgroundColor    = [UIColor clearColor];
    titLabel.text               = @"期数";
    [stageView addSubview:titLabel];
    [titLabel release];
    
    UIButton * cutBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setImage:RYCImageNamed(@"jian_normal.png") forState:UIControlStateNormal];
    [cutBtn setImage:RYCImageNamed(@"jian_click.png") forState:UIControlStateHighlighted];
    cutBtn.frame        = CGRectMake(titLabel.frame.size.width+15 ,0, 30, 30);
    cutBtn.tag          = TagStageCutButton542;
    [cutBtn addTarget:self action:@selector(mulViewCutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [stageView addSubview:cutBtn];
    
    UITextField * mulTextField  = [[UITextField alloc]initWithFrame:CGRectMake(cutBtn.frame.origin.x + cutBtn.frame.size.width+5, 2, 70, 26)];
    stageCount                  = 5;
    mulTextField.text           = [NSString stringWithFormat:@"%d",stageCount];
    mulTextField.borderStyle    = UITextBorderStyleLine;
    mulTextField.delegate       = self;
    mulTextField.tag            = TagStageTextField531;
    [stageView addSubview:mulTextField];
    [mulTextField release];
    
    UIButton * addBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:RYCImageNamed(@"jia_normal.png") forState:UIControlStateNormal];
    [addBtn setImage:RYCImageNamed(@"jia_click.png") forState:UIControlStateHighlighted];
    addBtn.frame                = CGRectMake(mulTextField.frame.origin.x+mulTextField.frame.size.width+5, cutBtn.frame.origin.y, 30, 30);
    [addBtn addTarget:self action:@selector(mulViewAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag                  = TagStageAddButton543;
    [stageView addSubview:addBtn];
    
    UILabel * signLabel         = [[UILabel alloc]initWithFrame:CGRectMake(addBtn.frame.origin.x+addBtn.frame.size.width, titLabel.frame.origin.y, 120, 20)];
    signLabel.backgroundColor   = [UIColor clearColor];
    signLabel.text              = [NSString stringWithFormat:@"(最多%d期)",BetMaxStageCount];
    [stageView addSubview:signLabel];
    [signLabel release];
    
    UILabel * winLabel          = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 150, 20)];
    winLabel.backgroundColor    = [UIColor clearColor];
    winLabel.text               = @"中奖后停止追号";
    [stageView addSubview:winLabel];
    [winLabel release];
    
    
    isPrizeend = @"1";
    UISwitch * winSwitch =[[UISwitch alloc]initWithFrame:CGRectMake(220, winLabel.frame.origin.y, 70, 25)];
    winSwitch.on = YES;
    [winSwitch addTarget:self action:@selector(mulViewWinSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [stageView addSubview:winSwitch];
    [winSwitch release];
    
    
    
//    stageTableView =[[SetChaseStageTableView alloc]initWithFrame:CGRectMake(5, 65, 280, 200)];
//    stageTableView.batchLotNo = lotNo;
//    stageTableView.stageNumber = thisBatchCode;
//    [stageView addSubview:stageTableView];
//    [stageTableView release];
}
/* 合买 */
#define TagSubTextField409 409
#define TagSubPerLabel410 410
#define TagDocumentTextField411 411
#define TagMinTextField412 412
#define TagMinPerLabel413  413
#define TagSumTureButton414 414
#define TagSumFalseButton415 415

#define TagDeductButton408 408
#define TagOpenButton500 500
#define TagDesTextView416 416
- (void)mulViewTogetherView:(UIView *)cooperationBetView
{
    /* 认购 */
    UILabel * subLabel          = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 90, 25)];
    subLabel.text               = @"我要认购：";
    subLabel.backgroundColor    = [UIColor clearColor];
    [cooperationBetView addSubview:subLabel];
    [subLabel release];

    
    buyAmt = 1;
    allCostMoney = 0;
    UITextField *subTextField   = [[UITextField alloc]initWithFrame:CGRectMake(subLabel.frame.origin.x + subLabel.frame.size.width, subLabel.frame.origin.y, 50, 25)];
    subTextField.text           = [NSString stringWithFormat:@"%d",buyAmt];
    subTextField.tag            = TagSubTextField409;
    subTextField.delegate       = self;
    subTextField.borderStyle    = UITextBorderStyleLine;
    [cooperationBetView addSubview:subTextField];
    [subTextField release];
    
    UILabel *yuanLabel          = [[UILabel alloc]initWithFrame:CGRectMake(subTextField.frame.origin.x + subTextField.frame.size.width, subTextField.frame.origin.y, 20, 25)];
    yuanLabel.text              = @"元";
    yuanLabel.backgroundColor   =[UIColor clearColor];
    
    [cooperationBetView addSubview:yuanLabel];
    [yuanLabel release];
    
    UILabel *subPerLabel        =[[UILabel alloc]initWithFrame:CGRectMake(subTextField.frame.origin.x + subTextField.frame.size.width+30, subTextField.frame.origin.y, 150, 25)];
    subPerLabel.backgroundColor =[UIColor clearColor];
    subPerLabel.tag             = TagSubPerLabel410;
    subPerLabel.text            = [NSString stringWithFormat:@"占总额%.2f%%",0.0];
    [cooperationBetView addSubview:subPerLabel];
    [subPerLabel release];
    
    /* 跟单 */
    UILabel *documentaryLabel   =[[UILabel alloc]initWithFrame:CGRectMake(10, subLabel.frame.origin.y + 30, 90, 25)];
    documentaryLabel.text       = @"最低跟单:";
    documentaryLabel.backgroundColor =[UIColor clearColor];
    [cooperationBetView addSubview:documentaryLabel];
    [documentaryLabel release];
    
    minAmt =1;
    UITextField *documentaryTextfField  =[[UITextField alloc]initWithFrame:CGRectMake(documentaryLabel.frame.origin.x + documentaryLabel.frame.size.width, documentaryLabel.frame.origin.y, 50, 25)];
    documentaryTextfField.text          = [NSString stringWithFormat:@"%d",minAmt];
    documentaryTextfField.delegate      = self;
    documentaryTextfField.tag           = TagDocumentTextField411;
    documentaryTextfField.borderStyle   = UITextBorderStyleLine;
    [cooperationBetView addSubview:documentaryTextfField];
    [documentaryTextfField release];
    
    UILabel *yuanLabel1                 = [[UILabel alloc]initWithFrame:CGRectMake(documentaryTextfField.frame.origin.x + documentaryTextfField.frame.size.width, documentaryTextfField.frame.origin.y, 20, 25)];
    yuanLabel1.text                     = @"元";
    yuanLabel1.backgroundColor          = [UIColor clearColor];
    [cooperationBetView addSubview:yuanLabel1];
    [yuanLabel1 release];
    

    /* 我要保底 */
    UILabel * minLabel                  = [[UILabel alloc]initWithFrame:CGRectMake(10, documentaryLabel.frame.origin.y+30, 90, 25)];
    minLabel.text                       = @"我要保底:";
    minLabel.backgroundColor            =[UIColor clearColor];
    [cooperationBetView addSubview:minLabel];
    [minLabel release];
    
    safeAmt = 0;
    UITextField * minTextField      =[[UITextField alloc]initWithFrame:CGRectMake(minLabel.frame.origin.x + minLabel.frame.size.width, minLabel.frame.origin.y, 50, 25)];
    minTextField.text               = [NSString stringWithFormat:@"%d",safeAmt];
    minTextField.borderStyle        = UITextBorderStyleLine;
    minTextField.delegate           = self;
    minTextField.tag                = TagMinTextField412;
    [cooperationBetView addSubview:minTextField];
    [minTextField release];
    
    UILabel * yuanlabel2            = [[UILabel alloc]initWithFrame:CGRectMake(minTextField.frame.origin.x +minTextField.frame.size.width, minLabel.frame.origin.y, 20, 25)];
    yuanlabel2.text                 = @"元";
    yuanlabel2.backgroundColor      = [UIColor clearColor];
    [cooperationBetView addSubview:yuanlabel2];
    [yuanlabel2 release];
    
    UILabel* minPerLabel =[[UILabel alloc]initWithFrame:CGRectMake(minTextField.frame.origin.x + minTextField.frame.size.width +30, minTextField.frame.origin.y, 150, 25)];
    minPerLabel.backgroundColor =[UIColor clearColor];
    
    minPerLabel.text =  [NSString stringWithFormat:@"占总额%.2f%%",0.0];
    minPerLabel.tag = TagMinPerLabel413;
    [cooperationBetView addSubview:minPerLabel];
    [minPerLabel release];
    

    /* 全额保底*/
    UILabel *sumLabel           =[[UILabel alloc]initWithFrame:CGRectMake(minLabel.frame.origin.x, minLabel.frame.origin.y+30, 90, 25)];
    sumLabel.text               = @"全额保底:";
    sumLabel.backgroundColor    =[UIColor clearColor];
    [cooperationBetView addSubview:sumLabel];
    [sumLabel release];
    
    isSumTure                   = NO;
    UIButton *sumBtnT           = [UIButton buttonWithType:UIButtonTypeCustom];
    sumBtnT.frame               = CGRectMake(sumLabel.frame.origin.x+sumLabel.frame.size.width, sumLabel.frame.origin.y+2, 20, 20);
    [sumBtnT setImage:[UIImage imageNamed:@"mode_nomal.png"] forState:UIControlStateNormal];
    [sumBtnT addTarget:self action:@selector(sumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sumBtnT.tag                 = TagSumTureButton414;
    [cooperationBetView addSubview:sumBtnT];
    
    UILabel *nanLabel           = [[UILabel alloc]initWithFrame:CGRectMake(sumBtnT.frame.origin.x+sumBtnT.frame.size.width, sumBtnT.frame.origin.y, 25, 20)];
    nanLabel.text               = @"是";
    nanLabel.backgroundColor    = [UIColor clearColor];
    [cooperationBetView addSubview:nanLabel];
    [nanLabel release];
    
    UIButton *sumBtnF           = [UIButton buttonWithType:UIButtonTypeCustom];
    sumBtnF.frame               = CGRectMake(nanLabel.frame.origin.x+nanLabel.frame.size.width+10, sumBtnT.frame.origin.y,20, 20);
    [sumBtnF setImage:[UIImage imageNamed:@"mode_select.png"] forState:UIControlStateNormal];
    [sumBtnF addTarget:self action:@selector(sumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sumBtnF.tag                 = TagSumFalseButton415;
    [cooperationBetView addSubview:sumBtnF];
    
    UILabel *wenLabel           = [[UILabel alloc]initWithFrame:CGRectMake(sumBtnF.frame.origin.x+sumBtnF.frame.size.width, sumBtnF.frame.origin.y, 25, 20)];
    wenLabel.text               = @"否";
    wenLabel.backgroundColor    = [UIColor clearColor];
    [cooperationBetView addSubview:wenLabel];
    [wenLabel release];
    /* 我的提成 */
    UILabel *deductLabel        = [[UILabel alloc]initWithFrame:CGRectMake(sumLabel.frame.origin.x, sumLabel.frame.origin.y+30, sumLabel.frame.size.width, 25)];
    deductLabel.text            = @"我的提成:";
    deductLabel.backgroundColor =[UIColor clearColor];
    [cooperationBetView addSubview:deductLabel];
    [deductLabel release];
    
    commisionRation             = @"10";
    UIButton *deductButton      = [UIButton buttonWithType:UIButtonTypeCustom];
    deductButton.frame          = CGRectMake(deductLabel.frame.origin.x + deductLabel.frame.size.width, deductLabel.frame.origin.y, 100, 25);
    deductButton.tag            = TagDeductButton408;
    [deductButton setTitleColor:[UIColor blackColor] forState:btnNormal];
    [deductButton setBackgroundImage:RYCImageNamed(@"select_long_click.png") forState:btnNormal];
    [deductButton addTarget:self action:@selector(deductButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [deductButton setTitle:commisionRation forState:UIControlStateNormal];
    [cooperationBetView addSubview:deductButton];
    
    UILabel * perLabel          =[[UILabel alloc]initWithFrame:CGRectMake(deductButton.frame.origin.x+deductButton.frame.size.width+10, deductButton.frame.origin.y, 35, 25)];
    perLabel.text               = @"%";
    perLabel.font               = [UIFont boldSystemFontOfSize:20];
    perLabel.backgroundColor    = [UIColor clearColor];
    [cooperationBetView addSubview:perLabel];
    [perLabel release];
    
    /* 是否公开 */
    UILabel *openLabel          = [[UILabel alloc]initWithFrame:CGRectMake(deductLabel.frame.origin.x, deductLabel.frame.origin.y+30, deductLabel.frame.size.width, 25)];
    openLabel.text              = @"是否公开:";
    openLabel.backgroundColor   = [UIColor clearColor];
    [cooperationBetView addSubview:openLabel];
    [openLabel release];
    NSArray * openArr           = [[NSArray alloc]initWithObjects:@"对所有人公开",@"对跟单者立即公开",@"对所有人截止后公开",@"对跟单者截止后公开",@"保密", nil];
   
    for (int i= 0; i<openArr.count;i++) {
        
        UIButton * openButton   = [UIButton buttonWithType:UIButtonTypeCustom];
        openButton.frame        = CGRectMake(openLabel.frame.origin.x + openLabel.frame.size.width, openLabel.frame.origin.y +5+(30*i), 20, 20);
        if (i==0) {
            [openButton setImage:[UIImage imageNamed:@"mode_select.png"] forState:UIControlStateNormal];
        }else{
            [openButton setImage:[UIImage imageNamed:@"mode_nomal.png"] forState:UIControlStateNormal];
        }
        openButton.tag          = TagOpenButton500 +i;
        [openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cooperationBetView addSubview:openButton];
        
        UILabel *arrLabel       = [[UILabel alloc]initWithFrame:CGRectMake(openButton.frame.origin.x + openButton.frame.size.width, openButton.frame.origin.y, 200, 20)];
        arrLabel.text           = [openArr objectAtIndex:i];
        arrLabel.backgroundColor =[UIColor clearColor];
        [cooperationBetView addSubview:arrLabel];
        [arrLabel release];
    }
    
    [openArr release];

    /*  方案描述  */
    UILabel * desLabel          = [[UILabel alloc]initWithFrame:CGRectMake(openLabel.frame.origin.x, openLabel.frame.origin.y + 30*5, openLabel.frame.size.width, 25)];
    desLabel.text               = @"方案描述:";
    desLabel.backgroundColor    = [UIColor clearColor];
    [cooperationBetView addSubview:desLabel];
    [desLabel release];
    
    UITextView *desTextView     = [[UITextView alloc]initWithFrame:CGRectMake(desLabel.frame.origin.x + desLabel.frame.size.width, desLabel.frame.origin.y, 150, 60)];
    desTextView.font            = [UIFont systemFontOfSize:17];
    desTextView.backgroundColor = [UIColor whiteColor];
    desTextView.tag             = TagDesTextView416;
    desTextView.delegate        = self;
    desTextView.editable        = YES;
    [cooperationBetView addSubview:desTextView];
    [desTextView release];
}
/* 赠送View */
#define  TagContantTextView406 406
#define  TagPtesTextView407 407
- (void)sendViewAddToView:(UIView *)giveView
{
    //  联系方式 
    UILabel *contactLabel       =[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 250, 50)];
    contactLabel.text           = @"朋友联系方式(多个联系人之间用逗号分隔)";
    contactLabel.numberOfLines  = 0;
    contactLabel.backgroundColor = [UIColor clearColor];
    [giveView addSubview:contactLabel];
    [contactLabel release];

  
    UITextView *contactTextView =[[UITextView alloc]initWithFrame:CGRectMake(contactLabel.frame.origin.x, contactLabel.frame.origin.y +50, 250, 80)];
    contactTextView.font        =[UIFont systemFontOfSize:17];
    contactTextView.delegate    = self;
    contactTextView.tag         = TagContantTextView406;
    [giveView addSubview:contactTextView];
    [contactTextView release];
    // 赠言
    UILabel * presLabel         =[[UILabel alloc]initWithFrame:CGRectMake(contactTextView.frame.origin.x, contactTextView.frame.origin.y+contactTextView.frame.size.height, 200, 25)];
    presLabel.text              = @"您的赠言:(可不填)";
    presLabel.backgroundColor   = [UIColor clearColor];
    [giveView addSubview:presLabel];
    [presLabel release];
    UITextView * presTextView   = [[UITextView alloc]initWithFrame:CGRectMake(presLabel.frame.origin.x, presLabel.frame.origin.y +30, 250, 100)];
    presTextView.font           = [UIFont systemFontOfSize:17];
    presTextView.delegate       = self;
    presTextView.editable       = YES;
    presTextView.tag            = TagPtesTextView407;
    [giveView addSubview:presTextView];
    [presTextView release];
}
/* 购买 */
- (void)pickNumBuyView
{
    UIView *  PickBuyView =[[UIView alloc]initWithFrame:CGRectMake(0, 460, 308, 114)];
    PickBuyView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self addSubview:PickBuyView];
    [PickBuyView release];
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PickBuyView.frame.size.width, 2)];
    lineV.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [PickBuyView addSubview:lineV];
    [lineV release];
#define TagAllCostLabel 421
    allCount = 0;
    UILabel * allCostLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 25)];
    allCostLabel.backgroundColor = [UIColor clearColor];
    allCostLabel.tag = TagAllCostLabel;
    allCostLabel.font = [UIFont boldSystemFontOfSize:19];
    allCostLabel.text = [NSString stringWithFormat:@"共 %d 注  总金额: %d元",allCount,allCount*2];
    [PickBuyView addSubview:allCostLabel];
    [allCostLabel release];
    
    UIView * lineV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 38, PickBuyView.frame.size.width, 2)];
    lineV1.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [PickBuyView addSubview:lineV1];
    [lineV1 release];
#define TagBuyButton422 422
    UIButton * buyButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setBackgroundImage:RYCImageNamed(@"buyNormal.png") forState:UIControlStateNormal];
    [buyButton setBackgroundImage:RYCImageNamed(@"buyClick.png") forState:UIControlStateHighlighted];
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    buyButton.tag = TagBuyButton422;
    buyButton.frame = CGRectMake(75, 55, 144, 46);
    [buyButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(pickNumBuyButtonAction:) forControlEvents:btnTouch];
    [PickBuyView addSubview:buyButton];
}
#pragma mark ====================     public

- (void)pickTableViewArrayAddItem:(NSDictionary *)item
{
    [self.numDataArray addObject:item];
    DLog(@"self.numberDataArray %@",numDataArray);
    [numTableView reloadData];
    [self numberAllCostLabelAfresh];
}
- (void)getThisLotNoString:(NSString *)lotNoStr andThisBatchString:(NSString *)batchCode
{
    self.lotNo = lotNoStr;
    self.thisBatchCode = batchCode;
    
    stageTableView.batchLotNo = lotNoStr;
    stageTableView.stageNumber = batchCode;
}
#pragma mark ========== methods
- (void)basketTableButtonAction:(id)sender
{
    
}
/* 号码篮 投注分类 */
- (void)basketKindButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    [self refreshButtonImg:button.tag];
    
    UIButton *buyButton = (UIButton *)[self viewWithTag:TagBuyButton422];
    switch (button.tag - TagItemButton100) {
        case 0://投注
        {
            [basketChaseView removeFromSuperview];
            [basketTogethoerView removeFromSuperview];
            [basketSendView removeFromSuperview];
            [basketView addSubview:basketBetView];
            betType = @"1";
            basketView.contentSize = CGSizeMake(300, 460);
            [buyButton setTitle:@"立即购买" forState:btnNormal];
            
        }
            break;
        case 1://追号
        {
            [basketBetView removeFromSuperview];
            [basketTogethoerView removeFromSuperview];
            [basketSendView removeFromSuperview];
            [basketView addSubview:basketChaseView];
            basketView.contentSize = CGSizeMake(300, 660);
            [buyButton setTitle:@"立即购买" forState:btnNormal];
            betType = @"2";
            stageCount = 5;
            UITextField * mulTextField = (UITextField *)[self viewWithTag:TagStageTextField531];
            mulTextField.text           = [NSString stringWithFormat:@"%d",stageCount];
            
        }
            break;
        case 2://合买
        {
            [basketBetView removeFromSuperview];
            [basketChaseView removeFromSuperview];
            [basketSendView removeFromSuperview];
            [basketView addSubview:basketTogethoerView];
            [buyButton setTitle:@"发起合买" forState:btnNormal];
            betType = @"3";
            basketView.contentSize = CGSizeMake(300, 760);
            
        }
            break;
        case 3://赠送
        {
            [basketBetView removeFromSuperview];
            [basketTogethoerView removeFromSuperview];
            [basketChaseView removeFromSuperview];
            [basketView addSubview:basketSendView];
            [buyButton setTitle:@"立即赠送" forState:btnNormal];
            betType = @"4";
            basketView.contentSize = CGSizeMake(300, 660);
            
            
        }
            break;
        default:
            break;
    }
    mulCount = 1;
    UITextField *mulTextField = (UITextField *)[self viewWithTag:TagMulTextField530];
    mulTextField.text = [NSString stringWithFormat:@"%d",mulCount];
    [self numberAllCostLabelAfresh];
    
}
- (void)refreshButtonImg:(int)buttpnTag
{
    for (int i = 0; i < 4; i++) {
        UIButton* tempButton = (UIButton*)[self viewWithTag:TagItemButton100 + i];
        if (buttpnTag == tempButton.tag) {
            tempButton.selected = YES;
        }
        else
            tempButton.selected = NO;
    }
}

/* 总注数显示 更新数据 */
- (void)numberAllCostLabelAfresh
{
    UILabel * label =(UILabel *)[self viewWithTag:TagAllCostLabel];
    allCount = 0;
    for (int i=0; i<numDataArray.count; i++) {
        NSDictionary * dic =[numDataArray objectAtIndex:i];
        int count = [[dic objectForKey:@"count"]intValue];
        allCount +=count;
    }
    allCostMoney=0;
    if ([betType isEqualToString:@"2"])
    {
        allCostMoney = allCount*mulCount*stageCount*2;
    }else{
         allCostMoney = allCount*mulCount*2;
    }
    label.text = [NSString stringWithFormat:@"共 %d 注  总金额%d元",allCount,allCostMoney];
    
    [self togetherPerLabelAfresh];
}
- (void)togetherPerLabelAfresh   // 占总额的比例
{
    if (!allCostMoney>0) {
        return;
    }
    UILabel * subPerLabel = (UILabel *)[self viewWithTag:TagSubPerLabel410];
    UILabel * minPerLabel = (UILabel *)[self viewWithTag:TagMinPerLabel413];
    DLog( @"1111%d 222%d 333 %d",buyAmt,safeAmt,allCostMoney);
    
    subPerLabel.text = [NSString stringWithFormat:@"%.2f%%",(buyAmt*1.0/allCostMoney)*100];
    minPerLabel.text = [NSString stringWithFormat:@"%.2f%%",(safeAmt*1.0)/allCostMoney*100];
    
}
#define TagTicketAlert600 600
/* 购买 */
- (void)pickNumBuyButtonAction:(id)sender
{
    DLog(@"self.thisBatchCode %@",self.thisBatchCode);
    if (self.thisBatchCode == nil) {
        [self showAlertWithMessage:@"期号获取失败！"];
        return;
    }
    if (numDataArray.count>0)
    {
        if ([betType isEqualToString:@"3"]) {//合买
            if (buyAmt == 0 && safeAmt == 0) {
                [self showAlertWithMessage:@"认购金额和保底金额不能同时为0"];
                return;
            }
        }
        if ([self.delegate isPickNumCanBuy]) {//是否登陆
            
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"订单确认" message:@"确认支付本次投注的彩票？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认支付", nil];
            alert.tag = TagTicketAlert600;
            [alert show];
            [alert release];
        }else{
            
        }
        
    }else
    {
         [self showAlertWithMessage:@"请至少选择一注进行投注"];
    }
   
}
#pragma mark ------------------ alertView
//{"imei":"","bettype":"bet","softwareversion":"4.1.0","batchnum":"5","oneAmount":"200","lotno":"F47104","amount":"1000","machineid":"iPhone Simulator","isCompress":"1","coopid":"793","mac":"10:DD:B1:C7:F8:C2","lotmulti":"5","isSellWays":"1","phonenum":"11111111111","batchcode":"2013247","subscribeInfo":"","prizeend":"1","platform":"iPhone","userno":"00000177","bet_code":"0001161921222633~03^_5_200_200","imsi":"","command":"betLot"}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TagTicketAlert600) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            NSMutableDictionary* wapDic = [[NSMutableDictionary alloc] initWithCapacity:1];//跳转到浏览器的dic
            NSMutableArray * array =[[[NSMutableArray alloc]init]autorelease];
            for (int i=0; i<numDataArray.count; i++) {
                NSDictionary *dic   =[numDataArray objectAtIndex:i];
                int count           = [KISDictionaryHaveKey(dic, @"count") intValue];
                NSString *string    = KISDictionaryHaveKey(dic, @"codeString");
                NSString *code      =nil;
                code = [NSString stringWithFormat:@"%@_%d_200_%d",string,mulCount,count*200];
                [array addObject:code];
                
            }
            NSString *betCode = [array componentsJoinedByString:@"!"];
            NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
            [mDic setObject:@"betLot" forKey:@"command"];
            [mDic setObject:betCode forKey:@"bet_code"];
            [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
            [mDic setObject:self.thisBatchCode forKey:@"batchcode"];
            [mDic setObject:self.lotNo forKey:@"lotno"];
            [mDic setObject:[NSString stringWithFormat:@"%d",mulCount]
                     forKey:@"lotmulti"];
            [mDic setObject:@"200" forKey:@"oneAmount"];
            [mDic setObject:@"1" forKey:@"isSellWays"];
            [mDic setObject:[NSString stringWithFormat:@"%d",200*allCount*mulCount] forKey:@"amount"];
            
            [wapDic addEntriesFromDictionary:mDic];

            switch ([betType intValue]) {
                case 1: //  投注
                case 2: // 追号
                {
                    [mDic setObject:@"bet" forKey:@"bettype"];
                   
                    if ([betType isEqualToString:@"2"]) {
                       
                        [mDic setObject:[NSString stringWithFormat:@"%d",stageCount] forKey:@"batchnum"];
                        
                    }else{
                        
                        [mDic setObject:@"1" forKey:@"batchnum"];
                    }
                    [mDic setObject:isPrizeend forKey:@"prizeend"];
                    [mDic setObject:@"" forKey:@"subscribeInfo"];
                    
                }
                    break;
                case 3: //  合买
                {
                    [mDic setObject:@"startcase" forKey:@"bettype"];
                    [mDic setObject:[NSString stringWithFormat:@"%d",safeAmt*100] forKey:@"safeAmt"];
                    [mDic setObject:[NSString stringWithFormat:@"%d",buyAmt*100] forKey:@"buyAmt"];
                    [mDic setObject:[NSString stringWithFormat:@"%d",minAmt*100] forKey:@"minAmt"];
                    [mDic setObject:[(UITextField*)[basketTogethoerView viewWithTag:TagDesTextView416] text] forKey:@"description"];
                    [mDic setObject:commisionRation forKey:@"commisionRation"];//提成                   
                    int visible = 0;
                    switch (openState)
                    {
                        case 0:
                            visible = 0;
                            break;
                        case 1:
                            visible = 3;
                            break;
                        case 2:
                            visible = 2;
                            break;
                        case 3:
                            visible = 4;
                            break;
                        case 4:
                            visible = 1;
                            break;
                        default:
                            break;
                    }
                    [mDic setObject:[NSString stringWithFormat:@"%d",visible] forKey:@"visibility"];//是否公开
                  
                }
                    break;
                case 4:
                {
                    [mDic setObject:@"gift" forKey:@"bettype"];
                    UITextView * contText = (UITextView *)[self viewWithTag:TagContantTextView406];
                    [mDic setObject:contText.text forKey:@"to_mobile_code"];
                    UITextView * pstText = (UITextView *)[self viewWithTag:TagPtesTextView407];
                    [mDic setObject:pstText.text forKey:@"blessing"];
                }
                    break;
                default:
                    break;
            }
            NSString* phoneName = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveUserNameKey];

            if(phoneName && [phoneName isEqualToString:@"15847754382"])
            {
                [wapDic setObject:@"bet" forKey:@"bettype"];
                if ([betType isEqualToString:@"2"]) {
                    
                    [wapDic setObject:[NSString stringWithFormat:@"%d",stageCount] forKey:@"batchnum"];
                    
                }else{
                    
                    [wapDic setObject:@"1" forKey:@"batchnum"];
                }
                [self wapPageBuild:wapDic];
                [wapDic release];
            }
            else
            {
                [RYCNetworkManager sharedManager].netDelegate = self;
                [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeSubmitLot showProgress:YES];
            }
        }
    }
}

- (void)wapPageBuild:(NSDictionary*)mDict
{
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    NSString *AESstring = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding] ;
    
    NSMutableString *sendStr = [NSMutableString stringWithFormat:
                                @"%@",kRuYiCaiBetSafari];
    NSString *allStr = [sendStr stringByAppendingString:AESstring];
    NSLog(@"safari:%@ ", allStr);
    
    NSString *strUrl = [allStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    [[UIApplication sharedApplication] openURL:url];
}

// 合买  /* 发起合买 */
#pragma mark   --------------- notifiction
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeSubmitLot:
        {
            [self betLoteryRequestTidy:dataDic];
        }
            break;
        default:
            break;
    }
}
- (void)betLoteryRequestTidy:(NSDictionary *)mDic
{
    NSString * errorCode = KISDictionaryHaveKey(mDic, @"error_code");
    NSString * message = KISDictionaryHaveKey(mDic, @"message");
    if ([errorCode isEqualToString:@"0000"]) {
        [self.numDataArray removeAllObjects];
        [numTableView reloadData];
        [self numberAllCostLabelAfresh];
        [basketView setContentOffset:CGPointMake(0, 0) animated:YES];
          switch ([betType intValue]) {
              case 1:{
                  
              }
                  break;
                case 2:
              {
                  
              }
                  break;
                case 3:
              {
                  
              }
                  break;
                case 4:
              {
                  UITextView * contText = (UITextView *)[self viewWithTag:TagContantTextView406];
                  contText.text = @"";
                  UITextView * pstText = (UITextView *)[self viewWithTag:TagPtesTextView407];
                  pstText.text = @"";
              }
                  break;
          }
        
        [self showAlertWithMessage:message];
        
    }else{
        [self showAlertWithMessage:message];
    }
    
}
#pragma mark --- 倍数
/* 倍数减少 */
- (void)mulViewCutButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    if (TagMulCutButton540 == button.tag) {
        mulCount--;
        if (mulCount<1) {
            mulCount=1;
        }
        if (mulCount>BetMaxMulCount) {
            mulCount =BetMaxMulCount;
        }
        UITextField * mulTextField = (UITextField *)[self viewWithTag:TagMulTextField530];
        mulTextField.text = [NSString stringWithFormat:@"%d",mulCount];
    }
    if (TagStageCutButton542 == button.tag) {
        stageCount --;
        if (stageCount<1) {
            stageCount =1;
        }
        if (stageCount>BetMaxStageCount) {
            stageCount = BetMaxStageCount;
        }
        UITextField *stageTextField = (UITextField *)[self viewWithTag:TagStageTextField531];
        stageTextField.text = [NSString stringWithFormat:@"%d",stageCount];
    }
    [self numberAllCostLabelAfresh];
}
/* 倍数增加 */
- (void)mulViewAddButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    if (TagMulAddButton541 == button.tag) {
        mulCount++;
        if (mulCount>BetMaxMulCount) {
            mulCount = BetMaxMulCount;
        }
        UITextField * mulTextField = (UITextField *)[self viewWithTag:TagMulTextField530];
        mulTextField.text = [NSString stringWithFormat:@"%d",mulCount];
    }
    if (TagStageAddButton543 == button.tag) {
        stageCount ++;
        if (stageCount>BetMaxStageCount) {
            stageCount = BetMaxStageCount;
        }
        UITextField *stageTextField = (UITextField *)[self viewWithTag:TagStageTextField531];
        stageTextField.text = [NSString stringWithFormat:@"%d",stageCount];
    }
   
    [self numberAllCostLabelAfresh];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL) validateMobile:(NSString* )mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark ---- stage
/* 中奖后停止追号 开关*/
- (void)mulViewWinSwitchValueChanged:(id)sender
{
    UISwitch * mySwitch = (UISwitch *)sender;
    if (mySwitch.on) {
        isPrizeend = @"1";
    }else
    {
        isPrizeend = @"0";
    }
}
#pragma mark ---- cooptation
/* 公开程度 */
- (void)openButtonClick:(id)sender
{
    UIButton * btn= (UIButton*)sender;
    NSMutableArray * stateAry = [[NSMutableArray alloc]init];
    for (int i=0; i<5; i++) {
        if (btn.tag - TagOpenButton500 == i) {
            [stateAry addObject: @"1"];
            openState = i;
        }else{
            [stateAry addObject:@"0"];
        }
    }
    for (int i=0; i<stateAry.count; i++) {
        UIButton * button =(UIButton *)[self viewWithTag:TagOpenButton500+i];
        if ([[stateAry objectAtIndex:i]isEqualToString:@"1"]) {
            [button setImage:[UIImage imageNamed:@"mode_select.png"] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"mode_nomal.png"] forState:UIControlStateNormal];
            
        }
    }
    [stateAry release];
}
/* 全额保底 */
- (void)sumButtonClick:(id)sender
{
    if (!allCostMoney>0) {
        return;
    }
    UIButton *btn=(UIButton *)sender;
    UIButton *btnTrue = (UIButton *)[self viewWithTag:TagSumTureButton414];
    UIButton *btnFalse = (UIButton *)[self viewWithTag:TagSumFalseButton415];
    UITextField * textField = (UITextField *)[self viewWithTag:TagMinTextField412];

    if (TagSumTureButton414 == btn.tag) {
        [btnTrue setImage:[UIImage imageNamed:@"mode_select.png"] forState:UIControlStateNormal];
        [btnFalse setImage:[UIImage imageNamed:@"mode_nomal.png"] forState:UIControlStateNormal];
        isSumTure = YES;
            if (allCostMoney>0) {
                safeAmt = allCostMoney-buyAmt;
                textField.text = [NSString stringWithFormat:@"%d",safeAmt];
                textField.enabled = NO;
            }
        }else{
        [btnTrue setImage:[UIImage imageNamed:@"mode_nomal.png"] forState:UIControlStateNormal];
        [btnFalse setImage:[UIImage imageNamed:@"mode_select.png"] forState:UIControlStateNormal];
        isSumTure = NO;
        safeAmt = 0;
        textField.text = [NSString stringWithFormat:@"%d",safeAmt];
        textField.enabled = YES;
    }
    [self togetherPerLabelAfresh];
}
/* 我的提成比例调整 */
- (void)deductButtonClicked:(id)sender
{

    [basketView setContentOffset:CGPointMake(0, 300) animated:YES];
    
    PickerViewController * viewController =[[PickerViewController alloc]init];
    viewController.delegate = self;
    viewController.pViewWidch = 300;
    NSArray * array =[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10" ,nil];
    popover =[[UIPopoverController alloc]initWithContentViewController:viewController];
    popover.popoverContentSize = CGSizeMake(300, 200);
    [popover presentPopoverFromRect:CGRectMake(0, 40, 300, 200) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [viewController setPickerViewDataArray:array selectNum:1];
    [array release];
}
#pragma mark --------- pickerView
- (void)pickerViewController:(PickerViewController *)viewController selectRowNum:(NSString *)selectRow
{
    DLog(@"%@",selectRow);
    UIButton * btn=(UIButton *)[self viewWithTag:TagDeductButton408];
    [btn setTitle:selectRow forState:UIControlStateNormal];
    commisionRation = selectRow;
}
- (void)pickViewCancelClick
{
    [popover dismissPopoverAnimated:YES];
}
#pragma mark =================== textField delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (TagMulTextField530 == textField.tag) {
        if (textField.text.length >= 5 && range.length == 0)
        {
            return  NO;
        }
        else//只允许输入数字
        {
            NSCharacterSet *cs;
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
            
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            BOOL canChange = [string isEqualToString:filtered];
            
            return canChange;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //  视图调整
    if (TagMulTextField530 == textField.tag) {
        if ([betType isEqualToString:@"1"]) {
             basketView.contentSize = CGSizeMake(basketView.frame.size.width, basketView.frame.size.height+210);
        }
        [basketView setContentOffset:CGPointMake(0, 210) animated:YES];
    }else if (TagStageTextField531 == textField.tag)
    {
        basketView.contentSize = CGSizeMake(basketView.frame.size.width, basketView.frame.size.height+230);
        [basketView setContentOffset:CGPointMake(0, 230) animated:YES];
    }
    
    if (textField.tag == TagSubTextField409  )
    {
        [basketView setContentOffset:CGPointMake(0, 300) animated:YES];
    }else if (TagMinTextField412 == textField.tag){
        [basketView setContentOffset:CGPointMake(0, 360) animated:YES];
        
    }else if (TagDocumentTextField411 ==textField.tag)
    {
        [basketView setContentOffset:CGPointMake(0, 330) animated:YES];

    }
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    /*  判断是否为数字 */
    for (int i = 0; i < textField.text.length; i++)
    {
        if (textField.tag != TagMinTextField412) {
            UniChar chr = [textField.text characterAtIndex:i];
//            if ('0' == chr && 0 == i)
//            {
//                [self showAlertWithMessage:@"不能以0开头"];
//                textField.text = @"1";
//                
//            }
//            else
            if (chr < '0' || chr > '9')
            {
                [self showAlertWithMessage:@"必须为数字"];
                textField.text = @"1";
            }

        }
    }
    /* 视图变化 倍数 期数 */
    if (TagMulTextField530 == textField.tag||TagStageTextField531 == textField.tag) {
        if ([betType isEqualToString:@"1"] ) {
             basketView.contentSize = CGSizeMake(basketView.frame.size.width, basketView.frame.size.height);
        }else if ([betType isEqualToString:@"2"])
        {
             basketView.contentSize = CGSizeMake(basketView.frame.size.width, 660);
        }else if([betType isEqualToString:@"3"])
        {
            basketView.contentSize = CGSizeMake(basketView.frame.size.width, 760);
        }else if ([betType isEqualToString:@"4"])
        {
            basketView.contentSize = CGSizeMake(basketView.frame.size.width, 660);
        }
        [basketView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    /*  期数 倍数限制 */
     if (TagMulTextField530 == textField.tag)
        {
             if ([textField.text intValue]>BetMaxMulCount)
             {
                 mulCount = BetMaxMulCount;
                 textField.text = [NSString stringWithFormat:@"%d",mulCount];
                 [self showAlertWithMessage:[NSString stringWithFormat: @"倍数不能超过%d倍！",BetMaxMulCount]];
             }
            mulCount = [textField.text intValue];
        }
    if (TagStageTextField531 == textField.tag) {
        if ([textField.text intValue]>BetMaxStageCount) {
            stageCount = BetMaxStageCount;
            textField.text = [NSString stringWithFormat:@"%d",stageCount];
            [self showAlertWithMessage:[NSString stringWithFormat:@"期数最多不能超过%d期！",BetMaxStageCount]];
        }
        stageCount = [textField.text intValue];
    }
    /*   */
    if (TagSubTextField409 ==textField.tag || TagMinTextField412 == textField.tag || TagDocumentTextField411 == textField.tag) {
        basketView.contentSize = CGSizeMake(basketView.frame.size.width, 760);
        [basketView setContentOffset:CGPointMake(0, 300) animated:YES];

    }
    /* 认购 */
    if (TagSubTextField409 == textField.tag) {
        [basketView setContentOffset:CGPointMake(0, 300) animated:YES];
        
        buyAmt =[textField.text intValue] ;
        if (buyAmt >=allCostMoney &&allCostMoney>=0) {
            buyAmt = allCostMoney;
            textField.text = [NSString stringWithFormat:@"%d",buyAmt];
        }
        if (isSumTure) {
            UITextField * minTextF = (UITextField *)[self viewWithTag:TagMinTextField412];
            safeAmt = allCostMoney - buyAmt;
            minTextF.text = [NSString stringWithFormat:@"%d",safeAmt];
        }
    }
    /* 最低跟单 */
    if (TagDocumentTextField411 == textField.tag) {
        minAmt =[textField.text intValue];
        if (minAmt == 0) {
            [self showAlertWithMessage:@"最低跟单为1元"];
            minAmt = 1;
        }
        if (minAmt>=allCostMoney-buyAmt &&allCostMoney-buyAmt>=0) {
            minAmt =allCostMoney-buyAmt;
        }
        else if(allCostMoney-buyAmt<0)
        {
             minAmt = 1;
        }
        textField.text = [NSString stringWithFormat:@"%d",minAmt];
    }
    /* 我要保底 */
    if (TagMinTextField412 ==textField.tag) {
        safeAmt = [textField.text intValue];
        if (safeAmt>=allCostMoney-buyAmt && allCostMoney-buyAmt>0) {
            safeAmt = allCostMoney - buyAmt;
            textField.text = [NSString stringWithFormat:@"%d",safeAmt];
        }
    }
    [self numberAllCostLabelAfresh];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}
#pragma mark ------------------ textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == TagDesTextView416) {
        basketView.contentSize = CGSizeMake(basketView.frame.size.width, basketView.frame.size.height+610);
        [basketView setContentOffset:CGPointMake(0, 610) animated:YES];
    }else if (textView.tag == TagContantTextView406)
    {
        basketView.contentSize = CGSizeMake(basketView.frame.size.width, basketView.frame.size.height+310);
        [basketView setContentOffset:CGPointMake(0, 310) animated:YES];
    }else if (textView.tag == TagPtesTextView407)
    {
        basketView.contentSize = CGSizeMake(basketView.frame.size.width, basketView.frame.size.height+410);
        [basketView setContentOffset:CGPointMake(0, 410) animated:YES];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == TagDesTextView416) {
        basketView.contentSize = CGSizeMake(basketView.frame.size.width, 760);
        [basketView setContentOffset:CGPointMake(0, 300) animated:YES];
    }else if (textView.tag == TagContantTextView406 ||textView.tag == TagPtesTextView407 )
    {
        basketView.contentSize = CGSizeMake(basketView.frame.size.width, 660);
        [basketView setContentOffset:CGPointMake(0, 200) animated:YES];
    }

}
#pragma mark ===================  tableView delegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
//    label.backgroundColor = [UIColor clearColor];
//    label.text = @"号码篮";
//    return [label autorelease];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell = @"celled";
    PickNumberBasketTableCell * cell = [tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell = [[[PickNumberBasketTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (numDataArray.count !=0) {
        cell.cellContentDic = [numDataArray objectAtIndex:indexPath.row];
        cell.contentIndex = indexPath.row;
        cell.delegate = self;
        [cell basketTableCellRefresh];
    }
 
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//修改删除按钮的文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        [numDataArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [self numberAllCostLabelAfresh];
    }
}
- (void)deleteCellDataWithIndex:(int)cellIndex
{
    [numDataArray removeObjectAtIndex:cellIndex];
    [numTableView reloadData];
    [self numberAllCostLabelAfresh];
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
