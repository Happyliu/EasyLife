//
//  DividerResultDetailViewController.h
//  EasyLife
//
//  Created by 张 子豪 on 7/29/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DALinedTextView.h"

@interface DividerResultDetailViewController : UIViewController
//in
@property (strong, nonatomic) NSDictionary *resultDetailDict;
@property (strong, nonatomic) DALinedTextView *resultTextView;
@end
