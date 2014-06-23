//
//  RYCNetworkManager.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-4.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RYCNetworkManager.h"
#import "AppDelegate.h"

// mac地址
#include <sys/socket.h> 
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
// mac地址
// 投注彩种信息
#import "RuYiCaiLotDetail.h"

static RYCNetworkManager *s_networkManager = NULL;
@implementation RYCNetworkManager
@synthesize netDelegate;
#pragma mark ------------ 單例 shareManager

- (void)dealloc
{
    if (activityView) {
        [activityView removeFromSuperview];
        [activityView release], activityView = nil;
    }
    [super dealloc];
}

- (id)init
{
	if (self = [super init])
    {

	}
    return self;
}

+ (RYCNetworkManager *)sharedManager
{
    @synchronized(self)
    {   
        if (s_networkManager == nil)
        {
            s_networkManager = [[self alloc] init];  //assignment not done here
        }
    }
    return s_networkManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (s_networkManager == nil)
		{
			s_networkManager = [super allocWithZone:zone];
			return s_networkManager;  //assignment and return on first allocation
		}
	}
	return nil;  //on subsequent allocation attempts return nil
}

#pragma mark ------------- 请求
- (BOOL)netRequestStartWith:(NSMutableDictionary *)resultDic  withRequestType:(int)netRequestType showProgress:(BOOL)isShowProgress
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", kRuYiCaiServer];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;

    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:resultDic];
//    [resultDic addEntriesFromDictionary:[self getCommonCookieDictionary]];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"请求 :%@\n", cookieStr);
    
	[request setRequestType:netRequestType];
	[request setDelegate:self];
	[request startAsynchronous];
    
    if (isShowProgress) {
//        AppDelegate* dele = [[UIApplication sharedApplication] delegate];
//        [dele.activityView activityViewShow];
        if (activityView) {
            [activityView removeFromSuperview];
            [activityView release], activityView = nil;
        }
        [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (!window)
        {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        activityView = [[ActivityView alloc]init];
        [activityView activityViewShow];
        [window addSubview:activityView];
    }
    return YES;
}

#pragma mark ------------ request data
//解压 解密
- (NSString *)transformStringWith:(NSData *)requestData
{ //解压-->解密
    NSData *filData = [requestData newAESDecryptWithPassphrase:kRuYiCaiAesKey];
    //    NSLog(@"filData%@", filData);
    NSData *m_data = [RYCNetworkManager decodeBase64:filData];
    //    NSLog(@"%@", [RuYiCaiNetworkManager decodeBase64:filData]);
    NSData *responseData = [ASIHTTPRequest uncompressZippedData:m_data];
    NSString *resText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if (resText) {
        return [resText autorelease];
    }
    return resText ;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (activityView) {
        [activityView removeFromSuperview];
        [activityView release], activityView = nil;
    }
    NSString *resText = [self transformStringWith:[request responseData]];
    NSLog(@"返回数据 %@", resText);
    if (request.requestType == ASINetworkRequestTypeSoftUpdate) {//开机联网
        [self softUpdateComplete:resText];
        return;
    }
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSMutableDictionary* parserDict = (NSMutableDictionary*)[jsonParser objectWithString:resText];
//    [parserDict setObject:[NSString stringWithFormat:@"%d", request.requestType] forKey:KRequestTypeKey];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:KRequestCompNotName object:nil userInfo:parserDict];
    if (self.netDelegate && [self.netDelegate respondsToSelector:@selector(netSuccessWithResult:tag:)]) {
        [self.netDelegate netSuccessWithResult:parserDict tag:request.requestType];
    }
}

- (void)softUpdateComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    [jsonParser release];
    
    NSDictionary* subdict = (NSDictionary*)[parserDict objectForKey:@"autoLogin"];
    NSString *str = [subdict objectForKey:@"isAutoLogin"];
    if([str isEqualToString:@"true"])
    {
        [UserLoginData sharedManager].hasLogin = YES;
        [UserLoginData sharedManager].userNo = [[subdict objectForKey:@"userno"] length] > 0 ? [subdict objectForKey:@"userno"] : @"";
        [UserLoginData sharedManager].userPass = [[NSUserDefaults standardUserDefaults] objectForKey:kSavePassWordKey];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (activityView) {
        [activityView removeFromSuperview];
        [activityView release], activityView = nil;
    }
    [self showMessage:@"联网失败，请稍后重试" withTitle:@"联网提示" buttonTitle:@"确定"];
    
    if (self.netDelegate && [self.netDelegate respondsToSelector:@selector(netFailed:)]) {
        [self.netDelegate netFailed:Nil];
    }
}

#pragma mark  --------- 请求返回 信息处理--------
#pragma mark AlertView
- (void)showMessage:(NSString*)message withTitle:(NSString*)title buttonTitle:(NSString*)buttonTitle
{
    //    [m_receiveLotteryField resignFirstResponder];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:self
										  cancelButtonTitle:nil
										  otherButtonTitles:buttonTitle, nil];
	[alert show];
	[alert release];
}

// 获取 系统信息
- (NSMutableDictionary*)getCommonCookieDictionary
{
    NSTrace();
    UIDevice* device = [UIDevice currentDevice];
	NSString* deviceName = [device model];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:10];
    [mDict setObject:kRuYiCaiPlatform forKey:@"platform"];
    [mDict setObject:kRuYiCaiVersion forKey:@"softwareversion"];
    [mDict setObject:deviceName forKey:@"machineid"];
    [mDict setObject:@"" forKey:@"imei"];
    [mDict setObject:@"" forKey:@"imsi"];
    [mDict setObject:kRuYiCaiCoopid forKey:@"coopid"];
    //    [mDict setObject:@"" forKey:@"smscenter"];
    
    [mDict setObject:@"1" forKey:@"isCompress"];
    if(KISHighVersion_7) {
//        if ([[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]) {//> ios 6.0
//            [mDict setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"mac"];
//        }
        if ([[[UIDevice currentDevice] identifierForVendor] UUIDString]) {
             [mDict setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"mac"];
        }
    }
    else
    {
        if([RYCNetworkManager macaddress])
            [mDict setObject:[RYCNetworkManager macaddress] forKey:@"mac"];
    }
    return mDict;
}



//  获取mac 地址
+ (NSString *)macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

#pragma mark RuYiCai test Net connect
- (BOOL)testConnection {
    BOOL result = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.sina.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            result = NO;//网络无连接
            break;
        case ReachableViaWWAN:// 使用3G网络
            result = YES;
            break;
        case ReachableViaWiFi: // 使用WiFi
            result = YES;
            break;
    }
    return result;
}
#pragma mark base64 method
+ (NSData * )decodeBase64:(NSData * )_data
{
    //NSData * data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    // 转换到base64
    _data = [GTMBase64 decodeData:_data];
    //NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return _data;
}

+ (NSString*)encodeBase64:(NSData*)data
{
    //转换到base64
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding];
    return [base64String autorelease];
}
@end
