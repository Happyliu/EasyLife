//
//  RecordMapViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 5/12/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "RecordMapViewController.h"
#import <MapKit/MapKit.h>
#import "EasyLifeAppDelegate.h"
#import "UILabel+NumberJump.h"


@interface RecordMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segements;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (strong, nonatomic) NSArray *records;
@property double totalAmount;
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
@end

@implementation RecordMapViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set the style of map view
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.showsBuildings = YES;
    self.segements.selectedSegmentIndex = 0;
    self.totalLabel.backgroundColor = self.appTintColor;
    self.totalLabel.textColor = [UIColor whiteColor];
    self.totalAmountLabel.backgroundColor = self.appTintColor;
    self.totalAmountLabel.textColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.totalAmountLabel jumpNumberWithDuration:2 fromNumber:0.0 toNumber:self.totalAmount];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - Initialize app colors

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

#pragma mark - Setter

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapViewAnnotations];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    self.records = nil;
    [self updateMapViewAnnotations];
}

#pragma mark - UpdateMap

- (void)updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.records];
    [self.mapView showAnnotations:self.records animated:YES];
    self.totalAmount = 0;
    for (Record *record in self.records) {
        self.totalAmount += [record.amount doubleValue];
    }
    [self.totalAmountLabel jumpNumberWithDuration:1.5 fromNumber:0 toNumber:self.totalAmount];
    self.records = nil;
}

#pragma mark - LazyInit

- (NSArray *)records
{
    if (!_records) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMT];
        NSDate *backDate, *backDateCurrentTime;
        NSError *error;

        if (self.segements.selectedSegmentIndex == 1) {
            backDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*90]; // 90 days before
        } else if (self.segements.selectedSegmentIndex == 2) {
            backDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*30]; // 30 days before
        } else if (self.segements.selectedSegmentIndex == 3){
            backDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*7]; // 7 days before
        } else {
            backDate = [NSDate dateWithTimeIntervalSince1970:0];
        }
        
        backDateCurrentTime = [backDate dateByAddingTimeInterval:interval];
        request.predicate = [NSPredicate predicateWithFormat:@"date > %@", backDateCurrentTime];
        NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (!error) {
            _records = matches;
        }
    }
    return _records;
}

#pragma mark - MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseId = @"RecordMapViewController"; // annotation reuse id
    MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        view.canShowCallout = YES; // little white box
        view.animatesDrop = YES; // drops the pin every time
    }
    view.annotation = annotation;
    return view;
}

#pragma mark - SegementAction

- (IBAction)segmentIsPressed:(UISegmentedControl *)sender {
    self.segements.selectedSegmentIndex = sender.selectedSegmentIndex;
    [self updateMapViewAnnotations];
}

@end
