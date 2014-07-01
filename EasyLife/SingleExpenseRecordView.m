//
//  SingleexpenseRecordView.m
//  EasyLife
//
//  Created by 张 子豪 on 6/28/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "SingleExpenseRecordView.h"
#import "EasyLifeAppDelegate.h"

const static CGFloat textFieldMargin = 10.0f;
const static CGFloat textFieldHeight = 50.0f;
const static CGFloat textFieldFontSize = 17.0f;
const static CGFloat floatingTextFieldFontSize = 12.0f;
const static CGFloat marginBetweenTextField = 3.5f;

@interface SingleExpenseRecordView ()
@property (nonatomic, readwrite) DIDatepicker *datePicker;
@property (nonatomic, readwrite) JVFloatLabeledTextField *expensePayerTextField, *expenseAmountTextField;
@end

@implementation SingleExpenseRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        self.datePicker.selectedDateBottomLineColor = appDelegate.appSecondColor;
        
//        JVFloatLabeledTextField *expenseDescriptionTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(textFieldMargin ,datePicker.frame.size.height + expensePayerTextField.frame.size.height, self.frame.size.width - 2 * textFieldMargin, textFieldHeight)];
//        expenseDescriptionTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
//        expenseDescriptionTextField.floatingLabelFont = [UIFont systemFontOfSize:floatingTextFieldFontSize];
//        expenseDescriptionTextField.floatingLabelYPadding = [NSNumber numberWithInt:3];
//        expenseDescriptionTextField.delegate = self;
//        expenseDescriptionTextField.placeholder = @"Description";
//        expenseDescriptionTextField.clearButtonMode = YES;
//        expenseDescriptionTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        
        UIView *div1 = [UIView new];
        div1.frame = CGRectMake(textFieldMargin, self.expensePayerTextField.frame.origin.y + self.expensePayerTextField.frame.size.height,
                                self.frame.size.width - 2 * textFieldMargin, 1.0f);
        div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        
        [self addSubview:self.datePicker];
        [self addSubview:self.expensePayerTextField];
        [self addSubview:self.expenseAmountTextField];
//        [self addSubview:expenseDescriptionTextField];
        [self addSubview:div1];
        
    }
    return self;
}

- (DIDatepicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[DIDatepicker alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 55)];
        [_datePicker fillCurrentMonth];
        [_datePicker selectDateAtIndex:3];
    }
    return _datePicker;
}

- (JVFloatLabeledTextField *)expensePayerTextField
{
    if (!_expensePayerTextField) {
        _expensePayerTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(textFieldMargin, self.datePicker.frame.size.height + marginBetweenTextField, self.frame.size.width/2 - textFieldMargin, textFieldHeight)];
        _expensePayerTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
        _expensePayerTextField.floatingLabelFont = [UIFont systemFontOfSize:floatingTextFieldFontSize];
        _expensePayerTextField.floatingLabelYPadding = [NSNumber numberWithInt:3];
        _expensePayerTextField.placeholder = @"Payer Name";
        _expensePayerTextField.clearButtonMode = YES;
        _expensePayerTextField.returnKeyType = UIReturnKeyDone;
        _expensePayerTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    }
    return _expensePayerTextField;
}

- (JVFloatLabeledTextField *)expenseAmountTextField
{
    if (!_expenseAmountTextField) {
        _expenseAmountTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.datePicker.frame.size.height + marginBetweenTextField, self.frame.size.width/2 - textFieldMargin, textFieldHeight)];
        _expenseAmountTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
        _expenseAmountTextField.floatingLabelFont = [UIFont systemFontOfSize:floatingTextFieldFontSize];
        _expenseAmountTextField.floatingLabelYPadding = [NSNumber numberWithInt:3];
        _expenseAmountTextField.placeholder = @"Amount";
        _expenseAmountTextField.clearButtonMode = YES;
        _expenseAmountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _expenseAmountTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    }
    return _expenseAmountTextField;
}

- (BOOL)isEmpty
{
    return NO;
}

- (BOOL)isValid
{
    return YES;
}

@end
