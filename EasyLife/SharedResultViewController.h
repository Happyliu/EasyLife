//
//  SharedResultViewController.h
//  EasyLife
//
//  Created by 张 子豪 on 4/20/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface SharedResultViewController : UIViewController
//in
@property double totalSharedAmount;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//out
@property (nonatomic, readonly) Record *addedRecord;
@end
