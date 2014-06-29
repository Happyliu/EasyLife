//
//  DividerViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 6/19/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "DividerViewController.h"
#import "EasyLifeAppDelegate.h"
#import "SingleExpenceRecordView.h"


@interface DividerViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
@property (strong, nonatomic) NSMutableArray *SingleExpenceRecordViews;
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

    
    SingleExpenceRecordView *test = [[SingleExpenceRecordView alloc] initWithFrame:CGRectMake(0, 0, self.dividerScrollView.frame.size.width, 150)];
    //[self.dividerScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    test.layer.borderWidth = 1.0;
    test.layer.borderColor = [UIColor blackColor].CGColor;
    
    SingleExpenceRecordView *test2 = [[SingleExpenceRecordView alloc] initWithFrame:CGRectMake(0, 150, self.dividerScrollView.frame.size.width, 150)];
    test2.layer.borderWidth = 1.0;
    test2.layer.borderColor = [UIColor blackColor].CGColor;

    [self.dividerScrollView addSubview:test];
    [self.dividerScrollView addSubview:test2];
}

@end
