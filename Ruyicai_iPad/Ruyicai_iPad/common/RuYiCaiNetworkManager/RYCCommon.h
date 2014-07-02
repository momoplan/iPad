//
//  RYCCommon.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-4.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RYCNetworkManager.h"
#import "UserLoginData.h"


//测试 接口  http://192.168.0.42:80
//#define kRuYiCaiServer   @"http://www.ruyicai.com/lotserver/RuyicaiServlet"
//#define kRuYiCaiBetSafari   @"http://www.ruyicai.com/lotserver/log/betConfirm.jsp?jsonString="
//#define kRuYiCaiHMSafari    @"http://www.ruyicai.com/lotserver/log/betCaseConfirm.jsp?jsonString="

//测试性数据
#define kRuYiCaiServer   @"http://202.43.152.173:8099/lotserver/RuyicaiServlet"
#define kRuYiCaiBetSafari   @"http://202.43.152.173:8099/lotserver/log/betConfirm.jsp?jsonString="
#define kRuYiCaiHMSafari    @"http://202.43.152.173:8099/lotserver/log/betCaseConfirm.jsp?jsonString="

#define kRuYiCaiCharge   @"http://wap.ruyicai.com/w/wap/iphoneCharge.jspx"

//版本标示 
#define kRuYiCaiPlatform @"iPad"
#define kRuYiCaiVersion  @"1.0.0"
#define kRuYiCaiCoopid   @"1087"

#define KISHighVersion_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kTokenType @"iPadAppStore"

//加密 字符串
#define kRuYiCaiAesKey   @"<>hj12@#$$%^~~ff"
//alertTag

#define KISEmptyOrEnter(text) ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)//判断输入框是否有数据（除去空格和换行）
#define KISDictionaryHaveKey(dict,key) [[dict allKeys] containsObject:key] && ([dict objectForKey:key] != (NSString*)[NSNull null]) ? [dict objectForKey:key] : @""//取字典数据 防止崩溃
#define KISNullValue(array,i,key) ([[[array objectAtIndex:i] allKeys] containsObject:key] && [[array objectAtIndex:i] objectForKey:key] != (NSString*)[NSNull null] ? [[array objectAtIndex:i] objectForKey:key] : @"")

#define NUMBERS @"0123456789\n"//只允许输入数字
#define kColorWithRGB(r, g, b, a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]//色值

//彩种编号
#define kLotNoSSQ        @"F47104"  //双色球
#define kLotNoQLC        @"F47102"  //七乐彩
#define kLotNoFC3D       @"F47103"  //福彩3D


// 体彩
#define kLotNoDLT        @"T01001"  //大乐透
#define kLotNoPLS        @"T01002"  //排列三
#define kLotNoQXC        @"T01009"  //七星彩
#define kLotNoPL5        @"T01011"  //排列五

// 高频彩
#define kLotNo11YDJ      @"T01012"  //十一运夺金
#define kLotNoKLSF       @"T01015"  //广东快乐十分
#define kLotNoNMK3       @"F47107"  //内蒙快三
#define kLotNoCQ115      @"T01016"  //重庆11选5
#define kLotNo115        @"T01010"  //11选5
#define kLotNoSSC        @"T01007"  //时时彩
#define kLotNoGD115      @"T01014"  //广东11选5

#define kLotNoZC         @"ZC" //足彩
#define kLotNoJQC        @"T01005"  //进球彩
#define kLotNoLCB        @"T01006"  //足彩六场半
#define kLotNoSFC        @"T01003"  //足彩胜负彩
#define kLotNoRX9        @"T01004"  //足彩任九

#define kLotNoBJDC                @"BD"//北京单场
#define kLotNoBJDC_RQSPF          @"B00001"
#define kLotNoBJDC_JQS            @"B00002"
#define kLotNoBJDC_HalfAndAll     @"B00003"
#define kLotNoBJDC_SXDS           @"B00004"
#define kLotNoBJDC_Score          @"B00005"

#define kLotNoJCLQ          @"JC_L" //竞彩篮球
#define kLotNoJCLQ_SF       @"J00005"  //竞彩篮球胜负
#define kLotNoJCLQ_RF       @"J00006"  //竞彩篮球让分胜负
#define kLotNoJCLQ_SFC      @"J00007"  //竞彩篮球胜分差
#define kLotNoJCLQ_DXF      @"J00008"  //竞彩篮球大小分


#define kLotNoJCZQ          @"JC_Z" //竞彩足球
#define kLotNoJCZQ_RQ       @"J00013"  //竞彩足球让球胜平负
#define kLotNoJCZQ_SPF      @"J00001"//竞彩足球 胜平负
#define kLotNoJCZQ_ZJQ      @"J00003"  //竞彩足球总进球数
#define kLotNoJCZQ_SCORE    @"J00002"  //竞彩足球比分
#define kLotNoJCZQ_HALF     @"J00004"  //竞彩足球半全场
#define kLotNoJCLQ_CONFUSION    @"J00012"  //竞彩混合篮球
#define kLotNoJCZQ_CONFUSION    @"J00011"  //竞彩混合ZU球

#define kLotNoJCZQ_GYJ      @"J00009"  //竞彩足球冠亚军

//彩种名称
#define kLotTitleSSQ     @"ssq"  //双色球
#define kLotTitleQLC     @"qlc"  //七乐彩
#define kLotTitleFC3D    @"ddd"  //福彩3D
#define kLotTitleDLT     @"dlt"  //大乐透
#define kLotTitle11X5    @"11-5" //11选5
#define kLotTitleSSC     @"ssc"  //时时彩
#define kLotTitleGD115   @"gd-11-5" //广东11选5

