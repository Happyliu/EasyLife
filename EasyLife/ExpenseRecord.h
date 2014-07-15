//
//  ExpenseRecord.h
//  EasyLife
//
//  Created by 张 子豪 on 7/15/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseRecord : NSObject
@property (strong, nonatomic) NSString *expensePayerName;
@property (strong, nonatomic) NSString *expenseDescription;
@property (strong, nonatomic) NSNumber *expenseAmount;
@property (strong, nonatomic) NSDate *expenseDate;
@end
