//
//  SingleExpenceRecordView.h
//  EasyLife
//
//  Created by 张 子豪 on 6/28/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "DIDatepicker.h"

@interface SingleExpenseRecordView : UIView
@property (nonatomic, readonly) DIDatepicker *datePicker;
@property (nonatomic, readonly) JVFloatLabeledTextField *expensePayerTextField, *expenseAmountTextField, *expenseDescriptionTextField;;
- (BOOL)isEmpty;
- (BOOL)isValid;
@end
