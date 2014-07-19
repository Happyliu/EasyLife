//
//  DividerViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 6/19/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "DividerViewController.h"
#import "EasyLifeAppDelegate.h"
#import "SingleExpenseRecordView.h"
#import "UIScrollView+UITouchEvent.h"
#import "AMSmoothAlertView.h"
#import "DividerCalculateResultViewController.h"
#import "ExpenseRecord.h"

@interface DividerViewController () <UITextFieldDelegate>
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appRedColor, *appBlackColor;
@property (strong, nonatomic) NSMutableArray *singleExpenseRecordViews;
@property (weak, nonatomic) IBOutlet UIScrollView *dividerScrollView;
@property CGPoint currentPoint;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (strong, nonatomic) UIImage *calculateButtonBackgroundImage;
@property NSInteger currentViewTag;
@property BOOL isSameTag;
@end

@implementation DividerViewController

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

- (UIColor *)appBlackColor
{
    if (!_appBlackColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appBlackColor = appDelegate.appBlackColor;
    }
    return _appBlackColor;
}

- (UIColor *)appRedColor
{
    if (!_appRedColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appRedColor = appDelegate.appRedColor;
    }
    return _appRedColor;
}

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = self.appTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // color of the back button
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.tabBarController.tabBar.barTintColor = self.appBlackColor;
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
    
    [self.calculateButton setBackgroundImage:self.calculateButtonBackgroundImage forState:UIControlStateNormal];
    [self.calculateButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isSameTag = NO;
    
    SingleExpenseRecordView *firstExpenseView = [[SingleExpenseRecordView alloc] initWithFrame:CGRectMake(0, 0, self.dividerScrollView.frame.size.width, 165)];
    firstExpenseView.layer.borderWidth = 1.0;
    firstExpenseView.layer.borderColor = self.appBlackColor.CGColor;
    firstExpenseView.expensePayerTextField.delegate = self;
    firstExpenseView.expenseAmountTextField.delegate = self;
    firstExpenseView.expenseDescriptionTextField.delegate = self;
    
    [self.singleExpenseRecordViews addObject:firstExpenseView];
    firstExpenseView.tag = [self.singleExpenseRecordViews count];

    [self.dividerScrollView addSubview:firstExpenseView];
    [self.dividerScrollView setContentSize:CGSizeMake(self.dividerScrollView.frame.size.width, [self.singleExpenseRecordViews count] * 164 + 1)];
    
    self.currentViewTag = 0;
    self.currentPoint = CGPointMake(0, 0);self.currentViewTag = 0;
    [self setContentOffsetAnimation:self.currentPoint.y];
    
    [self.deleteButton setEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (SingleExpenseRecordView *view in self.singleExpenseRecordViews) {
        [view removeFromSuperview];
    }
    [self.singleExpenseRecordViews removeAllObjects];
}

#pragma mark - SingleExpenseRecordViewsInit

- (NSMutableArray *)singleExpenseRecordViews
{
    if (!_singleExpenseRecordViews) {
        _singleExpenseRecordViews = [[NSMutableArray alloc] init];
    }
    return _singleExpenseRecordViews;
}

#pragma mark - TouchGestureForScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (SingleExpenseRecordView *serv in self.singleExpenseRecordViews) {
        [serv.expensePayerTextField resignFirstResponder];
        [serv.expenseAmountTextField resignFirstResponder];
        [serv.expenseDescriptionTextField resignFirstResponder];
    }
    self.currentViewTag = 0;
    [self setContentOffsetAnimation:self.currentPoint.y];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.superview.tag != self.currentViewTag) {
        self.currentViewTag = textField.superview.tag;
        self.currentPoint = self.dividerScrollView.contentOffset;
        [self setContentOffsetAnimation:((SingleExpenseRecordView *)self.singleExpenseRecordViews[self.currentViewTag - 1]).frame.origin.y];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.currentViewTag = 0;
    [self setContentOffsetAnimation:self.currentPoint.y];
    return YES;
}

#pragma mark - ScrollViewTouchEvent

- (void)setContentOffsetAnimation:(CGFloat)offsetY
{
    [UIView animateWithDuration:0.3 animations:^{
        self.dividerScrollView.contentOffset = CGPointMake(0, offsetY);
    }];
}

- (void)setContentOffsetAnimationToTheBottom
{
    [UIView animateWithDuration:0.4 animations:^{
        self.dividerScrollView.contentOffset = CGPointMake(0,  self.dividerScrollView.contentSize.height - self.dividerScrollView.frame.size.height );
    }];
}

- (void)setContentOffsetAnimationToCustomBottom:(NSInteger)newContentSize
{
    [UIView animateWithDuration:0.4 animations:^{
        self.dividerScrollView.contentOffset = CGPointMake(0,  newContentSize - self.dividerScrollView.frame.size.height );
    }];
}

#pragma mark - AddAndDeleteRecordView

