//
//  BuyAdShowViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-12-10.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "BuyAdShowViewController.h"

@interface BuyAdShowViewController ()

@end

@implementation BuyAdShowViewController
@synthesize dataDic;

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
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.adViewTitleLabel.text = KISDictionaryHaveKey(dataDic, @"title");
    self.adViewContentTextView.text = KISDictionaryHaveKey(dataDic, @"content");
}
- (IBAction)adComfirmButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_adViewTitleLabel release];
    [_adViewContentTextView release];
    [dataDic release],dataDic = nil;
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAdViewTitleLabel:nil];
    [self setAdViewContentTextView:nil];
    [super viewDidUnload];
}
@end
