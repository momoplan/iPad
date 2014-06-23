//
//  QueryTogetherDetailView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-30.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryTogetherDetailModel.h"
#import "TogetherParticipationModel.h"
@protocol queryTogetherDetailViewDelegate <NSObject>

@optional
- (void)queryTogetherDeTailDisappear:(UIView *)view;

@end

@interface QueryTogetherDetailView : UIView
<UITableViewDataSource,UITableViewDelegate,RYCNetworkManagerDelegate>
{
    UIScrollView        * togetherDetailView;
    UITableView         * personTableView;//参与人员 列表
    UILabel             * sponLabel;
    UIWebView           * contentWebView;
    UILabel             * numberLabel; // 开奖号码
    int                 icoHeightIndex;
}
@property (nonatomic,assign) id<queryTogetherDetailViewDelegate>delegate;
@property (nonatomic,retain) QueryTogetherDetailModel * detModel;
@property (nonatomic,retain) NSMutableArray * participationArray;

- (void)togetherDetailDataModel:(QueryTogetherDetailModel *)model;
@end
