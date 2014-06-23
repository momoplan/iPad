//
//  BaseHelpViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-11-4.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "BaseHelpViewController.h"

@interface BaseHelpViewController ()

@end

@implementation BaseHelpViewController
@synthesize htmlFileName;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [m_webView release];
    [super dealloc];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [super tabBarBackgroundImageViewWith:self.view];
    
   [self.view addSubview:getTopLableWithTitle(@"关于我们")];
    
    UIButton * fundBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    fundBackBtn.frame =CGRectMake(10, 10, 75, 75);
    [fundBackBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [fundBackBtn addTarget:self action:@selector(BaseHeipBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fundBackBtn];
    
    
	m_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, 908, 650)];
	m_webView.backgroundColor = [UIColor whiteColor];
	m_webView.scalesPageToFit = NO;
    m_webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
//	m_webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	m_webView.delegate = self;
	[self.view addSubview:m_webView];
    
    [self refresh];

}
- (void)refresh
{
    NSString* path = [[NSBundle mainBundle] pathForResource:self.htmlFileName ofType:@"html"];
    NSData* htmldata = [NSData dataWithContentsOfFile:path];
    NSString* htmlcontent = [[NSString alloc] initWithData:htmldata encoding:NSUTF8StringEncoding];
    NSString *imagePath  = [[NSBundle mainBundle] bundlePath];
    [m_webView loadHTMLString:htmlcontent baseURL:[NSURL fileURLWithPath:imagePath]];
	[htmlcontent release];
}
- (void)BaseHeipBackButtonAction:(id)sender
{
    [self.delegate baseHelpViewDisappear:self];
}
#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"web: start load %@", [webView.request description]);
	
	// starting the load, show the activity indicator in the status bar
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"web: loading failed");
}

- (BOOL)webView:(UIWebView *)webViewLocal shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *myURL = [[request URL] absoluteString];
    //    NSLog(@"%@", myURL);//进来时：about:blank  http://www.ruyicai.com/
    if([myURL hasPrefix:@"http:"])
	{
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(NSString *)[myURL substringFromIndex:[@"http:" length]]]];
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

@end
