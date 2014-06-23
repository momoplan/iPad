//
//  BingingIDCardViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-8.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RootViewController.h"

@protocol bingingIDCardViewDelegate <NSObject>

- (void) bingingIDCardOperateSucceed;

@end

@interface BingingIDCardViewController : RootViewController
<UITextFieldDelegate>
{
    
}
@property (nonatomic,assign) id<bingingIDCardViewDelegate>delegate;

@property (retain, nonatomic) IBOutlet UIView           * bingCardView;
@property (retain, nonatomic) IBOutlet UIView           * showCardView;
@property (retain, nonatomic) IBOutlet UILabel          * showCardNameLabel;
@property (retain, nonatomic) IBOutlet UILabel          * showCardNumLabel;
@property (retain, nonatomic) IBOutlet UITextField      * bingCardTextField;
@property (retain, nonatomic) IBOutlet UITextField      * bingCardTextName;


@property (retain, nonatomic) NSString                  * cardNameText;
@property (retain, nonatomic) NSString                  * cardNumText;
@end
