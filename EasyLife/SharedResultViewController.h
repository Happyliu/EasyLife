//
//  SharedResultViewController.h
//  EasyLife
//
//  Created by 张 子豪 on 4/20/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharedResultViewController : UIViewController
@property float totalSharedAmount;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
