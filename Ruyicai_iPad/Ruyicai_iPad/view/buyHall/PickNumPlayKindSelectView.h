//
//  PickNumPlayKindSelectView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-21.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  彩种玩法选择

#import "RYView.h"

@protocol PickNumPlayKindSelectDelegate <NSObject>

- (void)pickPlayKindSelectLine:(int )line row:(int)row title:(NSString *)title;

@end

@interface PickNumPlayKindSelectView : RYView
{
    
}
@property (nonatomic,assign) id<PickNumPlayKindSelectDelegate>delegate;

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleAry kindArray:(NSArray *)kindAry;
@end
