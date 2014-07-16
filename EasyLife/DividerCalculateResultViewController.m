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
@property (strong, nonatomic) UIScrollView *resultScrollView;
@property BOOL isComplete;
@property (strong, nonatomic) NSMutableDictionary *payerAmountDict, *payerInformationDict;
@property double totalAmount;
@end

@implementation DividerCalculateResultViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.totalAmount = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.isComplete)
        [self.indicator stopAnimating];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.resultLabel removeFromSuperview];
    [self.resultScrollView removeFromSuperview];
    [self.payerInformationDict removeAllObjects];
    [self.payerAmountDict removeAllObjects];
}


- (void)setExpenseRecords:(NSArray *)expenseRecords
{
    [self.indicator startAnimating];
    
    if (_expenseRecords != expenseRecords) {
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
            self.totalAmount += [[self.payerAmountDict valueForKey:key] doubleValue];
            [resultText appendString:[NSString stringWithFormat:@"Total Amount for %@ is %.2f", key, [[self.payerAmountDict valueForKey:key] doubleValue]]];
            [resultText appendString:@"\n"];
            [resultText appendString:[NSString stringWithFormat:@"%f", self.totalAmount]];
            [resultText appendString:@"\n"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isComplete = YES;
            self.resultLabel.text = [resultText copy];
            [self.indicator stopAnimating];
            [self.view addSubview:self.resultScrollView];
            [self.resultScrollView addSubview:self.resultLabel];
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
        [_resultLabel.layer setBorderWidth:1.0];
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
