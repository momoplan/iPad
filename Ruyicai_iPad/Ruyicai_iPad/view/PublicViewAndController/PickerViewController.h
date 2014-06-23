//
//  PickerViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-15.
//  Copyright (c) 2013年 baozi. All rights reserved.
//


/**
 具体使用参见DNA充值页面
 **/
#import <UIKit/UIKit.h>
@class PickerViewController;

@protocol PickerViewControllerDelegate <NSObject>


- (void)pickerViewController:(PickerViewController *)viewController
                selectRowNum:(NSString*)selectRow;
- (void)pickViewCancelClick;

@end

@interface PickerViewController : UIViewController
<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView * pickerView;
    int pickerSelectNum;
    NSMutableArray *pickerDataArray;
}

@property (nonatomic, assign) id<PickerViewControllerDelegate>delegate;
@property (nonatomic, assign) int pickerSelectNum;
@property (nonatomic, assign) CGFloat pViewWidch;
/* 刷新 */
- (void)refreshViewController;
- (void)setPickerViewDataArray:(NSArray *)dataArray selectNum:(NSInteger)selectNum;

@end
