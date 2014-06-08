//
//  TipsResultTableViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 4/18/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "TipsResultViewController.h"
#import "SharedResultViewController.h"
#import "EasyLifeAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface TipsResultViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *goDutchButton;
@property (nonatomic, strong) NSMutableArray *tipsResults;
@property (strong, nonatomic) NSIndexPath *currentSelectedIndexPath;
@property (strong, nonatomic) UIImage *goDutchButtonBackgroundImage, *doneButtonBackgroundImage;
@property (strong, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
@property (strong, readwrite) Record *addedRecord;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *location;
@property (nonatomic) NSInteger locationErrorCode;
@end

@implementation TipsResultViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self calculateTips];
    
    self.tableView.delegate = self; // set the delegate of the table view to be self controller
    self.tableView.dataSource = self; // set the data source of the table view to be self controller
    
    [self.tableView setSeparatorColor:self.appTintColor];
    
    /* set the style of buttons */
    [self.doneButton setBackgroundImage:self.doneButtonBackgroundImage forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[UIColor whiteColor]];
    [self.doneButton.layer setBorderWidth:0.5];
    [self.doneButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.doneButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
    
    [self.goDutchButton setBackgroundImage:self.goDutchButtonBackgroundImage forState:UIControlStateNormal];
    [self.goDutchButton setBackgroundColor:[UIColor whiteColor]];
    [self.goDutchButton.layer setBorderWidth:0.5];
    [self.goDutchButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.goDutchButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self hasGPS]) { // test whether the device could use location manager
        [self.locationManager startUpdatingLocation]; // register for the location manager
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self hasGPS]) {
        [self.locationManager stopUpdatingLocation]; // deregister for the location manager
    }
}

- (void)calculateTips
{
    float tips15 = self.totalAmount * 1.15;
    float tips18 = self.totalAmount * 1.18;
    float tips20 = self.totalAmount * 1.2;
    if (!_tipsResults) {
        _tipsResults = [[NSMutableArray alloc]  initWithObjects:[NSNumber numberWithFloat:[NSString stringWithFormat:@"%.2f", self.totalAmount].floatValue], [NSNumber numberWithFloat:[NSString stringWithFormat:@"%.2f", tips15].floatValue], [NSNumber numberWithFloat:[NSString stringWithFormat:@"%.2f", tips18].floatValue], [NSNumber numberWithFloat:[NSString stringWithFormat:@"%.2f", tips20].floatValue], nil];
    }
}

#pragma mark - LocationManager

- (CLLocationManager *)locationManager // lazy initialize the location manager
{
    if (!_locationManager) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager = locationManager;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.locationErrorCode = error.code;
}

- (BOOL)hasGPS
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted)
        return YES;
    else
        return NO;
}

#pragma mark - InitializeAppColors

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

# pragma mark - UIButtonBackgroundImage

- (UIImage *)goDutchButtonBackgroundImage
{
    if (!_goDutchButtonBackgroundImage) {
        UIColor *color = self.appSecondColor;
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        _goDutchButtonBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _goDutchButtonBackgroundImage;
}

- (UIImage *)doneButtonBackgroundImage
{
    if (!_doneButtonBackgroundImage) {
        UIColor *color = self.appThirdColor;
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        _doneButtonBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _doneButtonBackgroundImage;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell.accessoryType != UITableViewCellAccessoryCheckmark) {
        UITableViewCell *currentSelectedCell = [self.tableView cellForRowAtIndexPath:self.currentSelectedIndexPath];
        currentSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentSelectedIndexPath = indexPath;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TipsAmount";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger position = [indexPath row];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    if (position == 0) {
        float cellContent = [self.tipsResults[indexPath.section] floatValue];
        cell.textLabel.text = [NSString stringWithFormat:@"$%.2f", cellContent];
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.currentSelectedIndexPath = indexPath;
        }
    }
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Original Total Amount";
    else if (section == 1)
        return @"15% Tips";
    else if (section == 2)
        return @"18% Tips";
    else
        return @"20% Tips";
}

#pragma mark - Navigation

- (void)setSharedTotalAmountForTableViewController:(SharedResultViewController *)srvc withTotalSharedAmount:(float)totalSharedAmount andManagedContext:(NSManagedObjectContext *)context
{
    srvc.totalSharedAmount = totalSharedAmount;
    srvc.managedObjectContext = context;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CalculateShare"]) {
        if ([segue.destinationViewController isKindOfClass:[SharedResultViewController class]]) {
            [self setSharedTotalAmountForTableViewController:segue.destinationViewController withTotalSharedAmount:[self.tipsResults[self.currentSelectedIndexPath.section] floatValue] andManagedContext:self.managedObjectContext];
        }
    } else if ([segue.identifier isEqualToString:@"Do Added Record"]) {
        
        NSManagedObjectContext *context = self.managedObjectContext;
        if (context) {
            Record *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:context];
            record.amount = self.tipsResults[self.currentSelectedIndexPath.section];
            record.latitude = @(self.location.coordinate.latitude);
            record.longitude = @(self.location.coordinate.longitude);
            
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMT];
            NSDate *currentTime = [date dateByAddingTimeInterval:interval];
            record.date = currentTime;
            
            self.addedRecord = record;
            
            self.tipsResults = nil;
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Do Added Record"]) {
        if (self.currentSelectedIndexPath) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

@end
