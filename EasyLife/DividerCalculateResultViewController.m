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

@interface DividerCalculateResultViewController ()
@property (strong, nonatomic) RQShineLabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UIScrollView *resultScrollView;
@property (strong, nonatomic) NSMutableDictionary *payerAmountDict, *payerInformationDict;
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
@end

@implementation DividerCalculateResultViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isComplete) {
        [self.view addSubview:self.resultScrollView];
        [self.resultScrollView addSubview:self.resultLabel];
        [self.resultLabel sizeToFit];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.resultLabel removeFromSuperview];
    [self.resultScrollView removeFromSuperview];
    [self.payerInformationDict removeAllObjects];
    [self.payerAmountDict removeAllObjects];
}

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


- (void)setExpenseRecords:(NSArray *)expenseRecords
{
    [self.indicator startAnimating];
    if (_expenseRecords != expenseRecords) {
        _expenseRecords = expenseRecords;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        double totalAmount = 0;
        NSMutableString *resultText = [[NSMutableString alloc] init];
        
        for (ExpenseRecord *record in self.expenseRecords) {
            if (![[self.payerAmountDict allKeys] containsObject:record.expensePayerName]) {
                [self.payerAmountDict setValue:record.expenseAmount forKey:record.expensePayerName];
                totalAmount += [record.expenseAmount doubleValue];
            } else {
                double currentAmount = [[self.payerAmountDict valueForKey:record.expensePayerName] doubleValue];
                double newAmount = [record.expenseAmount doubleValue];
                totalAmount += newAmount;
                newAmount += currentAmount;
                [self.payerAmountDict setValue:[NSNumber numberWithDouble:newAmount] forKey:record.expensePayerName];
            }
        }
        
        double averageAmount = [[NSString stringWithFormat:@"%.2f", totalAmount / [self.payerAmountDict count]] doubleValue];
        
        NSMutableArray *sortedKeys = [[self.payerAmountDict keysSortedByValueUsingSelector:@selector(compare:)] mutableCopy]; // sort the dictionary
        
        for (NSString *sortedKey in sortedKeys) {
            /* calculate the amount with the average value */
            [self.payerAmountDict setValue:[NSNumber numberWithDouble:averageAmount - [[self.payerAmountDict valueForKey:sortedKey] doubleValue]] forKey:sortedKey];
        }

        while ([sortedKeys count]) {
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
            
            if (negativeValue + positiveValue > 0) {
                [resultText appendString:[NSString stringWithFormat:@"%@ please give $%.2f to %@.\n", [sortedKeys firstObject], -negativeValue, [sortedKeys lastObject]]];
                positiveValue += negativeValue;
                [self.payerAmountDict setValue:[NSNumber numberWithDouble:positiveValue] forKey:[sortedKeys firstObject]];
                [sortedKeys removeObject:[sortedKeys lastObject]];
            } else if (negativeValue + positiveValue < 0) {
                [resultText appendString:[NSString stringWithFormat:@"%@ please give $%.2f to %@.\n", [sortedKeys firstObject], positiveValue, [sortedKeys lastObject]]];
                negativeValue += positiveValue;
                [self.payerAmountDict setValue:[NSNumber numberWithDouble:negativeValue] forKey:[sortedKeys lastObject]];
                [sortedKeys removeObject:[sortedKeys firstObject]];
            } else {
                [resultText appendString:[NSString stringWithFormat:@"%@ please give $%.2f to %@.\n", [sortedKeys firstObject], positiveValue, [sortedKeys lastObject]]];
                [sortedKeys removeObject:[sortedKeys firstObject]];
                [sortedKeys removeObject:[sortedKeys lastObject]];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.isComplete = YES;
            self.resultLabel.text = [resultText copy];
            [self.indicator stopAnimating];
            [self.view addSubview:self.resultScrollView];
            [self.resultScrollView addSubview:self.resultLabel];
            [self.resultLabel setBackgroundColor:self.appThirdColor];
            [self.resultLabel sizeToFit];
            [self.resultLabel shine];
        });
    });
}

- (UIScrollView *)resultScrollView
{
    if (!_resultScrollView) {
        _resultScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _resultScrollView;
}

- (RQShineLabel *)resultLabel
{
    if (!_resultLabel) {
        _resultLabel = [[RQShineLabel alloc] initWithFrame:CGRectMake(self.resultScrollView.frame.origin.x + 10, self.resultScrollView.frame.origin.y + 10, self.resultScrollView.frame.size.width - 20, self.resultScrollView.frame.size.height - 20)];
        _resultLabel.textColor = [UIColor blackColor];
        _resultLabel.numberOfLines = 0;
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


@end
