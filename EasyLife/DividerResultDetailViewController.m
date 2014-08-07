//
//  DividerResultDetailViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 7/29/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "DividerResultDetailViewController.h"
#import "ExpenseRecord.h"
#import "EasyLifeAppDelegate.h"

@interface DividerResultDetailViewController () <UITextViewDelegate>
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appRedColor, *appBlackColor;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) CALayer *backLayerOne, *backLayerTwo;
@property (strong, nonatomic) NSMutableString *resultString;
@end

@implementation DividerResultDetailViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* construct the result NSString */
    NSArray *keys = [self.resultDetailDict allKeys];
    for (NSString *key in keys) {
        NSArray *array = [self.resultDetailDict valueForKey:key];
        [self.resultString appendString:[NSString stringWithFormat:@"%@\n", key]];
        for (ExpenseRecord *record in array) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMMM-dd"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.resultString appendString:[NSString stringWithFormat:@"  •  %@                $%.2f\n", [formatter stringFromDate:record.expenseDate], [record.expenseAmount doubleValue]]];
            [self.resultString appendString:[NSString stringWithFormat:@"     %@\n", record.expenseDescription]];
            [self.resultString appendString:@"\n"];
        }
    }
    [self.resultString deleteCharactersInRange:NSMakeRange([self.resultString length] - 1, 1)]; // delete the last space
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.backgroundView setBackgroundColor:self.appSecondColor];
    [self.backgroundView.layer setCornerRadius:10];
    
    /* add tap gesture to the top position of the view */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goingDown:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.resultTextView.text = [self.resultString copy];
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.resultTextView];
    [self.backgroundView.layer addSublayer:self.backLayerOne];
    [self.backgroundView.layer addSublayer:self.backLayerTwo];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.resultTextView removeFromSuperview];
    [self.backLayerOne removeFromSuperlayer];
    [self.backLayerTwo removeFromSuperlayer];
    [self.backgroundView removeFromSuperview];
    self.resultDetailDict = nil;
}

#pragma mark - GestureHandler

- (void)goingDown:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    if (touchPoint.y < 60) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - AppColor

- (UIColor *)appTintColor
{
    if (!_appTintColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appTintColor = appDelegate.appTintColor;
    }
    return _appTintColor;
}

- (UIColor *)appSecondColor
{
    if (!_appSecondColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appSecondColor = appDelegate.appSecondColor;
    }
    return _appSecondColor;
}

- (UIColor *)appThirdColor
{
    if (!_appThirdColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appThirdColor = appDelegate.appThirdColor;
    }
    return _appThirdColor;
}

- (UIColor *)appRedColor
{
    if (!_appRedColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appRedColor = appDelegate.appRedColor;
    }
    return _appRedColor;
}

- (UIColor *)appBlackColor
{
    if (!_appBlackColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appBlackColor = appDelegate.appBlackColor;
    }
    return _appBlackColor;
}

#pragma mark - LazyInit

- (DALinedTextView *)resultTextView
{
    if (!_resultTextView) {
        _resultTextView = [[DALinedTextView alloc] initWithFrame:CGRectMake(0, 20, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height - 20)];
        _resultTextView.font = [UIFont systemFontOfSize:20.0];
        [_resultTextView setEditable:NO];
        [_resultTextView setSelectable:NO];
        [_resultTextView setTextContainerInset:UIEdgeInsetsMake(29, 20, 0, 20)];
        [_resultTextView setTextColor:self.appBlackColor];
        [_resultTextView setVerticalLineColor:self.appRedColor];
    }
    return _resultTextView;
}

- (NSMutableString *)resultString
{
    if (!_resultString) {
        _resultString = [[NSMutableString alloc] init];
    }
    return _resultString;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    }
    return _backgroundView;
}

- (CALayer *)backLayerOne
{
    if (!_backLayerOne) {
        _backLayerOne = [self tornPaperLayerWithHeight:17];
    }
    return _backLayerOne;
}

- (CALayer *)backLayerTwo
{
    if (!_backLayerTwo) {
        _backLayerTwo = [self tornPaperLayerWithHeight:13];
    }
    return _backLayerTwo;
}

- (CAShapeLayer *)tornPaperLayerWithHeight:(CGFloat)height{
    CGFloat width = MAX(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    CGFloat overshoot = 4;
    CGFloat maxY = height-overshoot;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(-overshoot, 0)];
    CGFloat x = -overshoot;
    CGFloat y = arc4random_uniform(maxY);
    [bezierPath addLineToPoint: CGPointMake(-overshoot, y)];
    
    while(x < width+overshoot){
        y = MAX(maxY-3, arc4random_uniform(maxY));
        x += MAX(4.5, arc4random_uniform(12.5));
        [bezierPath addLineToPoint: CGPointMake(x, y)];
    }
    
    y = arc4random_uniform(maxY);
    [bezierPath addLineToPoint: CGPointMake(width+overshoot, y)];
    [bezierPath addLineToPoint: CGPointMake(width+overshoot, 0)];
    [bezierPath addLineToPoint: CGPointMake(-overshoot, 0)];
    [bezierPath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectInset(self.resultTextView.frame, 0, 0);
    shapeLayer.fillColor = [self.resultTextView.backgroundColor CGColor];
    shapeLayer.shadowColor = [[UIColor blackColor] CGColor];
    shapeLayer.shadowOffset = CGSizeMake(0, 0);
    shapeLayer.shadowOpacity = 0.5;
    shapeLayer.shadowRadius = 1.5;
    shapeLayer.shadowPath = [bezierPath CGPath];
    shapeLayer.path = [bezierPath CGPath];
    return shapeLayer;
}

@end
