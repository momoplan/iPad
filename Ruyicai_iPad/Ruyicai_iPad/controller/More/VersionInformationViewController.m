//
//  VersionInformationViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-4.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 

#import "VersionInformationViewController.h"

@interface VersionInformationViewController ()

@end

@implementation VersionInformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)versionbackButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    _versionDetailView.hidden = YES;
    NSMutableDictionary*  dic = [[[NSMutableDictionary alloc]init]autorelease];
    [dic setObject:@"versionIntroduce" forKey:@"newsType"];
    [dic setObject:@"information" forKey:@"command"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:dic withRequestType:ASINetworkReqestTypeGetLotDate showProgress:YES];
//    UITextView * textView =(UITextView *)[self.view viewWithTag:101];
//    textView.editable   = NO;
//    textView.text = @"3.6.3 版本介绍\n1、更新银联充值插件；\n2、增加高频彩确认投注期的提醒;\n3、修复一些问题。\n（欢迎客户端忠实用户加入官方QQ群4068202,一同改善我们的软件）";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark ================= notification menthod
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkReqestTypeGetLotDate://
        {
            if (ErrorCode(dataDic)) {
                _versionDetailView.hidden = NO;
                [self.view addSubview:_versionDetailView];
                UITextView * textView =(UITextView *)[self.view viewWithTag:101];
                NSString    * textString = KISDictionaryHaveKey(dataDic, @"introduce");
                if (![textString isEqualToString:@" "]) {
                    textView.text = textString;
                }
            }else
            {
                [_versionDetailView removeFromSuperview];
                UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:KISDictionaryHaveKey(dataDic, @"message") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alertView.delegate = self;
                [alertView show];
                [alertView release];
            }
            
            
        }
            break;
       
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_versionDetailView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setVersionDetailView:nil];
    [super viewDidUnload];
}
@end
