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
const static CGFloat marginBetweenTextField = 2.5f;

@interface SingleExpenseRecordView ()
@property (nonatomic, readwrite) DIDatepicker *datePicker;
@property (nonatomic, readwrite) JVFloatLabeledTextField *expensePayerTextField, *expenseAmountTextField;
@property (nonatomic, readwrite) JVFloatLabeledTextField *expenseDescriptionTextField;
@property (nonatomic, strong) UIView *horizontalLine, *verticalLine;
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appRedColor, *appBlackColor;
@end

@implementation SingleExpenseRecordView

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        self.datePicker.selectedDateBottomLineColor = appDelegate.appSecondColor;
        
        [self addSubview:self.datePicker];
        [self addSubview:self.expensePayerTextField];
        [self addSubview:self.expenseAmountTextField];
        [self addSubview:self.expenseDescriptionTextField];
        [self addSubview:self.horizontalLine];
        [self addSubview:self.verticalLine];
    }
    return self;
}

- (void)dealloc
{
    [self.horizontalLine removeFromSuperview];
    [self.verticalLine removeFromSuperview];
}

- (DIDatepicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[DIDatepicker alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 55)];
        NSDate *today = [NSDate date];
        NSDate *startDate = [today dateByAddingTimeInterval:-60*60*24*60];
        [_datePicker fillDatesFromDate:startDate numberOfDays:63];
        [_datePicker selectDateAtIndex:[_datePicker.dates  count] - 3];
    }
    return _datePicker;
}

- (JVFloatLabeledTextField *)expensePayerTextField
{
    if (!_expensePayerTextField) {
        _expensePayerTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(self.frame.size.width/5 * 2 + self.verticalLine.frame.size.width + textFieldMargin, self.horizontalLine.frame.origin.y + self.horizontalLine.frame.size.height + marginBetweenTextField, self.frame.size.width/5 * 3 - textFieldMargin, textFieldHeight)];
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
        _expenseAmountTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(textFieldMargin, self.horizontalLine.frame.origin.y + self.horizontalLine.frame.size.height + marginBetweenTextField, self.frame.size.width/5 * 2 - textFieldMargin * 2, textFieldHeight)];
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

- (JVFloatLabeledTextField *)expenseDescriptionTextField
{
    if (!_expenseDescriptionTextField) {
        _expenseDescriptionTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(textFieldMargin, self.datePicker.frame.size.height + marginBetweenTextField, self.frame.size.width - 2 * textFieldMargin, textFieldHeight)];
        _expenseDescriptionTextField.font = [UIFont systemFontOfSize:textFieldFontSize];
        _expenseDescriptionTextField.floatingLabelFont = [UIFont systemFontOfSize:floatingTextFieldFontSize];
        _expenseDescriptionTextField.floatingLabelYPadding = [NSNumber numberWithInt:3];
        _expenseDescriptionTextField.placeholder = @"Description";
        _expenseDescriptionTextField.clearButtonMode = YES;
        _expenseDescriptionTextField.returnKeyType = UIReturnKeyDone;
        _expenseDescriptionTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    }
    return _expenseDescriptionTextField;
}

- (UIView *)horizontalLine
{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.frame = CGRectMake(textFieldMargin, self.expenseDescriptionTextField.frame.origin.y + self.expenseDescriptionTextField.frame.size.height,
                                self.frame.size.width - 2 * textFieldMargin, 1.0f);
        _horizontalLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    }
    return _horizontalLine;
}

- (UIView *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.frame = CGRectMake(self.expenseAmountTextField.frame.size.width + 2 * textFieldMargin, self.horizontalLine.frame.origin.y + self.horizontalLine.frame.size.height + marginBetweenTextField, 1.0f, textFieldHeight);
        _verticalLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    }
    return _verticalLine;
}

- (BOOL)isEmpty
{
    if ([self.expenseDescriptionTextField.text isEqualToString:@""] && [self.expenseAmountTextField.text isEqualToString:@""] && [self.expensePayerTextField.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (BOOL)isValid
{
    if ([self.expensePayerTextField.text isEqualToString:@""] || [self.expenseAmountTextField.text doubleValue] <= 0) {
        return NO;
    }
    return YES;
}

@end
