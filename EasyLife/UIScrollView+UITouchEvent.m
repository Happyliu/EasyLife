//
//  UIScrollView+UITouchEvent.m
//  EasyLife
//
//  Created by 张 子豪 on 7/1/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "UIScrollView+UITouchEvent.h"

@implementation UIScrollView (UITouchEvent)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

@end
