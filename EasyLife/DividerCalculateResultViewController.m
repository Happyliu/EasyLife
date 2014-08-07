//
//  DividerCalculateResultViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 7/4/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "DividerCalculateResultViewController.h"
#import "RQShineLabel.h"
#import "ExpenseRecord.h"
#import "EasyLifeAppDelegate.h"
#import "PNChart.h"
#import "DividerResultDetailViewController.h"
#import "ZFModalTransitionAnimator.h"

@interface DividerCalculateResultViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
@property (strong, nonatomic) RQShineLabel *resultLabel;
@property (strong, nonatomic) PNBarChart *barChart;
@property (strong, nonatomic) UIScrollView *resultScrollView, *chartScrollView;
@property (strong, nonatomic) NSMutableDictionary *payerAmountDict, *payerInformationDict;
@property (strong, nonatomic) ZFModalTransitionAnimator *animator;
@end

@implementation DividerCalculateResultViewController

#pragma mark - ViewLifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isComplete) {
        [self.view addSubview:self.resultScrollView];
        [self.resultScrollView addSubview:self.chartScrollView];
        [self.barChart strokeChart];
        [self.chartScrollView addSubview:self.barChart];
        [self.resultScrollView addSubview:self.resultLabel];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.resultLabel removeFromSuperview];
    [self.barChart removeFromSuperview];
    [self.chartScrollView removeFromSuperview];
    [self.resultScrollView removeFromSuperview];
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

- (UIColor *)appBlackColor
{
    if (!_appBlackColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appBlackColor = appDelegate.appBlackColor;
    }
    return _appBlackColor;
}

#pragma mark - Setter

- (void)setExpenseRecords:(NSArray *)expenseRecords
{
    [self.indicator startAnimating];
    if (_expenseRecords != expenseRecords) {
        _expenseRecords = expenseRecords;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // multithread to calculate
        double totalAmount = 0;
        NSMutableString *resultText = [[NSMutableString alloc] init];
        NSMutableArray *chartKeys, *chartValues;
        
        /* merge the expense of same people using a dictionary, O(n) time, O(n) space */
        for (ExpenseRecord *record in self.expenseRecords) {
            if (![[self.payerAmountDict allKeys] containsObject:record.expensePayerName]) {
                [self.payerAmountDict setValue:record.expenseAmount forKey:record.expensePayerName];
                totalAmount += [record.expenseAmount doubleValue];
                
                NSMutableArray *payerInformationArray = [[NSMutableArray alloc] init];
                [payerInformationArray addObject:record];
                [self.payerInformationDict setValue:payerInformationArray forKey:record.expensePayerName];
            } else {
                double currentAmount = [[self.payerAmountDict valueForKey:record.expensePayerName] doubleValue];
                double newAmount = [record.expenseAmount doubleValue];
                totalAmount += newAmount;
                newAmount += currentAmount;
                [self.payerAmountDict setValue:[NSNumber numberWithDouble:newAmount] forKey:record.expensePayerName];
                
                NSMutableArray *payerInformationArray = [self.payerInformationDict valueForKey:record.expensePayerName];
                [payerInformationArray addObject:record];
            }
        }
        
        double averageAmount = [[NSString stringWithFormat:@"%.2f", totalAmount / [self.payerAmountDict count]] doubleValue]; // calculate the average expense amount
        
        NSMutableArray *sortedKeys = [[self.payerAmountDict keysSortedByValueUsingSelector:@selector(compare:)] mutableCopy]; // sort the dictionary
        
        chartKeys = [[NSMutableArray alloc] initWithCapacity:[sortedKeys count]];
        chartValues = [[NSMutableArray alloc] initWithCapacity:[chartKeys count]];
        for (NSString *sortedKey in sortedKeys) {
            [chartKeys addObject:sortedKey];
            [chartValues addObject:[self.payerAmountDict valueForKey:sortedKey]];
            
            /* calculate the amount with the average value */
            [self.payerAmountDict setValue:[NSNumber numberWithDouble:averageAmount - [[self.payerAmountDict valueForKey:sortedKey] doubleValue]] forKey:sortedKey];
        }
        
        /* core algorithm to calculate */
        while ([sortedKeys count]) {
            
            /* get the first and the last amount and compare the absolute value */
            double positiveValue = [[self.payerAmountDict valueForKey:[sortedKeys firstObject]] doubleValue];
            double negativeValue = [[self.payerAmountDict valueForKey:[sortedKeys lastObject]] doubleValue];
            
            if (positiveValue == 0) {
                [sortedKeys removeObject:[sortedKeys firstObject]];
                continue;
            } else if (negativeValue == 0) {
                [sortedKeys removeObject:[sortedKeys lastObject]];
                continue;
            } else if ([[sortedKeys firstObject] isEqualToString:[sortedKeys lastObject]]) {
                [sortedKeys removeAllObjects];
                continue;
            }
            
            /* compare the amount and decide who should pay for whom */
            if (negativeValue + positiveValue > 0) {
                [resultText appendString:[NSString stringWithFormat:@"•  %@ please pay %@:\n   $%.2f\n\n", [sortedKeys firstObject], [sortedKeys lastObject], -negativeValue]];
                positiveValue += negativeValue;
                [self.payerAmountDict setValue:[NSNumber numberWithDouble:positiveValue] forKey:[sortedKeys firstObject]];
                [sortedKeys removeObject:[sortedKeys lastObject]];
            } else if (negativeValue + positiveValue < 0) {
                [resultText appendString:[NSString stringWithFormat:@"•  %@ please pay %@:\n   $%.2f\n\n", [sortedKeys firstObject], [sortedKeys lastObject], positiveValue]];
                negativeValue += positiveValue;
                [self.payerAmountDict setValue:[NSNumber numberWithDouble:negativeValue] forKey:[sortedKeys lastObject]];
                [sortedKeys removeObject:[sortedKeys firstObject]];
            } else {
                [resultText appendString:[NSString stringWithFormat:@"•  %@ please pay %@:\n   $%.2f\n\n", [sortedKeys firstObject], [sortedKeys lastObject], positiveValue]];
                [sortedKeys removeObject:[sortedKeys firstObject]];
                [sortedKeys removeObject:[sortedKeys lastObject]];
            }
        }
        
        if ([resultText isEqualToString:@""]) { // all people spent the same amount or only one people in the records
            [resultText appendString:@"No one should pay ^_^\n"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{ // get back to the main queue and set the UI
            self.isComplete = YES;
            self.resultLabel.text = [resultText copy];
            [self.indicator stopAnimating];
            [self.view addSubview:self.resultScrollView];
            [self.resultLabel sizeToFit];
            [self.resultScrollView addSubview:self.resultLabel];
            [self.resultLabel shine];
            [self.barChart setXLabels:chartKeys];
            [self.barChart setYValues:chartValues];
            [self.barChart strokeChart];
            [self.barChart setBackgroundColor:[UIColor clearColor]];
            [self.resultScrollView addSubview:self.chartScrollView];
            [self.resultScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.chartScrollView.frame.size.height + self.resultLabel.frame.size.height)];
            [self.chartScrollView addSubview:self.barChart];
            [self.chartScrollView setContentSize:CGSizeMake(self.barChart.frame.size.width, self.barChart.frame.size.height)];
            [self.chartScrollView setScrollEnabled:YES];
        });
    });
}

