//
//  SingleExpenceRecordView.m
//  EasyLife
//
//  Created by 张 子豪 on 6/28/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "SingleExpenceRecordView.h"
#import "EasyLifeAppDelegate.h"
#import "JVFloatLabeledTextField.h"
#import "DIDatepicker.h"

#define PADDING 20.0

@interface SingleExpenceRecordView () <UITextFieldDelegate>

@end

@implementation SingleExpenceRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        DIDatepicker *datePicker = [[DIDatepicker alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
        [datePicker fillCurrentMonth];
        datePicker.selectedDateBottomLineColor = appDelegate.appSecondColor;
        [datePicker selectDateAtIndex:3];
        
        JVFloatLabeledTextField *expencePayerTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(PADDING,datePicker.frame.size.height, self.frame.size.width, frame.size.height/4)];
        expencePayerTextField.font = [UIFont systemFontOfSize:18];
        expencePayerTextField.floatingLabelFont = [UIFont systemFontOfSize:12];
        expencePayerTextField.floatingLabelYPadding = [NSNumber numberWithInt:1];
        expencePayerTextField.delegate = self;
        expencePayerTextField.placeholder = @"Payer Name";
        
        [self addSubview:datePicker];
        [self addSubview:expencePayerTextField];
        
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
