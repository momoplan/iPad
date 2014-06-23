//
//  BingingNickNameViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-10-30.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RootViewController.h"

@protocol BingingNickNameViewDelegate <NSObject>

@optional
- (void)bingNickNameSetSucceed;

@end


@interface BingingNickNameViewController : RootViewController
{
    
}
@property (nonatomic,retain) id<BingingNickNameViewDelegate>delegate;
@property (retain, nonatomic) IBOutlet UITextField *nickNameTextField;
@end
