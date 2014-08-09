//
//  RecordViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 5/13/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordMapViewController.h"
#import "Record.h"
#import "EasyLifeAppDelegate.h"
#import "SingleRecordMapViewController.h"
#import "UINavigationController+MHDismissModalView.h"

@interface RecordViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *records;
@property (weak, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
@property (strong, nonatomic) UIImage *mapButtonBackgroundImage;
@end

@implementation RecordViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* setup the table view */
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorColor:self.appTintColor];
    [self.tableView flashScrollIndicators];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    /* setup the map button */
    [self.mapButton setBackgroundImage:self.mapButtonBackgroundImage forState:UIControlStateNormal];
    [self.mapButton setBackgroundColor:[UIColor whiteColor]];
    [self.mapButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.mapButton setTitleColor:self.appBlackColor forState:UIControlStateNormal];
    [self.navigationController installMHDismissModalViewWithOptions:[[MHDismissModalViewOptions alloc] initWithTableView:self.tableView theme:MHModalThemeWhite]];
    if ([self.records count] == 0) {
        [self.mapButton setEnabled:NO];
        [self.mapButton setTitle:@"No Record" forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.records removeAllObjects];
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

#pragma mark - ButtonBackgroundImage

- (UIImage *)mapButtonBackgroundImage
{
    if (!_mapButtonBackgroundImage) {
        UIColor *color = self.appSecondColor;
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        _mapButtonBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _mapButtonBackgroundImage;
}

#pragma mark - LazyInit

- (void)setManagedObjectContextForViewController:(RecordMapViewController *)rmvc withManagedObjectContext:(NSManagedObjectContext *)context
{
    rmvc.managedObjectContext = context;
}

- (NSArray *)records
{
    if (!_records) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        request.sortDescriptors = @[sortDescriptor];
        NSError *error;
        NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (!error) {
            _records = [matches mutableCopy];
        }
    }
    return _records;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { // delete a record
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];
        NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.managedObjectContext deleteObject:self.records[indexPath.row]];
        [self.records removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    if ([self.records count] == 0) {
        [self.mapButton setEnabled:NO];
        [self.mapButton setTitle:@"No Record" forState:UIControlStateNormal];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Record";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger position = [indexPath row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]]; // convert the time to the time in the core data
    NSString *subTitle = [dateFormatter stringFromDate:((Record *)self.records[position]).date];
    
    cell.textLabel.text = [NSString stringWithFormat:@"$%.2f", [((Record *)self.records[position]).amount doubleValue]];
    cell.detailTextLabel.text = subTitle;
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.records count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Check History On Map"]) {
        if ([segue.destinationViewController isKindOfClass:[RecordMapViewController class]]) {
            [self setManagedObjectContextForViewController:segue.destinationViewController withManagedObjectContext:self.managedObjectContext];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES]; // change the status bar color
        }
    }
    if ([segue.identifier isEqualToString:@"Check Single History On Map"]) {
        if ([segue.destinationViewController isKindOfClass:[SingleRecordMapViewController class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            ((SingleRecordMapViewController *)segue.destinationViewController).displayRecord = [self.records objectAtIndex:indexPath.row];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES]; // change the status bar color
        }
    }
}

@end
