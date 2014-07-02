//
//  DividerViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 6/19/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "DividerViewController.h"
#import "EasyLifeAppDelegate.h"
#import "SingleExpenseRecordView.h"
#import "UIScrollView+UITouchEvent.h"


@interface DividerViewController () <UITextFieldDelegate>
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
@property (strong, nonatomic) NSMutableArray *singleExpenseRecordViews;
@property (weak, nonatomic) IBOutlet UIScrollView *dividerScrollView;
@end

@implementation DividerViewController

#pragma mark - Initialize app colors

- (UIColor *)appTintColor
{
    if (!_appTintColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appTintColor = appDelegate.appTintColor;
    }
    return _appTintColor;
}

- (UIColor *)appSecondColor
{
    if (!_appSecondColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appSecondColor = appDelegate.appSecondColor;
    }
    return _appSecondColor;
}

- (UIColor *)appThirdColor
{
    if (!_appThirdColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appThirdColor = appDelegate.appThirdColor;
    }
    return _appThirdColor;
}

- (UIColor *)appBlackColor
{
    if (!_appBlackColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appBlackColor = appDelegate.appBlackColor;
    }
    return _appBlackColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = self.appTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // color of the back button
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.tabBarController.tabBar.barTintColor = self.appTintColor;
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SingleExpenseRecordView *test = [[SingleExpenseRecordView alloc] initWithFrame:CGRectMake(0, 0, self.dividerScrollView.frame.size.width, 160)];
    test.layer.borderWidth = 1.0;
    test.layer.borderColor = [UIColor blackColor].CGColor;
    test.expensePayerTextField.delegate = self;
    test.expenseAmountTextField.delegate = self;
    
    [self.singleExpenseRecordViews addObject:test];
    test.tag = [self.singleExpenseRecordViews count];
    SingleExpenseRecordView *test2 = [[SingleExpenseRecordView alloc] initWithFrame:CGRectMake(0, 159, self.dividerScrollView.frame.size.width, 160)];
    test2.layer.borderWidth = 1.0;
    test2.layer.borderColor = [UIColor blackColor].CGColor;
    test2.expensePayerTextField.delegate = self;
    test2.expenseAmountTextField.delegate = self;
    
    
    [self.singleExpenseRecordViews addObject:test2];
    
    test2.tag = [self.singleExpenseRecordViews count];
    self.dividerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, [self.singleExpenseRecordViews count] * 160);
    for (SingleExpenseRecordView *view in self.singleExpenseRecordViews) {
        [self.dividerScrollView addSubview:view];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (SingleExpenseRecordView *view in self.singleExpenseRecordViews) {
        [view removeFromSuperview];
    }
    self.singleExpenseRecordViews = nil;
}

- (NSMutableArray *)singleExpenseRecordViews
{
    if (!_singleExpenseRecordViews) {
        _singleExpenseRecordViews = [[NSMutableArray alloc] init];
    }
    return _singleExpenseRecordViews;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (SingleExpenseRecordView *serv in self.singleExpenseRecordViews) {
        [serv.expensePayerTextField resignFirstResponder];
        [serv.expenseAmountTextField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.superview.tag >= 2) {
        [self.dividerScrollView setContentSize:CGSizeMake(self.dividerScrollView.frame.size.width, [self.singleExpenseRecordViews count] * 160 + 150)];
        CGPoint contentOffset = CGPointMake(0, ((SingleExpenseRecordView *)[self.singleExpenseRecordViews lastObject]).frame.origin.y);
        [self.dividerScrollView setContentOffset:contentOffset animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

@end
