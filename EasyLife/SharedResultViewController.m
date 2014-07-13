//
//  SharedResultViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 4/20/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "SharedResultViewController.h"
#import "EasyLifeAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface SharedResultViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *sharedResultDisplayTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *peopleAmountPickerView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property float numberOfPeopleToShare;
@property (strong, nonatomic) UIImage *doneButtonBackgroundImage;
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
@property (strong, readwrite) Record *addedRecord;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *location;
@property (nonatomic) NSInteger locationErrorCode;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation SharedResultViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sharedResultDisplayTableView.delegate = self;
    self.sharedResultDisplayTableView.dataSource = self;
    [self.sharedResultDisplayTableView setSeparatorColor:self.appTintColor];
    self.peopleAmountPickerView.delegate = self;
    self.peopleAmountPickerView.dataSource = self;
    self.numberOfPeopleToShare = 2;

    [self.doneButton setBackgroundImage:self.doneButtonBackgroundImage forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[UIColor whiteColor]];
    [self.doneButton.layer setBorderWidth:0.5];
    [self.doneButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.doneButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
    self.numberLabel.backgroundColor = self.sharedResultDisplayTableView.backgroundColor;
    self.numberLabel.textColor = [UIColor grayColor];
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

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - TableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Money for each people";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"price";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger position = [indexPath row];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    if (position == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"$%.2f", self.totalSharedAmount / self.numberOfPeopleToShare];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sharedResultDisplayTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 7;
}

#pragma mark - PickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:row + 2]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.numberOfPeopleToShare = row + 2;
    [self.sharedResultDisplayTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Do Added Record"]) {
        
        NSManagedObjectContext *context = self.managedObjectContext;
        if (context) {
            Record *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:context];
#warning should set the currency type in next version
            record.currency = @"USD";
            record.amount = [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",self.totalSharedAmount / self.numberOfPeopleToShare] doubleValue]];
            record.latitude = @(self.location.coordinate.latitude);
            record.longitude = @(self.location.coordinate.longitude);
            
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMT];
            NSDate *currentTime = [date dateByAddingTimeInterval:interval];
            record.date = currentTime;
            
            self.addedRecord = record;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
