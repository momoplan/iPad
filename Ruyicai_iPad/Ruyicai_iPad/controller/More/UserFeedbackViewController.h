//
//  UserFeedbackViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-5.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  用户反馈

#import "RootViewController.h"

@interface UserFeedbackViewController : RootViewController

@property (retain, nonatomic) IBOutlet UITextView *feedMessTextView;
@property (retain, nonatomic) IBOutlet UITextField *contentTextField;
@property (retain, nonatomic) IBOutlet UIView *feedView;
@end
