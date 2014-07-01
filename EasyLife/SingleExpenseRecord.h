//
//  SingleExpenceRecord.h
//  EasyLife
//
//  Created by 张 子豪 on 6/23/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleExpenseRecord : NSObject
@property (strong, nonatomic) NSString *paymentPurpose;
@property (strong, nonatomic) NSString *payerName;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *amount;

- (BOOL)isEmpty;
- (BOOL)isValid;
@end
