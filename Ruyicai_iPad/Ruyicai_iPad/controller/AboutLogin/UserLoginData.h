//
//  UserLoginData.h
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KSaveUserNameKey        @"UserName"
#define KSaveRandomNumberKey    @"RandomNum"
#define kSaveRandomSate         @"RandomState"//为1为自动登陆
#define kSavePassWordKey        @"UserPassWord"
#define kSaveRealName           @"UserRealName"
#define kSaveRealCard           @"UserRealCardId"
#define kSaveBetBalance         @"UserBetBalance"

@interface UserLoginData : NSObject

@property(nonatomic, assign) BOOL       hasLogin;           //是否已经登陆
@property(nonatomic, retain) NSString   * userPass;         //密码
@property(nonatomic, retain) NSString   * userNo;           //编号
@property (nonatomic,retain) NSString   * userRealName;     // 真实姓名
@property (nonatomic,retain) NSString   * userRealCard;     // 真实身份证号
@property (nonatomic,retain) NSString   * userDrawbalance;  // 可提现金额

+ (UserLoginData *)sharedManager;
- (void)saveUserName:(NSString*)userName AndrandomNumber:(NSString*)randomNum andUserPassword:(NSString *)password;//保存用户名和自动登陆随机码
- (void)saveUserRealName:(NSString *)realName andUserRealCardId:(NSString *)realCard; // 身份证信息 保存
- (void)clearUserInfomation; //清空数据
@end
