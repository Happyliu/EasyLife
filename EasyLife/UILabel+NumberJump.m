//
//  UILabel+NumberJump.m
//  EasyLife
//
//  Created by 张 子豪 on 7/9/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "UILabel+NumberJump.h"

#define kPointsNumber 100

@implementation UILabel (NumberJump)

NSMutableArray *numberPoints;//记录每次textLayer更改值的间隔时间及输出值。
float lastTime;
int indexNumber;

Point2D startPoint;
Point2D controlPoint1;
Point2D controlPoint2;
Point2D endPoint;

int _duration;
double _startNumber;
double _endNumber;

- (void)cleanUpValue {
    lastTime = 0;
    indexNumber = 0;
    self.text = [NSString stringWithFormat:@"$%.2f",_startNumber];
}

- (void)jumpNumberWithDuration:(int)duration
                    fromNumber:(double)startNumber
                      toNumber:(double)endNumber {
    _duration = duration;
    _startNumber = startNumber;
    _endNumber = endNumber;
    
    [self cleanUpValue];
    [self initPoints];
    [self changeNumberBySelector];
}

- (void)initPoints {
    [self initBezierPoints];
    Point2D bezierCurvePoints[4] = {startPoint, controlPoint1, controlPoint2, endPoint};
    numberPoints = [[NSMutableArray alloc] init];
    float dt;
    dt = 1.0 / (kPointsNumber - 1);
    for (int i = 0; i < kPointsNumber; i++) {
        Point2D point = PointOnCubicBezier(bezierCurvePoints, i*dt);
        float durationTime = point.x * _duration;
        double value = point.y * (_endNumber - _startNumber) + _startNumber;
        [numberPoints addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:durationTime], [NSNumber numberWithDouble:value], nil]];
    }
}

- (void)initBezierPoints {
    
    startPoint.x = 0;
    startPoint.y = 0;
    
    controlPoint1.x = 0.25;
    controlPoint1.y = 0.1;
    
    controlPoint2.x = 0.25;
    controlPoint2.y = 1;
    
    endPoint.x = 1;
    endPoint.y = 1;
}

- (void)changeNumberBySelector {
    if (indexNumber >= kPointsNumber) {
        self.text = [NSString stringWithFormat:@"$%.2f",_endNumber];
        return;
    } else {
        NSArray *pointValues = [numberPoints objectAtIndex:indexNumber];
        indexNumber++;
        double value = [(NSNumber *)[pointValues objectAtIndex:1] doubleValue];
        float currentTime = [(NSNumber *)[pointValues objectAtIndex:0] floatValue];
        float timeDuration = currentTime - lastTime;
        lastTime = currentTime;
        self.text = [NSString stringWithFormat:@"$%.2f",value];
        [self performSelector:@selector(changeNumberBySelector) withObject:nil afterDelay:timeDuration];
    }
}

@end
