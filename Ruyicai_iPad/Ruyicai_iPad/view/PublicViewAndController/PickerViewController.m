//
//  PickerViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-15.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@end

@implementation PickerViewController

@synthesize delegate = _delegate;
@synthesize pickerSelectNum;
@synthesize pViewWidch;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [pickerDataArray release];
    [pickerView release];
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor grayColor];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(cancelButton:)];
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(confirmButton:)];
    
    UIBarButtonItem* centerItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    centerItem.width = pViewWidch - 110;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pViewWidch, 44)];
    toolbar.tintColor = kColorWithRGB(100.0, 14.0, 0.0, 1.0);
    [toolbar setItems:[NSArray arrayWithObjects:cancelButton, centerItem, submitButton, nil] animated:YES];
	[self.view addSubview:toolbar];
    
	[toolbar release];
    [centerItem release];
    [cancelButton release];
    [submitButton release];
    
    pickerView =[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, pViewWidch, 216)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    [pickerView setShowsSelectionIndicator:YES];
    
    pickerDataArray =[[NSMutableArray alloc]init];
    pickerSelectNum = 0;
}

/* 确定*/
- (void)confirmButton:(id)sender
{
    [self cancelButton:nil];
    [self.delegate pickerViewController:self selectRowNum:[pickerDataArray objectAtIndex:pickerSelectNum]];
}
/* 取消*/
- (void)cancelButton:(id)sender
{
    [self.delegate pickViewCancelClick];
}
/* 刷新 */
- (void)refreshViewController
{
    [pickerView reloadAllComponents];
     
     pickerSelectNum = 0;
}
/* 传入参数 */
- (void)setPickerViewDataArray:(NSArray *)dataArray selectNum:(NSInteger)selectNum
{
    [pickerDataArray removeAllObjects];
    [pickerDataArray  addObjectsFromArray:dataArray];
    
    pickerSelectNum = selectNum;//首次进入选中的行,默认可传0
    
    [pickerView reloadAllComponents];
    [pickerView selectRow:selectNum inComponent:0 animated:NO];
}

#pragma mark ------------- pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerDataArray  count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   return  [pickerDataArray  objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	pickerSelectNum = row;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
