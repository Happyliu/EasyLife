//
//  TipsCalViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 4/18/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "TipsCalViewController.h"
#import "TipsResultViewController.h"
#import "SharedResultViewController.h"
#import "EasyLifeAppDelegate.h"
#import "Record.h"
#import "DatabaseAvailability.h"
#import "RecordViewController.h"
#import "RecognitionCameraOverlayView.h"
#import "AMSmoothAlertView.h"
#import "UIColor+MLPFlatColors.h"

@interface TipsCalViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberButtons;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (strong, nonatomic) UIImage *resetButtonBackgroundImage, *normalButtonBackgroundImage, *calculateButtonBackgroundImage;
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appRedColor, *appBlackColor;
@property (strong, nonatomic) NSMutableString *currentDisplayResult;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *detectedResult;
@property BOOL isDoted, isAddedRecord, isSuccessAddedRecord;
@property double currentResult;
@end

@implementation TipsCalViewController

#pragma mark - ViewLifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    /* listen to the notification center to update the database context */
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.managedObjectContext = note.userInfo[DatabaseAvailabilityContext];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[NSThread sleepForTimeInterval:1.0]; // time interval for demonstration launch image

    /* initialize the UIImagePickerController */
    self.navigationItem.leftBarButtonItem.enabled = false; // disable the button before initialized
    self.picker = [[UIImagePickerController alloc] init];
    self.navigationItem.leftBarButtonItem.enabled = true;
    
    /* setup the naviagtion bar */
    self.navigationController.navigationBar.barTintColor = self.appTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // color of the back button
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}]; // color of the title
    
    /* setup the tab bar */
    self.tabBarController.tabBar.barTintColor = self.appBlackColor;
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = NO;
    
    /* setup the calculate button */
    [self.calculateButton setBackgroundImage:self.calculateButtonBackgroundImage forState:UIControlStateNormal];
    [self.calculateButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];

    /* setup the reset button */
    [self.resetButton.layer setBorderWidth:0.5];
    [self.resetButton setBackgroundImage:self.resetButtonBackgroundImage forState:UIControlStateNormal];
    [self.resetButton setBackgroundColor:self.appSecondColor];
    [self.resetButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.resetButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];

    /* setup the normal number button */
    for (UIButton *numberButton in self.numberButtons) {
        [numberButton.layer setBorderWidth:0.5];
        [numberButton setBackgroundImage:self.normalButtonBackgroundImage forState:UIControlStateNormal];
        [numberButton.layer setBackgroundColor:[self.appTintColor CGColor]];
        [numberButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [numberButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
    }
    
    /* setup the result label */
    [self.displayLabel setTextColor:self.appBlackColor];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    /* gurantee the background of the alert is the main window and the speed of appearance */
    if (self.isAddedRecord) {
        if (self.isSuccessAddedRecord) {
            [self successAlert:@"Success"];
        } else {
            [self failAlert:@"Fail"];
        }
    }
    
    /* reset the flags for the alert view */
    self.isAddedRecord = NO;
    self.isSuccessAddedRecord = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /* address the image recognition */
    if (self.detectedResult) { // detect result is set
        [self.currentDisplayResult setString:self.detectedResult];
        self.displayLabel.text = [self.currentDisplayResult copy];
        self.currentResult = [self.detectedResult doubleValue];
        self.detectedResult = nil;
    } else { // reset the current display each time
        [self.currentDisplayResult setString:@""];
        self.displayLabel.text = @"0";
        self.currentResult = 0;
        self.isDoted = NO;
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

#pragma mark - ButtonBackgroundImage

- (UIImage *)resetButtonBackgroundImage
{
    if (!_resetButtonBackgroundImage) {
        UIColor *color = [UIColor flatDarkGrayColor];
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        _resetButtonBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _resetButtonBackgroundImage;
}

- (UIImage *)normalButtonBackgroundImage
{
    if (!_normalButtonBackgroundImage) {
        UIColor *color = [UIColor flatDarkWhiteColor];
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        _normalButtonBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _normalButtonBackgroundImage;
}

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

#pragma mark - LazyInit

- (NSMutableString *)currentDisplayResult
{
    if (!_currentDisplayResult) {
        _currentDisplayResult = [[NSMutableString alloc] initWithString:@""];
    }
    return _currentDisplayResult;
}

#pragma mark - ButtonAction

- (IBAction)cameraButtonIsPressed:(UIBarButtonItem *)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera; // use the camera of the device
        self.picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.picker.delegate = self;
        [self presentViewController:self.picker animated:YES completion:NULL]; // present the camera view
    } else {
        [self fatalAlert:@"Your device doesn't support camera."];
        self.picker = nil;
    }
}

- (IBAction)numbeButtonIsPressed:(UIButton *)sender {
    if (!self.isDoted && self.currentResult == 0 && [sender.currentTitle isEqualToString:@"0"]) {
        [self resetButtonIsPressed];
    } else {
        [self.currentDisplayResult appendString:sender.currentTitle];
        self.currentResult = [self.currentDisplayResult doubleValue];
        self.displayLabel.text = [self.currentDisplayResult copy];
    }
}

- (IBAction)resetButtonIsPressed {
    self.currentResult = 0;
    self.displayLabel.text = @"0";
    [self.currentDisplayResult setString:@""];
    self.isDoted = NO;
}

- (IBAction)dotButtonIsPressed {
    if (!self.isDoted) {
        if (self.currentResult == 0) {
            [self.currentDisplayResult appendString:@"0"];
        }
        [self.currentDisplayResult appendString:@"."];
        self.displayLabel.text = [self.currentDisplayResult copy];
        self.isDoted = YES;
    }
}

- (IBAction)recordButtonIsPressed:(id)sender {
    RecordViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"];
    [rvc setManagedObjectContext:self.managedObjectContext];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rvc];
    [nav.navigationBar setHidden:YES];
    [self presentViewController:nav animated:YES completion:NULL];
}

#pragma mark - Alert

- (void)successAlert:(NSString *)message
{
    [[[AMSmoothAlertView alloc] initDropAlertWithTitle:@"Add Record" andText:message andCancelButton:NO forAlertType:AlertSuccess andColor:self.appThirdColor] show];
}

- (void)failAlert:(NSString *)message
{
    [[[AMSmoothAlertView alloc] initDropAlertWithTitle:@"Add Record" andText:message andCancelButton:NO forAlertType:AlertFailure andColor:self.appRedColor] show];
}

- (void)fatalAlert:(NSString *)message
{
    [[[AMSmoothAlertView alloc] initDropAlertWithTitle:@"Sorry" andText:message andCancelButton:NO forAlertType:AlertInfo andColor:self.appTintColor] show];
}

//#pragma mark - UIImagePickerControllerDelegate
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = info[UIImagePickerControllerEditedImage]; // the image that image picker controller returns back
//    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
//    tesseract.delegate = self;
//    
//    [tesseract setVariableValue:@"0123456789." forKey:@"tessedit_char_whitelist"]; //limit search
//    [tesseract setImage:image]; //image to check
//    [tesseract recognize];
//    
//    self.detectedResult = [NSString stringWithFormat:@"%.2f", [[tesseract recognizedText] doubleValue]];
//    
//    NSLog(@"%@", self.detectedResult);
//    tesseract = nil;
//    image = nil;
//
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

#pragma mark - Segue

- (void)setTotalAmountTipsForViewController:(TipsResultViewController *)tvc withTotalAmount:(double)totalAmount andManagedObjectContext:(NSManagedObjectContext *)context
{ // send the total amount and database context to tips result view controller
    tvc.totalAmount = totalAmount;
    tvc.managedObjectContext = context;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Calculate Tips"]) {
        if ([segue.destinationViewController isKindOfClass:[TipsResultViewController class]]) {
            [self setTotalAmountTipsForViewController:segue.destinationViewController withTotalAmount:self.currentResult andManagedObjectContext:self.managedObjectContext];
        }
    }
}

/* unwind segue from TipsResultViewController and SharedResultViewController */

- (IBAction)addedRecord:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[TipsResultViewController class]]) {
        TipsResultViewController *trvc = (TipsResultViewController *)segue.sourceViewController;
        Record *addedRecord = trvc.addedRecord;
        if (addedRecord) {
            self.isAddedRecord = YES;
            self.isSuccessAddedRecord = YES;
        } else {
            self.isAddedRecord = YES;
            self.isSuccessAddedRecord = NO;
        }
    } else if ([segue.sourceViewController isKindOfClass:[SharedResultViewController class]]) {
        SharedResultViewController *srvc = (SharedResultViewController *)segue.sourceViewController;
        Record *addedRecord = srvc.addedRecord;
        if (addedRecord) {
            self.isAddedRecord = YES;
            self.isSuccessAddedRecord = YES;
        } else {
            self.isAddedRecord = YES;
            self.isSuccessAddedRecord = NO;
        }
    }
}

@end
