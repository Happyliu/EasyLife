//
//  Record+Annotation.m
//  EasyLife
//
//  Created by 张 子豪 on 5/12/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "Record+Annotation.h"

@implementation Record (Annotation)

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    
    return coordinate;
}

- (NSString *)title
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *title = [dateFormatter stringFromDate:self.date];
    return title;
}

- (NSString *)subtitle
{
    NSString *subtitle = [NSString stringWithFormat:@"$%@", self.amount];
    return subtitle;
}
@end
