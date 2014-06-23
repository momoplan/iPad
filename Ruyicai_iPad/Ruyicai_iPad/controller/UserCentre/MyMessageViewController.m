//
//  MyMessageViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-30.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "MyMessageViewController.h"

@interface MyMessageViewController ()

@property(nonatomic, retain)NSMutableArray* cellRowHeigth;//行高

@end

@implementation MyMessageViewController
@synthesize delegate;
@synthesize messageArray;
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
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.cellRowHeigth = [[NSMutableArray alloc] init];
    self.messageArray = [[NSMutableArray alloc] init];
    
    [self messageTitleView];
    [self messageTableView];
    [self messageFeedbackView];//反馈
    [self myMessageViewDataRequest];
}
- (void)dealloc{
    
    [_cellRowHeigth release], _cellRowHeigth = nil;
    
    [refreshView release];
    
    [messageArray release],messageArray = nil;
    
    [messTableView release];
    [feedView release];
    [textView release];
    [phoneTextField release];
    [super dealloc];

}
#pragma mark ------- message view
/* 页面标题设置 */
- (void)messageTitleView
{
    [super tabBarBackgroundImageViewWith:self.view];
    [self.view addSubview:getTopLableWithTitle(@"我的留言")];
    
    UIButton *messageBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    messageBackBtn.frame = CGRectMake(0, 0, 76, 75);
    [messageBackBtn setImage:[UIImage imageNamed:@"narBack.png"] forState:UIControlStateNormal];
    [messageBackBtn addTarget:self action:@selector(messageBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageBackBtn];
}
/* 显示留言列表 */
- (void)messageTableView
{
    messTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 70, 600, 650) style:UITableViewStylePlain];
    messTableView.delegate = self;
    messTableView.dataSource = self;
    [self.view addSubview:messTableView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 0;

    
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectZero];
    [messTableView addSubview:refreshView];
    refreshView.myScrollView            = messTableView;
    [refreshView stopLoading:NO];
    [refreshView setRefreshViewFrame];
}
/*  反馈信息 */
- (void)messageFeedbackView
{
    feedView =[[UIScrollView alloc]initWithFrame:CGRectMake(600, 70, 308, 650)];
    feedView.backgroundColor =RGBCOLOR(244, 244, 244);
    [self.view addSubview:feedView];
    
    UIView *bgView          = [[UIView alloc]initWithFrame:CGRectMake(0, 0, feedView.frame.size.width, 43)];
    bgView.backgroundColor  = [UIColor colorWithPatternImage:RYCImageNamed(@"total_top_button_bg.png")];
    [feedView addSubview:bgView];
    [bgView release];
    
    
    UILabel * titLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 30)];
    titLabel.font =[UIFont boldSystemFontOfSize:20];
    titLabel.text =@"我要反馈";
    titLabel.backgroundColor = [UIColor clearColor];
    [feedView addSubview:titLabel];
    [titLabel release];
    
    UILabel *textLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 200, 25)];
    textLabel.text = @"请输入反馈内容:";
    textLabel.textColor = [UIColor grayColor];
    textLabel.font = [UIFont systemFontOfSize:20];
    textLabel.backgroundColor =[UIColor clearColor];
    [feedView addSubview:textLabel];
    [textLabel release];
    
    textView =[[UITextView alloc]initWithFrame:CGRectMake(10, 90, 280, 200)];
    textView.delegate = self;
    textView.font =[UIFont systemFontOfSize:18];
    [feedView addSubview:textView];
    
    UILabel * phoneLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 300, 150, 25)];
    phoneLabel.text = @"联系电话:";
    phoneLabel.textColor = [UIColor grayColor];
    phoneLabel.font = [UIFont systemFontOfSize:20];
    [feedView addSubview:phoneLabel];
    phoneLabel.backgroundColor = [UIColor clearColor];
    [phoneLabel release];
    
    phoneTextField =[[UITextField alloc]initWithFrame:CGRectMake(10, 330, 280, 40)];
    phoneTextField.delegate = self;
    phoneTextField.placeholder = @"联系方式";
    phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [feedView addSubview:phoneTextField];
    
    UIButton * feedBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    feedBtn.frame = CGRectMake(100, 380, 118, 41);
    [feedBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    feedBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [feedBtn setTitleColor:[UIColor blackColor] forState:btnNormal];
    [feedBtn setBackgroundImage:RYCImageNamed(@"userCenter_button_normal.png") forState:btnNormal];
    [feedBtn setBackgroundImage:RYCImageNamed(@"userCenter_button_click.png") forState:UIControlStateHighlighted];
    [feedBtn addTarget:self action:@selector(messageFeedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [feedView addSubview:feedBtn];
    
    UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 430,feedView.frame.size.width, 2)];
    lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [feedView addSubview:lineView];
    [lineView release];
}
#pragma mark -------------- requeset methods
- (void)myMessageViewDataRequest
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"feedback" forKey:@"command"];
    [mDic setObject:@"feedBack" forKey:@"type"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDic setObject:[NSString stringWithFormat:@"%d",curPageIndex] forKey:@"pageindex"];
    [mDic setObject:@"10" forKey:@"maxresult"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeLeaveMessage showProgress:YES];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    DLog(@" 我的留言 -------- %@",dataDic);
    switch (requestTag) {
        case ASINetworkRequestTypeLeaveMessage:
        {
            [self myMessageViewDataProcessingDictionary:dataDic];
        }
            break;
        case ASINetworkRequestTypeFeedback://反馈
        {
            [self myMessageViewFeedInfo:dataDic];
        }
            break;
        default:
            break;
    }
}
/*  留言信息 处理 */
- (void)myMessageViewDataProcessingDictionary:(NSDictionary *)mDic
{
    NSString * errorCode = KISDictionaryHaveKey(mDic, @"error_code");
    if ([errorCode isEqualToString:@"0047"]) {
//        UILabel * clabel =[[UILabel alloc]initWithFrame:CGRectMake(300, 130, 150, 30)];
//        clabel.text = @"无记录";
//        clabel.font = [UIFont boldSystemFontOfSize:20];
//        clabel.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:clabel];
//        [clabel release];
        [refreshView stopLoading:YES];
        return;
    }
    if (curPageIndex == 0) {
        [self.messageArray removeAllObjects];
        [self.cellRowHeigth removeAllObjects];
    }

    NSMutableArray *muArray =[[NSMutableArray alloc]init];
    NSArray *result = KISDictionaryHaveKey(mDic, @"result");
    for (int i=0; i<result.count; i++) {
        NSDictionary * dic =[result objectAtIndex:i];
        MyMessageViewCellModel * model =[[MyMessageViewCellModel alloc]init];
        model.content = KISDictionaryHaveKey(dic, @"content");
        model.reply = KISDictionaryHaveKey(dic, @"reply");
        model.createTime = KISDictionaryHaveKey(dic, @"createTime");
        model.readState = KISDictionaryHaveKey(dic, @"readState");
        
        CGSize contentSize = [KISDictionaryHaveKey(dic, @"content") sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(500, 1000)];
        CGSize replySize = [KISDictionaryHaveKey(dic, @"reply") sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(500, 1000)];

        model.contentHig = contentSize.height;
        model.replyHig = replySize.height;
        
        [self.cellRowHeigth addObject:[NSString stringWithFormat:@"%.f",contentSize.height + replySize.height + 80]];
        
        [muArray addObject:model];
        [model release];
    }
       [self.messageArray addObjectsFromArray:muArray];
    
    [muArray release];
    [messTableView reloadData];
    
    totalPageCount              = [KISDictionaryHaveKey(mDic, @"totalPage") intValue];
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

}
/*  反馈信息 返回信息 处理 */
- (void) myMessageViewFeedInfo:(NSDictionary *)mDic
{
    NSString * errorCode = KISDictionaryHaveKey(mDic, @"errorCode");
    NSString * message = KISDictionaryHaveKey(mDic, @"message");
    if ([errorCode isEqualToString:@"success"]) {
        phoneTextField.text = @"";
        textView.text = @"";
        
        curPageIndex = 0;
        [self myMessageViewDataRequest];

        [self showAlertWithMessage:@"提交成功"];
      
    }else{
        [self showAlertWithMessage:message];
    }
}
#pragma mark ---------- message methods
- (void)messageBackButtonClick:(id)sender
{
    [self.delegate myMessageViewDisappear:self];
}
/*  提交反馈 */
- (void)messageFeedButtonClick:(id)sender
{
    [textView resignFirstResponder];
    [phoneTextField resignFirstResponder];
    
    if (KISEmptyOrEnter(textView.text)) {
        [self showAlertWithMessage:@"请填写反馈意见，谢谢！"];
        return;
    }
    if (phoneTextField.text.length !=0) {
        if (phoneTextField.text.length !=11) {
            [self showAlertWithMessage:@"请输入正确的手机号！"];
            return;
        }
    }
    
    NSMutableDictionary * mDic = [[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"feedback" forKey:@"command"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDic setObject:textView.text forKey:@"content"];
    [mDic setObject:phoneTextField.text ? phoneTextField.text : @"" forKey:@"contactWay"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeFeedback showProgress:YES];
}
#pragma mark ------------ textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length>11) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [feedView setContentSize:CGSizeMake(feedView.frame.size.width, feedView.frame.size.height+100)];
    [feedView setContentOffset:CGPointMake(0, 100) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [feedView setContentSize:CGSizeMake(feedView.frame.size.width, feedView.frame.size.height)];
    [feedView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ----------- textView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
#pragma mark ----------- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.cellRowHeigth objectAtIndex:indexPath.row] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell = @"celled";
    MyMessageTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell =[[[MyMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.model = [self.messageArray objectAtIndex:indexPath.row];
    [cell messageTableCellRefresh];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    DLog(@"start");
    if(curPageIndex < totalPageCount)
    {
        [self myMessageViewDataRequest];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
