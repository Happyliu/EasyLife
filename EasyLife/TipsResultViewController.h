//
//  TipsResultTableViewController.h
//  BuBuCal
//
//  Created by 张 子豪 on 4/18/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface TipsResultViewController : UIViewController
// in
@property float totalAmount;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
// out
@property (nonatomic, readonly) Record *addedRecord;
@end
