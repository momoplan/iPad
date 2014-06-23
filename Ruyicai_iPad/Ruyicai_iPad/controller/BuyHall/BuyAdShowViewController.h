//
//  BuyAdShowViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-12-10.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  首页广告

#import "RootViewController.h"

@interface BuyAdShowViewController : RootViewController

@property (retain, nonatomic) IBOutlet UILabel *adViewTitleLabel;
@property (retain, nonatomic) IBOutlet UITextView *adViewContentTextView;

@property (nonatomic,retain) NSDictionary * dataDic;
@end
