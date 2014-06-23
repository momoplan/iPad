//
//  ActivityView.m
//  RuYiCai
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ActivityView.h"
#import "RYCImageNamed.h"

@implementation ActivityView

- (void)dealloc
{
    [m_logoImage release];

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 0.4;
        
        NSMutableArray* imageArray = [[NSMutableArray alloc] init];
        for (int k = 0; k < 10; k++) {
            [imageArray addObject:RYCImageNamed([NSString stringWithFormat:@"process_%d.png", k+1])];
        }
        m_logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 144, 144)];
        m_logoImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        m_logoImage.animationImages = imageArray;
        m_logoImage.animationDuration = 0.8;//越大越慢
        m_logoImage.animationRepeatCount = 0;//无限次
        [self addSubview:m_logoImage];
        [imageArray release];

        [self disActivityView];
    }
    return self;
}

- (void)activityViewShow
{
    if(self.frame.origin.y != 0)
    {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        [m_logoImage startAnimating];
    }
}

- (void)disActivityView
{
    if(self.frame.origin.y != [[UIScreen mainScreen] bounds].size.height)
    {
        self.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        [m_logoImage stopAnimating];
    }
}

@end
