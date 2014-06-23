//
//  SetChaseStageTableView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-19.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "SetChaseStageTableView.h"

@implementation SetChaseStageTableView
@synthesize stageArray;
@synthesize stageNumber;
@synthesize batchLotNo;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isSetChaseStage = YES;
        [self chaseStageViewCreateFrame:frame];
    }
    return self;
}
- (void)dealloc
{
    [stageArray release],stageArray = nil;
    [stageNumber release],stageNumber = nil;
    [batchLotNo release],batchLotNo = nil;
    [stageTable release];
    [super dealloc];

}
#pragma mark ============== view
- (void)chaseStageViewCreateFrame:(CGRect)frame
{
    UIButton * openStageBtn     = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openStageBtn.frame          = CGRectMake(0, 0, 280, 20);
    [openStageBtn setTitle:@"设置追期" forState:UIControlStateNormal];
    [openStageBtn setBackgroundImage:RYCImageNamed(@"basketTableOpen.png") forState:btnNormal];
    [openStageBtn setBackgroundImage:RYCImageNamed(@"basketTableClose.png") forState:UIControlStateHighlighted];
    [openStageBtn addTarget:self action:@selector(openStageTableButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:openStageBtn];
    
    self.stageArray             = [[NSMutableArray alloc]init];
    stageTable                  = [[UITableView alloc]initWithFrame:CGRectMake(0, 25, frame.size.width, frame.size.height-30) style:UITableViewStylePlain];
    stageTable.delegate         = self;
    stageTable.dataSource       = self;
    stageTable.rowHeight        = 30;
}
#pragma mark ============== methods
- (void)openStageTableButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    if (isSetChaseStage) {
        
        [self rendRequestAfterIssue];
        [button setBackgroundImage:RYCImageNamed(@"basketTableOpen.png") forState:btnNormal];

       
    }else{
        [button setBackgroundImage:RYCImageNamed(@"basketTableOpen.png") forState:btnNormal];
        [self.stageArray removeAllObjects];
        [stageTable removeFromSuperview];
    }
    isSetChaseStage =!isSetChaseStage;
}
#pragma mark ------------------ requesetComfit
- (void)rendRequestAfterIssue
{
    if ([stageNumber isEqualToString:@""] || [batchLotNo isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary* tempDic = [[NSMutableDictionary alloc ]init];
    [tempDic setObject:@"QueryLot" forKey:@"command"];
    [tempDic setObject:@"afterIssue" forKey:@"type"];
    [tempDic setObject:self.stageNumber  forKey:@"batchnum"];
    [tempDic setObject:self.batchLotNo forKey:@"lotno"];
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:tempDic withRequestType:ASINetworkReqestTypeGetLotDate showProgress:YES];
    [tempDic release];
}
- (void)querySampleNetOK:(NSNotification *)notification
{
    NSDictionary* dataDic = (NSDictionary*)notification.userInfo;
    int reqType = [[dataDic objectForKey:KRequestTypeKey] integerValue];
    switch (reqType) {
        case ASINetworkReqestTypeGetLotDate:
        {
            if (ErrorCode(dataDic)) {
                [self.stageArray addObjectsFromArray:KISDictionaryHaveKey(dataDic, @"result")];
                [stageTable reloadData];
                [self addSubview:stageTable];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark ============ tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell = @"celled";
    BatchCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell = [[[BatchCodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.stageStr = [[self.stageArray objectAtIndex:indexPath.row] objectForKey:@"batchCode"];
    [cell refreshCellView];
    
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
