//
//  SingleRecordMapViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 5/13/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "SingleRecordMapViewController.h"
#import <MapKit/MapKit.h>

@interface SingleRecordMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation SingleRecordMapViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set the style of map view
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.showsBuildings = YES;
}

- (void)setDisplayRecord:(Record *)displayRecord
{
    _displayRecord = displayRecord;
    [self updateMapViewAnnotation];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapViewAnnotation];
}

- (void)updateMapViewAnnotation
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:self.displayRecord];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

@end
