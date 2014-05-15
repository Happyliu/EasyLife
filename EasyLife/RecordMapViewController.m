//
//  RecordMapViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 5/12/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "RecordMapViewController.h"
#import <MapKit/MapKit.h>

@interface RecordMapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segements;
@property (strong, nonatomic) NSArray *records;
@end

@implementation RecordMapViewController

- (void)viewDidLoad
{
    // set the style of map view
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.showsBuildings = YES;
    self.segements.selectedSegmentIndex = 0;
}

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

- (void)updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.records];
    [self.mapView showAnnotations:self.records animated:YES];
    self.records = nil;
}

- (NSArray *)records
{
    if (!_records) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMT];
        NSDate *backDate, *backDateCurrentTime;
        NSError *error;

        if (self.segements.selectedSegmentIndex == 0) {
            backDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*90]; // 90 days before
        } else if (self.segements.selectedSegmentIndex == 1) {
            backDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*30]; // 30 days before
            
        } else {
            backDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*7]; // 7 days before
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseId = @"RecordMapViewController"; // annotation reuse id
    MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:reuseId];
        view.canShowCallout = YES; // little white box
        view.animatesDrop = YES;
    }
    
    view.annotation = annotation;
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"test");
}

- (IBAction)segmentIsPressed:(UISegmentedControl *)sender {
    self.segements.selectedSegmentIndex = sender.selectedSegmentIndex;
    [self updateMapViewAnnotations];
}

@end
