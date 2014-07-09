//
//  CATextLayer+NumberJump.h
//  BZNumberJumpDemo
//
//  Created by Bruce on 14-7-1.
//  Copyright (c) 2014年 com.Bruce.Number. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NJDBezierCurve.h"

@interface CATextLayer (NumberJump)

- (void)jumpNumberWithDuration:(int)duration
                    fromNumber:(double)startNumber
                      toNumber:(double)endNumber;

@end
