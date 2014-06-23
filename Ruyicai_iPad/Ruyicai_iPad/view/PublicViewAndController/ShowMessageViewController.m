//
//  ShowMessageViewController.m
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "ShowMessageViewController.h"
#import "RYCCommon.h"
#import "RYCImageNamed.h"

@interface ShowMessageViewController ()

@end

@implementation ShowMessageViewController

@synthesize isTextView;
@synthesize myTitle;
@synthesize contentStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self.view addSubview:bgView];
    [bgView release];
    
    [self setBgView];
    [self setContentView];
}

- (void)setBgView
{
    UIImageView* bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(259, 93, 500, 530)];
    bgImage.image = RYCImageNamed(@"alter_bg_big.png");
    [self.view addSubview:bgImage];
    [bgImage release];
    
    UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(412, 93, 195, 49)];
    [topLabel setText:myTitle];
    [topLabel setTextColor:[UIColor whiteColor]];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    [self.view addSubview:topLabel];
    [topLabel release];
    
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(259, 98, 71, 43)];
    [backButton setImage:RYCImageNamed(@"back.png") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton release];
}

- (void)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setContentView
{
    if (isTextView) {
        UITextView* contentView = [[UITextView alloc] initWithFrame:CGRectMake(267, 143, 483, 469)];
        contentView.text = contentStr;
        contentView.font = [UIFont systemFontOfSize:14.0];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.textColor = [UIColor blackColor];
        contentView.editable = NO;
        [self.view addSubview:contentView];
        [contentView release];
    }
    else
    {
        NSString* path = [[NSBundle mainBundle] pathForResource:contentStr ofType:@"html"];
        NSData* htmldata = [NSData dataWithContentsOfFile:path];
        NSString* htmlcontent = [[NSString alloc] initWithData:htmldata encoding:NSUTF8StringEncoding];
        NSString *imagePath  = [[NSBundle mainBundle] bundlePath];

        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(267, 143, 483, 469)];
        webView.layer.cornerRadius = 3;
        webView.layer.masksToBounds = YES;
        UIScrollView *scroller = [webView.subviews objectAtIndex:0];//去掉阴影
        if (scroller) {
            for (UIView *v in [scroller subviews]) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    [v removeFromSuperview];
                }
            }
        }
        webView.delegate = self;
        webView.backgroundColor = [UIColor clearColor];
        webView.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;//下划线类型
        [webView loadHTMLString:htmlcontent baseURL:[NSURL fileURLWithPath:imagePath]];
        [self.view addSubview:webView];
        [htmlcontent release];
        [webView release];    
    }
}

- (BOOL)webView:(UIWebView *)webViewLocal shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *myURL = [[request URL] absoluteString];
    NSLog(@"%@", myURL);//进来时：about:blank  http://www.ruyicai.com/
    if([myURL hasPrefix:@"http:"] || [myURL hasPrefix:@"tel:"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myURL]];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//  横屏显示
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
@end
