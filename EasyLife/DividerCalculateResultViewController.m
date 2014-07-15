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

@interface DividerCalculateResultViewController ()
@property (strong, nonatomic) RQShineLabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property BOOL isComplete;
@property (strong, nonatomic) NSMutableDictionary *payerAmountDict;
@end

@implementation DividerCalculateResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.isComplete) {
        [self.indicator startAnimating];
    } else {
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.resultLabel removeFromSuperview];
}


- (void)setExpenseRecords:(NSArray *)expenseRecords
{
    [self.indicator startAnimating];
    
    if (_expenseRecords != expenseRecords) {
        _expenseRecords = nil;
        _expenseRecords = expenseRecords;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (ExpenseRecord *record in self.expenseRecords) {
            if (![[self.payerAmountDict allKeys] containsObject:record.expensePayerName]) {
                [self.payerAmountDict setValue:record.expenseAmount forKey:record.expensePayerName];
            } else {
                double currentAmount = [[self.payerAmountDict valueForKey:record.expensePayerName] doubleValue];
                double newAmount = [record.expenseAmount doubleValue];
                newAmount += currentAmount;
                [self.payerAmountDict setValue:[NSNumber numberWithDouble:newAmount] forKey:record.expensePayerName];
            }
        }
        
        NSMutableString *resultText = [[NSMutableString alloc] init];
        
        for (NSString *key in self.payerAmountDict) {
            [resultText appendString:[NSString stringWithFormat:@"Total Amount for %@ is %.2f", key, [[self.payerAmountDict valueForKey:key] doubleValue]]];
            [resultText appendString:@"\n"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = [resultText copy];
            [self.resultLabel sizeToFit];
            self.isComplete = YES;
            [self.indicator stopAnimating];
            [self.indicator removeFromSuperview];
            [self.view addSubview:self.resultLabel];
            [self.resultLabel shine];
        });
    });
}

- (RQShineLabel *)resultLabel
{
    if (!_resultLabel) {
        _resultLabel = [[RQShineLabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + 10, self.view.frame.size.width - 20, self.view.frame.size.height - 20)];
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


@end
