//
//  CommonRecordStatus.h
//  RuYiCai
//
//  Created by ruyicai on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNormalLogin  @"NormalLogin"//如意彩帐号
#define kQQLogin      @"QQLogin"//qq登录
#define kXLWeiBoLogin @"XLLogin"//新浪微博帐号登录
#define KZFBLogin     @"ZFBLogin"//支付宝登陆

@interface CommonRecordStatus : NSObject {
    BOOL      m_remmberQuitStatus;//记住注销状态
    BOOL      m_isGetCashOK;  //提现是否成功
    NSString  *m_startImageId;  //服务器上保存的开机界面的id
    NSData    *m_startImage; //开机图片
    
    BOOL       m_useStartImage;//真时使用服务器上的，假时使用本地的
        
    NSString*  m_netMissDate;
    
    NSString*  m_deviceToken;
    
    NSString*  m_chargeWarnStr;
    
    NSDictionary*  m_topActionDic;//头部新闻
    
    NSString*  m_sampleNetStr;//一般彩票信息查询；一般充值信息查询
    
    NSString*  m_resultWarn;//成功后提示语
    
    /*
     投注查询 lotno
     */
    NSString*   m_QueryBetlotNO;
    
    NSString*   m_loginWay;//登录方式：
    
    NSString*   m_lotteryInfor;//开奖公告
    
    NSString*   m_inProgressActivityCount;//正在进行的活动数量
    
    NSInteger   m_changeWay;//0表示普通充值，1表示余额不足时的充值(充值成功后的跳转)，2:余额不足时直接支付 3:支付宝登陆
    
    NSMutableDictionary*  m_stopSaleLotDiction;//彩种是否停售纪录 YES:停售 NO:开售 key：kLotNoXX
}

+ (CommonRecordStatus *)commonRecordStatusManager;

@property (nonatomic, assign) BOOL remmberQuitStatus;
@property (nonatomic, assign) BOOL isGetCashOK;
@property (nonatomic, retain) NSString* startImageId;
@property (nonatomic, retain) NSData* startImage;
@property (nonatomic, assign) BOOL useStartImage;

@property (nonatomic, retain) NSString*  netMissDate;
@property (nonatomic, retain) NSString*  deviceToken; 

@property (nonatomic, retain) NSString*  chargeWarnStr;
@property (nonatomic, retain) NSDictionary*  topActionDic;

@property (nonatomic, retain) NSString*  sampleNetStr;

@property (nonatomic, retain) NSString*  resultWarn;

@property (nonatomic, retain) NSString*   loginWay;

@property (nonatomic, retain) NSString*   lotteryInfor;
@property (nonatomic, retain) NSString*   inProgressActivityCount;

@property (nonatomic, assign) NSInteger   changeWay;

@property (nonatomic, retain) NSMutableDictionary*  stopSaleLotDiction;

+ (BOOL)lotNoISJC:(NSString*)lotNo;//是否为竞彩
- (NSString*)lotNameWithLotNo:(NSString*)lotNo;
- (NSString*)lotNameWithLotTitle:(NSString*)lotTitle;
- (NSString*)lotNoWithLotTitle:(NSString*)lotTitle;
- (NSString*)lotTitleWithLotNo:(NSString*)lotNo;

- (void)clearBetData;
/*
  彩种页面 右上角下拉按钮
 */
@property (nonatomic, retain) NSString*  QueryBetlotNO;

- (UIImageView*)creatFourButtonView;
- (UIImageView*)creatThreeButtonView;

- (UIButton*)creatIntroButton:(CGRect)rect;
- (UIButton*)creatHistoryButton:(CGRect)rect;
- (UIButton*)creatQuerybetLotButton:(CGRect)rect;
- (UIButton*)creatLuckButton:(CGRect)rect;
- (UIButton*)creatAnalogNumButton:(CGRect)rect;//模拟选号
- (UIButton*)creatPresentSituButton:(CGRect)rect;//开奖走势


//判断汉字；长度
- (NSUInteger) asciiLengthOfString: (NSString *) text;
- (NSUInteger) unicodeLengthOfString: (NSString *) text;

#pragma mark 控制输入框输入长度
- (NSString*)textMaxLengthWithString:(NSString*)oldString andLength:(NSInteger)maxLength;

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end
