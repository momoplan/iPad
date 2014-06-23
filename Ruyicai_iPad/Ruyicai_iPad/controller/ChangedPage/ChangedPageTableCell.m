//
//  ChangedPageTableCell.m
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-18.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "ChangedPageTableCell.h"
#import "RYCImageNamed.h"

@interface ChangedPageTableCell ()

@end

@implementation ChangedPageTableCell

@synthesize iconImageName = m_iconImageName;
@synthesize titleName = m_titleName;
@synthesize littleTitleName = m_littleTitleName;
@synthesize isHaveImg_free;

- (void)dealloc
{
    [m_icoImageView release];
    [m_titleLabel release];
    [m_littleTitleLabel release];
    [m_freeImg release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        m_icoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 56, 56)];
        [self addSubview:m_icoImageView];
        
        m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 140, 60)];
        m_titleLabel.textAlignment = NSTextAlignmentLeft;
        m_titleLabel.backgroundColor = [UIColor clearColor];
        m_titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:m_titleLabel];
        
        m_littleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 300, 40)];
        m_littleTitleLabel.textAlignment = NSTextAlignmentLeft;
        m_littleTitleLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:131.0/255.0 blue:131.0/255.0 alpha:1.0];
        m_littleTitleLabel.backgroundColor = [UIColor clearColor];
        m_littleTitleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:m_littleTitleLabel];
        
        m_freeImg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"change_free.png")];
        m_freeImg.frame = CGRectMake(700, 0, 128, 80);
        [self addSubview:m_freeImg];
        m_freeImg.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)refresh
{
    m_icoImageView.image = RYCImageNamed(self.iconImageName);
    m_titleLabel.text = self.titleName;
    m_littleTitleLabel.text = self.littleTitleName;
    
    m_freeImg.hidden = !isHaveImg_free;
}


@end
