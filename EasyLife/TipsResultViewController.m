//
//  TipsResultTableViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 4/18/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "TipsResultViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SharedResultViewController.h"
#import "EasyLifeAppDelegate.h"
#import "WGS84ToGCJ02.h"

@interface TipsResultViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *goDutchButton;
@property (nonatomic, strong) NSMutableArray *tipsResults;
@property (strong, nonatomic) UIImage *goDutchButtonBackgroundImage, *doneButtonBackgroundImage;
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
@property (strong, readwrite) Record *addedRecord;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *location;
@property (nonatomic) NSInteger locationErrorCode, currentSelectedSection;
@end

@implementation TipsResultViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self calculateTips];
    
    /* setup the table view for the tips result */
    self.tableView.delegate = self; // set the delegate of the table view to be self controller
    self.tableView.dataSource = self; // set the data source of the table view to be self controller
    [self.tableView setSeparatorColor:self.appTintColor];
    
    /* set the style of buttons */
    [self.doneButton setBackgroundImage:self.doneButtonBackgroundImage forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[UIColor whiteColor]];
    [self.doneButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
    
    [self.goDutchButton setBackgroundImage:self.goDutchButtonBackgroundImage forState:UIControlStateNormal];
    [self.goDutchButton setBackgroundColor:[UIColor whiteColor]];
    [self.goDutchButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
    
    self.currentSelectedSection = -1;
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
    double tips10 = self.totalAmount * 1.10;
    double tips12 = self.totalAmount * 1.12;
    double tips15 = self.totalAmount * 1.15;
    double tips18 = self.totalAmount * 1.18;
    double tips20 = self.totalAmount * 1.2;
    
    if (!_tipsResults) {
        _tipsResults = [[NSMutableArray alloc]  initWithObjects:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f", self.totalAmount].doubleValue], [NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f", tips10].doubleValue], [NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f", tips12].doubleValue], [NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f", tips15].doubleValue], [NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f", tips18].doubleValue], [NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f", tips20].doubleValue], nil];
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

#pragma mark - LocationManager

- (CLLocationManager *)locationManager // lazy initialize the location manager
{
    if (!_locationManager) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 1.0f;
        _locationManager = locationManager;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    
    /* re-calculate the coordinate in China */
    if (![WGS84ToGCJ02 isLocationOutOfChina:[loc coordinate]])
        loc = [WGS84ToGCJ02 transformFromWGSToGCJ:loc];
    
    self.location = loc;
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSIndexPath *currentSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentSelectedSection];
    if (selectedCell.accessoryType != UITableViewCellAccessoryCheckmark) {
        UITableViewCell *currentSelectedCell = [self.tableView cellForRowAtIndexPath:currentSelectedIndexPath];
        currentSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentSelectedSection = indexPath.section;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"TipsAmount";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    double cellContent = [self.tipsResults[indexPath.section] doubleValue];
    cell.textLabel.text = [NSString stringWithFormat:@"$%.2f", cellContent];
    if (indexPath.section == 0 && self.currentSelectedSection == -1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentSelectedSection = 0;
    } else if (self.currentSelectedSection == indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tipsResults count];
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
        return @"10% Tips";
    else if (section == 2)
        return @"12% Tips";
    else if (section == 3)
        return @"15% Tips";
    else if (section == 4)
        return @"18% Tips";
    else
        return @"20% Tips";
}

#pragma mark - Segue

- (void)setSharedTotalAmountForTableViewController:(SharedResultViewController *)srvc withTotalSharedAmount:(double)totalSharedAmount andManagedContext:(NSManagedObjectContext *)context
{
    srvc.totalSharedAmount = totalSharedAmount;
    srvc.managedObjectContext = context;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CalculateShare"]) {
        if ([segue.destinationViewController isKindOfClass:[SharedResultViewController class]]) {
            [self setSharedTotalAmountForTableViewController:segue.destinationViewController withTotalSharedAmount:[self.tipsResults[self.currentSelectedSection] doubleValue] andManagedContext:self.managedObjectContext];
        }
    } else if ([segue.identifier isEqualToString:@"Do Added Record"]) {
        NSManagedObjectContext *context = self.managedObjectContext;
        if (context) {
            
            /* setup the result record and send it back to the TipsCalViewController */
            Record *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:context];
#warning should set the currency type in next version
            record.currency = @"USD";
            record.amount = self.tipsResults[self.currentSelectedSection];
            record.latitude = @(self.location.coordinate.latitude);
            record.longitude = @(self.location.coordinate.longitude);
            
            /* set the date of the record */
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMT];
            NSDate *currentTime = [date dateByAddingTimeInterval:interval];
            record.date = currentTime; // the time is local time since we don't have to convert the time while we in another time zone

            self.addedRecord = record;
            
            [self.tipsResults removeAllObjects]; //clear up the mutable array to release space
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Do Added Record"]) {
        if (self.currentSelectedSection != -1) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

@end
