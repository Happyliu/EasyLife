//
//  TipsCalViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 4/18/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "TipsCalViewController.h"
#import "TipsResultViewController.h"
#import "EasyLifeAppDelegate.h"
#import "Record.h"
#import "DatabaseAvailability.h"
#import "RecordViewController.h"

@interface TipsCalViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberButtons;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (strong, nonatomic) NSMutableString *currentDisplayResult;
@property BOOL isDoted;
@property float currentResult;
@property (strong, nonatomic) UIImage *resetButtonBackgroundImage, *normalButtonBackgroundImage, *calculateButtonBackgroundImage;
@property (strong, nonatomic) UIColor *appTintColor, *appSecondColor, *appBlackColor;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *detectedResult;
@end

@implementation TipsCalViewController

#pragma mark - ViewLifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // listen to the notification center to update the database context
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.managedObjectContext = note.userInfo[DatabaseAvailabilityContext];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* initialize the UIImagePickerController */
    self.navigationItem.rightBarButtonItem.enabled = false; // disable the button before initialized
    self.picker = [[UIImagePickerController alloc] init];
    self.navigationItem.rightBarButtonItem.enabled = true;

    self.navigationController.navigationBar.barTintColor = self.appTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // color of the back button

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.tabBarController.tabBar.barTintColor = self.appTintColor;
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    [self.resetButton.layer setBorderWidth:0.5];
    [self.resetButton setBackgroundImage:self.resetButtonBackgroundImage forState:UIControlStateNormal];
    [self.resetButton setBackgroundColor:self.appSecondColor];
    [self.resetButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.resetButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
    
    [self.calculateButton setBackgroundImage:self.calculateButtonBackgroundImage forState:UIControlStateNormal];
    [self.calculateButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
    
    for (UIButton *numberButton in self.numberButtons) { // set the style of each number button
        [numberButton.layer setBorderWidth:0.5];
        [numberButton setBackgroundImage:self.normalButtonBackgroundImage forState:UIControlStateNormal];
        [numberButton.layer setBackgroundColor:[self.appTintColor CGColor]];
        [numberButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
        [numberButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.detectedResult) { // display the tesseractORC result to user
        [self.currentDisplayResult setString:self.detectedResult];
        self.displayLabel.text = [self.currentDisplayResult copy];
        self.currentResult = [self.detectedResult floatValue];
        self.detectedResult = nil;
    } else { // reset the current display each time
        [self.currentDisplayResult setString:@""];
        self.displayLabel.text = @"0";
        self.currentResult = 0;
        self.isDoted = NO;
    }
}

#pragma mark - ButtonBackgroundImage

- (UIImage *)resetButtonBackgroundImage
{
    if (!_resetButtonBackgroundImage) {
        UIColor *color = [UIColor grayColor];
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
        UIColor *color = [UIColor lightGrayColor];
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

- (UIColor *)appBlackColor
{
    if (!_appBlackColor) {
        EasyLifeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _appBlackColor = appDelegate.appBlackColor;
    }
    return _appBlackColor;
}

- (NSMutableString *)currentDisplayResult
{
    if (!_currentDisplayResult) {
        _currentDisplayResult = [[NSMutableString alloc] initWithString:@""];
    }
    return _currentDisplayResult;
}

#pragma mark - ButtonAction

- (IBAction)cameraButtonIsPressed:(UIBarButtonItem *)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.allowsEditing = YES;
        self.picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.picker.delegate = self;
        [self presentViewController:self.picker animated:YES completion:NULL];
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
        self.currentResult = [self.currentDisplayResult floatValue];
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

- (IBAction)addedRecord:(UIStoryboardSegue *)segue // unwind segue from TipsResultViewController
{
    if ([segue.sourceViewController isKindOfClass:[TipsResultViewController class]]) {
        TipsResultViewController *trvc = (TipsResultViewController *)segue.sourceViewController;
        Record *addedRecord = trvc.addedRecord;
        if (addedRecord) {
            [self alert:@"Success"];
        } else {
            [self alert:@"Fail"];
        }
    }
}

#pragma mark - Alert

- (void)alert:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"Add Record" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

- (void)fatalAlert:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"Sorry" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage]; // the image that image picker controller returns back
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.delegate = self;
    
    [tesseract setVariableValue:@"0123456789." forKey:@"tessedit_char_whitelist"]; //limit search
    [tesseract setImage:image]; //image to check
    [tesseract recognize];
    
    self.detectedResult = [NSString stringWithFormat:@"%.2f", [[tesseract recognizedText] floatValue]];
    
    NSLog(@"%@", self.detectedResult);
    tesseract = nil; //deallocate and free all memory
    image = nil;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

- (void)setTotalAmountTipsForViewController:(TipsResultViewController *)tvc withTotalAmount:(float)totalAmount andManagedObjectContext:(NSManagedObjectContext *)context
{ // send the total amount and database context to tips result view controller
    tvc.totalAmount = totalAmount;
    tvc.managedObjectContext = context;
}

- (void)setManagedObjectContextForViewController:(RecordViewController *)rvc withManagedObjectContext:(NSManagedObjectContext *)context
{ // send the database context to record map controller
    rvc.managedObjectContext = context;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Calculate Tips"]) {
        if ([segue.destinationViewController isKindOfClass:[TipsResultViewController class]]) {
            [self setTotalAmountTipsForViewController:segue.destinationViewController withTotalAmount:self.currentResult andManagedObjectContext:self.managedObjectContext];
        }
    } else if ([segue.identifier isEqualToString:@"Check History"]) {
        if ([segue.destinationViewController isKindOfClass:[RecordViewController class]]) {
            [self setManagedObjectContextForViewController:segue.destinationViewController withManagedObjectContext:self.managedObjectContext];
        }
    }

}

@end
