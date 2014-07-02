//
//  AppDelegate.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RYCCommon.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //友盟分享的内容
    [MobClick startWithAppkey:@"53b20dc856240becb905c445" reportPolicy:SENDDAILY channelId:kRuYiCaiCoopid];
    
    NSString *verson = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:verson];
    //开机联网
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"softwareupdate" forKey:@"command"];
    //自动登录
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kSaveRandomSate] isEqualToString:@"1"]) {
        [mDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KSaveRandomNumberKey] forKey:@"randomNumber"];
    }
    
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeSoftUpdate showProgress:NO];

    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //viewcontroller
    HomeViewController * controller =[[HomeViewController alloc]init];
    self.window.rootViewController = controller;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.window.frame =  CGRectMake(20.0f,0.0f,self.window.frame.size.width,self.window.frame.size.height);
//    }
    
    [self.window makeKeyAndVisible];
    [controller release];

    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark 推送
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"嘻嘻嘻嘻 My token is: %@", deviceToken);
    NSString* tokenStr = [deviceToken description];
    //NSLog(@"%d", tokenStr.length);
    [CommonRecordStatus commonRecordStatusManager].deviceToken = [tokenStr substringWithRange:NSMakeRange(1, tokenStr.length - 2)];
    NSLog(@"%@",[CommonRecordStatus commonRecordStatusManager].deviceToken);
    
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"saveToken" forKey:@"requestType"];
    
    //自动登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kSaveRandomSate] && [[[NSUserDefaults standardUserDefaults] objectForKey:KSaveRandomNumberKey] length] > 0) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveRandomNumberKey];
        [mDict setObject:str forKey:@"randomNumber"];
    }
    if([CommonRecordStatus commonRecordStatusManager].deviceToken)//推送
        [mDict setObject:[CommonRecordStatus commonRecordStatusManager].deviceToken forKey:@"token"];
    [mDict setObject:kTokenType forKey:@"type"];
    
    [[RYCNetworkManager sharedManager] setNetDelegate:nil];
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:0 showProgress:NO];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"呜呜呜呜 Failed to get token, error: %@", error);
    [CommonRecordStatus commonRecordStatusManager].deviceToken = @"";
}

@end
