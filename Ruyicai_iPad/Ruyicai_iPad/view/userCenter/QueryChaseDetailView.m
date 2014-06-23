//
//  QueryChaseDetailView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryChaseDetailView.h"
#define TagChaseLabel100 100


@implementation QueryChaseDetailView
@synthesize delegate;
@synthesize chaseModel;
@synthesize chaseDataAry;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        chaseScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, frame.size.width, frame.size.height-10)];
        chaseScroll.contentSize = CGSizeMake(frame.size.width, 700);
        [self queryChaseTitleView];
        [self queryChaseSchemeDetail];
        [self queryChaseSchemeContent];     //方案内容
        [self queryChaseDetaiel];           //追号详情
        
        [self addSubview:chaseScroll];


    }
    return self;
}
- (id)initWithFrame:(CGRect)frame chaseModel:(QueryChaseCellModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        chaseScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, frame.size.width, frame.size.height-10)];
        chaseScroll.contentSize = CGSizeMake(frame.size.width, 700);
        [self queryChaseTitleView];
        [self queryChaseSchemeDetail];
        [self addSubview:chaseScroll];
        [self queryChaseSchemeContent];//方案内容
        [self queryChaseDetaiel];//追号详情
        
    }
    return self;
    
}
/*  详情显示信息 */
- (void)chaseDetailDataChaseModel:(QueryChaseCellModel *)model
{
    self.chaseModel = [model retain];
    
    NSString *state         = nil;
    switch ([chaseModel.state intValue]) {
        case 0:
            state = @"进行中";
            break;
        case 2:
            state = @"已取消";
            break;
        case 3:
            state = @"已完成";
            break;
            
        default:
            break;
    }
    NSString *prizeEnd = @"否";
    if ([chaseModel.prizeEnd isEqualToString:@"1"]) {
        prizeEnd = @"是";
    }else{
        prizeEnd = @"否";
    }
    NSArray *conArray = [[NSArray alloc]initWithObjects:
                         chaseModel.lotName,
                         chaseModel.tradeId,
                         [NSString stringWithFormat:@"%@期", chaseModel.batchNum],
                         [NSString stringWithFormat:@"%@期", chaseModel.lastNum],
                         [NSString stringWithFormat:@"第%@期",chaseModel.beginBatch],
                         [NSString stringWithFormat:@"%.2f 元",[chaseModel.amount intValue]/100.0],
                         chaseModel.orderTime,
                         prizeEnd,
                         state,nil];
    for (int i=0; i<conArray.count; i++) {
        UILabel * label = (UILabel *)[chaseScroll viewWithTag:TagChaseLabel100+i];
        label.text = [conArray objectAtIndex:i];
    }
    [conArray release];
    
    UITextView * conTextView    = (UITextView *)[chaseScroll viewWithTag:TagChaseLabel100+99];
    conTextView.text            = chaseModel.betCode;
    
    
}
/* 追号详情列表数据 */
- (void)chaseDetailTableViewCellArray:(NSArray *)dataArray
{
    if (self.chaseDataAry.count == 0) {
        [self.chaseDataAry addObjectsFromArray:dataArray];
        [detTableView reloadData];
    }
}
- (void)dealloc
{
    [chaseScroll release];
    [chaseModel release],chaseModel = nil;
    [chaseDataAry release],chaseDataAry = nil;
    [detTableView release];
    [super dealloc];

}
/* 标题  */
- (void)queryChaseTitleView
{
    UIImageView *imgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queryDetailBg.png"]];
    imgView.frame = CGRectMake(0, 0, self.frame.size.width, 600);
    [self addSubview:imgView];
    [imgView release];
    
    UIButton *closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(305, 0, 55, 55);
    [closeBtn setImage:[UIImage imageNamed:@"queryclose.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(queryDetailCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn]; //125162466
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 30)];
    label.backgroundColor =[UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"追号详情";
    [self addSubview:label];
    [label release];
}
/*  方案详情 */
- (void)queryChaseSchemeDetail
{
    UILabel * label         = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
    label.backgroundColor   = [UIColor clearColor];
    label.text              = @"方案详情";
    [chaseScroll addSubview:label];
    [label release];
    
    NSArray * array         =[[NSArray alloc]initWithObjects:@"彩种:",@"编号:",@"追号期数:",@"已追期数:",@"起始期数",@"追号总额",@"投注时间:",@"中奖停止追号",@"当前状态", nil];
    
    for (int i=0; i<array.count; i++) {
        UILabel * lefeLabel         =[[UILabel alloc]initWithFrame:CGRectMake(0, 30+(30*i), 130, 20)];
        lefeLabel.text              =[array objectAtIndex:i];
        lefeLabel.textColor         =  RGBCOLOR(107, 140, 175);
        lefeLabel.textAlignment     = NSTextAlignmentCenter;
        lefeLabel.backgroundColor   =[UIColor clearColor];
        [chaseScroll addSubview:lefeLabel];
        [lefeLabel release];
        
        UILabel *rightLabel         =[[UILabel alloc]initWithFrame:CGRectMake(140, lefeLabel.frame.origin.y, 200, 20)];
        rightLabel.backgroundColor  =[UIColor clearColor];
        rightLabel.tag              = TagChaseLabel100+i;
        [chaseScroll addSubview:rightLabel];
        [rightLabel release];
    }
    [array release];
}
/* 方案内容*/
- (void)queryChaseSchemeContent
{
    UILabel * conLabel              = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, 150, 20)];
    conLabel.backgroundColor        = [UIColor clearColor];
    conLabel.text                   = @"方案内容";
    [chaseScroll addSubview:conLabel];
    [conLabel release];
    
    UITextView * conTextView        = [[UITextView alloc]initWithFrame:CGRectMake(20, 330, 300, 100)];
    conTextView.tag                 = TagChaseLabel100 + 99;
    conTextView.editable            = NO;
    conTextView.font                = [UIFont systemFontOfSize:17];
    [chaseScroll addSubview:conTextView];
    [conTextView release];
}
/* 追号详情 */
- (void)queryChaseDetaiel
{
    UILabel *detLabel               = [[UILabel alloc]initWithFrame:CGRectMake(10, 440, 200, 20)];
    detLabel.text                   = @"追号详情";
    detLabel.backgroundColor        = [UIColor clearColor];
    [chaseScroll addSubview:detLabel];
    [detLabel release];
    
    self.chaseDataAry               = [[NSMutableArray alloc]init];
    detTableView                    = [[UITableView alloc]initWithFrame:CGRectMake(20, 470, 320, 230) style:UITableViewStylePlain];
    detTableView.delegate           = self;
    detTableView.dataSource         = self;
    [chaseScroll addSubview:detTableView];
}
/* 关闭view */
- (void)queryDetailCloseButton:(id)sender
{
    [self.delegate queryChaseDetailCloseButton:self];
}
#pragma mark ------- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chaseDataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell =@"celled";
    QueryChaseDetailTableCell * cell =[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell =[[[QueryChaseDetailTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
    }
    cell.detModel = [self.chaseDataAry objectAtIndex:indexPath.row];
    [cell getDetailCellDataRefresh];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
