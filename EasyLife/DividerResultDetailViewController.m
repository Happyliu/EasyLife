//
//  DividerResultDetailViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 7/29/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "DividerResultDetailViewController.h"
#import "ExpenseRecord.h"
#import "EasyLifeAppDelegate.h"

@interface DividerResultDetailViewController () <UITextViewDelegate>
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appRedColor, *appBlackColor;
@property (strong, nonatomic) NSMutableString *resultString;
@end

@implementation DividerResultDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *keys = [self.resultDetailDict allKeys];
    for (NSString *key in keys) {
        NSArray *array = [self.resultDetailDict valueForKey:key];
        [self.resultString appendString:[NSString stringWithFormat:@"%@\n", key]];
        for (ExpenseRecord *record in array) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.resultString appendString:[NSString stringWithFormat:@"  •  %@\n", [formatter stringFromDate:record.expenseDate]]];
            [self.resultString appendString:[NSString stringWithFormat:@"     %@\n", record.expenseDescription]];
        }
        [self.resultString appendString:@"\n"];
    }
    [self.view setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goingDown:)];
    [self.view addGestureRecognizer:tap];
}

- (void)goingDown:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    if (touchPoint.y < 80) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.resultTextView.text = [self.resultString copy];
    [self.view addSubview:self.resultTextView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.resultTextView removeFromSuperview];
}

#pragma mark - AppColor

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

- (UIColor *)appRedColor
{
    if (!_appRedColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appRedColor = appDelegate.appRedColor;
    }
    return _appRedColor;
}

- (UIColor *)appBlackColor
{
    if (!_appBlackColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appBlackColor = appDelegate.appBlackColor;
    }
    return _appBlackColor;
}

- (UITextView *)resultTextView
{
    if (!_resultTextView) {
        _resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80)];
        _resultTextView.font = [UIFont systemFontOfSize:16.0];
        [_resultTextView setEditable:NO];
        [_resultTextView setSelectable:NO];
        [_resultTextView setTextContainerInset:UIEdgeInsetsMake(30, 20, 20, 20)];
        [_resultTextView.layer setCornerRadius:10];
    }
    return _resultTextView;
}

- (NSMutableString *)resultString
{
    if (!_resultString) {
        _resultString = [[NSMutableString alloc] init];
    }
    return _resultString;
}


@end
