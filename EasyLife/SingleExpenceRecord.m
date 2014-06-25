//
//  SingleExpenceRecord.m
//  EasyLife
//
//  Created by 张 子豪 on 6/23/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "SingleExpenceRecord.h"

@implementation SingleExpenceRecord

- (NSString *)paymentPurpose
{
    if (!_paymentPurpose)
        _paymentPurpose = @"";
    return _paymentPurpose;
}

- (NSString *)payerName
{
    if (!_payerName)
        _payerName = @"";
    return _payerName;
}

- (NSString *)description
{
    if (!_description) {
        _description = @"";
    }
    return _description;
}

- (NSString *)amount
{
    if (!_amount) {
        _amount = @"";
    }
    return _amount;
}

- (BOOL)isEmpty
{
    if ([self.paymentPurpose isEqualToString:@""] && [self.payerName isEqualToString:@""] && [self.description isEqualToString:@""] && [self.amount isEqualToString:@""]) {
        return true;
    }
    return false;
}
- (BOOL)isValid
{
    if (self.isEmpty) {
        return false;
    } else if ([self.payerName isEqualToString:@""]) {
        return false;
    } else if ([self.amount isEqualToString:@""]){
        return false;
    }
    
    return true;
}

@end