#pragma mark - LazyInit

- (UIScrollView *)resultScrollView
{
    if (!_resultScrollView) {
        _resultScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_resultScrollView setScrollEnabled:YES];
    }
    return _resultScrollView;
}

- (UIScrollView *)chartScrollView
{
    if (!_chartScrollView) {
        _chartScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 230)];
        [_chartScrollView setBackgroundColor:self.appBlackColor];
    }
    return _chartScrollView;
}

- (RQShineLabel *)resultLabel
{
    if (!_resultLabel) {
        _resultLabel = [[RQShineLabel alloc] initWithFrame:CGRectMake(self.resultScrollView.frame.origin.x + 10, self.barChart.frame.size.height + 10, self.resultScrollView.frame.size.width - 20, self.resultScrollView.frame.size.height - 20)];
        _resultLabel.textColor = self.appBlackColor;
        _resultLabel.numberOfLines = 0;
        [_resultLabel setFont:[UIFont systemFontOfSize:18]];
    }
    return _resultLabel;
}

- (NSMutableDictionary *)payerAmountDict
{
    if (!_payerAmountDict) {
        _payerAmountDict = [[NSMutableDictionary alloc] initWithCapacity:[self.expenseRecords count]];
    }
    return _payerAmountDict;
}

- (NSMutableDictionary *)payerInformationDict
{
    if (!_payerInformationDict) {
        _payerInformationDict = [[NSMutableDictionary alloc] initWithCapacity:[self.expenseRecords count]];
    }
    return _payerInformationDict;
}

- (PNBarChart *)barChart {
    if (!_barChart) {
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, [self.payerAmountDict count] * 80, 230)];
        [_barChart setStrokeColor:self.appSecondColor];
        [_barChart setBarBackgroundColor:[UIColor grayColor]];
        [_barChart setLabelTextColor:[UIColor whiteColor]];
    }
    return _barChart;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Expense Detail"]) {
        DividerResultDetailViewController *detailVC = segue.destinationViewController;
        detailVC.resultDetailDict = [self.payerInformationDict copy];
        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:detailVC];
        self.animator.dragable = YES;
        self.animator.behindViewScale = 1.0f;
        self.animator.behindViewAlpha = 0.6f;
        [self.animator setContentScrollView:detailVC.resultTextView];
        detailVC.transitioningDelegate = self.animator;
        detailVC.modalPresentationStyle = UIModalPresentationCustom;
    }
}

@end
