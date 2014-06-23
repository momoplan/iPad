//
//  ModifyPasswordViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-31.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 修改密码

#import "RootViewController.h"

@interface ModifyPasswordViewController : RootViewController
<UITextFieldDelegate>
{
    
}
@property (retain, nonatomic) IBOutlet UITextField *oldPassTextField;
@property (retain, nonatomic) IBOutlet UITextField *newPassTextField;
@property (retain, nonatomic) IBOutlet UITextField *againPassTextField;
@property (retain, nonatomic) IBOutlet UIView *modifyView;
@end
