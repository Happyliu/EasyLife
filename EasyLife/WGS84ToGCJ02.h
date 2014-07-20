//
//  WGS84ToGCJ02.h
//  EasyLife
//
//  Created by 张 子豪 on 7/20/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGS84ToGCJ02 : NSObject
//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocation *)transformFromWGSToGCJ:(CLLocation *)wgsLoc;
@end