- (IBAction)addNewSingleRecordView:(id)sender
{
    SingleExpenseRecordView *lastView = [self.singleExpenseRecordViews lastObject];
    SingleExpenseRecordView *serv = [[SingleExpenseRecordView alloc] initWithFrame:CGRectMake(self.dividerScrollView.frame.size.width, lastView.frame.origin.y + lastView.frame.size.height - 1, self.dividerScrollView.frame.size.width, lastView.frame.size.height)];
    serv.layer.borderWidth = 1.0;
    serv.layer.borderColor = self.appBlackColor.CGColor;
    serv.expensePayerTextField.delegate = self;
    serv.expenseAmountTextField.delegate = self;
    serv.expenseDescriptionTextField.delegate = self;
    
    [self.singleExpenseRecordViews addObject:serv];

    serv.tag = [self.singleExpenseRecordViews count];
    
    [self.dividerScrollView addSubview:[self.singleExpenseRecordViews lastObject]];
    [self.dividerScrollView setContentSize:CGSizeMake(self.dividerScrollView.frame.size.width, [self.singleExpenseRecordViews count] * 164 + 1)];
    
    if (self.dividerScrollView.contentSize.height > self.dividerScrollView.frame.size.height) {
        [self setContentOffsetAnimationToTheBottom];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    [serv setFrame:CGRectMake(0, lastView.frame.origin.y + lastView.frame.size.height - 1, self.dividerScrollView.frame.size.width, lastView.frame.size.height)];
    [UIView commitAnimations];
    
    if ([self.singleExpenseRecordViews count] > 1) {
        [self.deleteButton setEnabled:YES];
    }
}
- (IBAction)deleteLastSingleRecordView:(id)sender {
    SingleExpenseRecordView *lastView = [self.singleExpenseRecordViews lastObject];
    [self.singleExpenseRecordViews removeLastObject];
    if ([self.singleExpenseRecordViews count] <= 1) {
        [sender setEnabled:NO];
    }
    
    NSInteger newContentSize = [self.singleExpenseRecordViews count] * 164 + 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        [lastView setFrame:CGRectMake(lastView.frame.origin.x - lastView.frame.size.width, lastView.frame.origin.y, lastView.frame.size.width, lastView.frame.size.height)];
    } completion:^(BOOL finished) {
        [lastView removeFromSuperview];
        if (newContentSize > self.dividerScrollView.frame.size.height) {
            [self setContentOffsetAnimationToCustomBottom:newContentSize];
        } else {
            [self setContentOffsetAnimation:0];
        }
        [self.dividerScrollView setContentSize:CGSizeMake(self.dividerScrollView.frame.size.width, [self.singleExpenseRecordViews count] * 164 + 1)];
    }];
}

#pragma mark - ButtonBackgroundImage

- (UIImage *)calculateButtonBackgroundImage
{
    if (!_calculateButtonBackgroundImage) {
        UIColor *color = self.appSecondColor;
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        _calculateButtonBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _calculateButtonBackgroundImage;
}

#pragma mark - Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Calculate Expense"]) {
        for (SingleExpenseRecordView *view in self.singleExpenseRecordViews) {
            if ([view isEmpty]) {
                [[[AMSmoothAlertView alloc] initDropAlertWithTitle:@"ERROR" andText:[NSString stringWithFormat:@"Record No.%@ is empty!", [NSNumber numberWithInteger:view.tag]] andCancelButton:NO forAlertType:AlertFailure andColor:self.appRedColor] show];
                return NO;
            } else if (![view isValid]) {
                [[[AMSmoothAlertView alloc] initDropAlertWithTitle:@"ERROR" andText:[NSString stringWithFormat:@"Record content in No.%@ is not valid!", [NSNumber numberWithInteger:view.tag]] andCancelButton:NO forAlertType:AlertFailure andColor:self.appRedColor] show];
                return NO;
            } else if ([self.singleExpenseRecordViews count] == 1) {
                [[[AMSmoothAlertView alloc] initDropAlertWithTitle:@"ERROR" andText:@"You only input one expense record, please try again!"  andCancelButton:NO forAlertType:AlertFailure andColor:self.appRedColor] show];
                return NO;
            }
        }
        return YES;
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Calculate Expense"]) {
        if ([segue.destinationViewController isKindOfClass:[DividerCalculateResultViewController class]]) {
            NSMutableArray *expenseRecordsTemp = [[NSMutableArray alloc] initWithCapacity:[self.singleExpenseRecordViews count]];
            for (SingleExpenseRecordView *record in self.singleExpenseRecordViews) {
                ExpenseRecord *expenseRecord = [[ExpenseRecord alloc] init];
                expenseRecord.expenseDate = record.datePicker.selectedDate;
                expenseRecord.expensePayerName = record.expensePayerTextField.text;
                expenseRecord.expenseDescription = record.expenseDescriptionTextField.text;
                expenseRecord.expenseAmount = [NSNumber numberWithDouble:[record.expenseAmountTextField.text doubleValue]];
                [expenseRecordsTemp addObject:expenseRecord];
            }
            ((DividerCalculateResultViewController *)segue.destinationViewController).isComplete = NO;
            ((DividerCalculateResultViewController *)segue.destinationViewController).expenseRecords = [expenseRecordsTemp copy];
            [expenseRecordsTemp removeAllObjects];
        }
    }
}

@end
