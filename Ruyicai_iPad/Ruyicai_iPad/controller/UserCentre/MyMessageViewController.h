//
//  MyMessageViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-30.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 我的留言

#import "RootViewController.h"
#import "MyMessageTableViewCell.h"
#import "PullUpRefreshView.h"

@protocol MyMessageViewControllerDelegate <NSObject>

- (void)myMessageViewDisappear:(UIViewController *)viewController;

@end

@interface MyMessageViewController : RootViewController
<UITextFieldDelegate,UITextViewDelegate>
{
    UITableView         * messTableView;//留言列表
    UIScrollView        * feedView;//反馈view
    UITextView          * textView;// 反馈内容
    UITextField         * phoneTextField;// 联系方式
    
    PullUpRefreshView           * refreshView;          // 下拉刷新view
    int                         totalPageCount;         // 数据总页数
    int                         curPageIndex;           // 当前加载页数
}
@property (nonatomic,assign)id<MyMessageViewControllerDelegate>delegate;
@property (nonatomic,retain) NSMutableArray * messageArray; //留言信息 数据数组
@end
