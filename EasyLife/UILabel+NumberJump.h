//
//  UILabel+NumberJump.h
//  EasyLife
//
//  Created by 张 子豪 on 7/9/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJDBezierCurve.h"

@interface UILabel (NumberJump)

- (void)jumpNumberWithDuration:(int)duration
                    fromNumber:(double)startNumber
                      toNumber:(double)endNumber;


@end
