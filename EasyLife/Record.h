//
//  Record.h
//  EasyLife
//
//  Created by 张 子豪 on 5/11/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSDate * date;

@end
