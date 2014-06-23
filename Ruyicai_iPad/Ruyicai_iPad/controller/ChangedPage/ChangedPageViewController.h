//
//  ChangedPageViewController.h
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-17.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "DNAPaymentViewController.h"
#import "PhoneCardPaymentViewController.h"

@interface ChangedPageViewController : RootViewController<UITableViewDelegate, UITableViewDataSource, DNAChangedViewDelegate, PhoneDissViewDelegate>
{
    UITableView*  m_myTableView;
    int           cell_count;
    int           m_didSelectRow;
}
@end
