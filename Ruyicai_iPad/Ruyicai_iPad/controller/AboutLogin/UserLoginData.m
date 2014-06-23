//
//  UserLoginData.m
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "UserLoginData.h"

@implementation UserLoginData

static UserLoginData *s_userLoginData = NULL;

@synthesize userPass;
@synthesize userNo;
@synthesize hasLogin;
@synthesize userRealName;
@synthesize userRealCard;
@synthesize userDrawbalance;

- (void)saveUserName:(NSString*)userName AndrandomNumber:(NSString*)randomNum andUserPassword:(NSString *)password //保存用户名和自动登陆随机码
{
    if (![userName isEqualToString:@""])
    {
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:KSaveUserNameKey];
    }
    if (![randomNum isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kSaveRandomSate];
        [[NSUserDefaults standardUserDefaults] setObject:randomNum forKey:KSaveRandomNumberKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kSaveRandomSate];
    }
    
    if (![password isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:kSavePassWordKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];//同步
}
- (void)saveUserRealName:(NSString *)realName andUserRealCardId:(NSString *)realCard // 身份证信息 保存
{
    if (![realName isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:realName forKey:kSaveRealName];
        
    }
    if (![realCard isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:realCard forKey:kSaveRealCard];
    }
}

- (void)clearUserInfomation
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kSaveRandomSate];
}
#pragma mark------------
- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
	if (self = [super init])
    {
        hasLogin = NO;
        userPass = @"";
        userNo = @"";
        userRealCard = @"";
        userRealName = @"";
        userDrawbalance = @"";
	}
    return self;
}
+ (UserLoginData *)sharedManager
{
    @synchronized(self)
    {
        if (s_userLoginData == nil)
        {
            s_userLoginData = [[self alloc] init];  //assignment not done here
        }
    }
    return s_userLoginData;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (s_userLoginData == nil)
		{
			s_userLoginData = [super allocWithZone:zone];
			return s_userLoginData;  //assignment and return on first allocation
		}
	}
	return nil;  //on subsequent allocation attempts return nil
}
@end
