//
//  MoreSettingViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-4.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "MoreSettingViewController.h"

@interface MoreSettingViewController ()

@end

@implementation MoreSettingViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark ============= viewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setSettingTitleView];
    
    UIView * headView   = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 908, 650)];
    headView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:headView];
    [headView release];
    
    UILabel * setLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 30)];
    setLabel.text       = @"自动登录设置";
    setLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:setLabel];
    [setLabel release];
    
    UISwitch * setSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(700, setLabel.frame.origin.y, 100, 30)];
     NSString * ranState = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveRandomSate];
    if ([ranState isEqualToString:@"0"]) {
        setSwitch.on = NO;
    }else{
        setSwitch.on = YES;
    }
    [setSwitch addTarget:self action:@selector(loginAutoSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [headView addSubview:setSwitch];
    [setSwitch release];
    
    
    UILabel* warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 60, 800, 50)];
    warnLabel.text = @"提示：只能设置关闭自动登录，如需开启请到登录页面勾选“记住我的登录状态”并登录。";
    warnLabel.font = [UIFont systemFontOfSize:15.0f];
    warnLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:103.0/255.0 blue:106.0/255.0 alpha:1.0];
    warnLabel.backgroundColor = [UIColor clearColor];
    warnLabel.numberOfLines = 2;
    [headView addSubview:warnLabel];
    [warnLabel release];
//    UITableView *setTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 70, 908, 650) style:UITableViewStylePlain];
//    setTableView.delegate = self;
//    setTableView.dataSource = self;
//    [self.view addSubview:setTableView];
//    [setTableView release];
}
- (void)dealloc
{
    [super dealloc];
}
- (void)loginAutoSwitchAction:(id)sender
{
    UISwitch * mySwitch = (UISwitch *)sender;
    if (mySwitch.on) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kSaveRandomSate];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kSaveRandomSate];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setSettingTitleView
{
    [super tabBarBackgroundImageViewWith:self.view];

    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(400, 10, 150, 40)];
    titleLabel.text = @"登录设置";
    titleLabel.backgroundColor =[UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =[UIColor whiteColor];
    titleLabel.font =[UIFont systemFontOfSize:25];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UIButton * fundBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    fundBackBtn.frame =CGRectMake(10, 10, 50, 50);
    [fundBackBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [fundBackBtn addTarget:self action:@selector(settingBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fundBackBtn];
    
}
#pragma mark =========== methods
- (void)settingBackButtonAction:(id)sender
{
    [self.delegate moreSettingViewDisappear:self];
}
#pragma mark ============ tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell = @"celled";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dequeCell]autorelease];
    }
    NSArray *array = @[@"登陆设置",@"服务设置",@"彩种购买设置",@"微博设置",@"彩种显示设置",@"方案存档功能设置"];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}
@end
