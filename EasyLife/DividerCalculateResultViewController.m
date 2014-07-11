//
//  DividerCalculateResultViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 7/4/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "DividerCalculateResultViewController.h"
#import "RQShineLabel.h"

@interface DividerCalculateResultViewController ()
@property (strong, nonatomic) RQShineLabel *label;
@end

@implementation DividerCalculateResultViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _label = [[RQShineLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _label.numberOfLines = 0;
    _label.backgroundColor = [UIColor blackColor];
    _label.text = @"This is a test. Hello world!";
    _label.textColor = [UIColor whiteColor];
    
    [self.view addSubview:_label];
    [_label shine];
}


@end
