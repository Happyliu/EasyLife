//
//  SharedResultViewController.m
//  EasyLife
//
//  Created by 张 子豪 on 4/20/14.
//  Copyright (c) 2014 张 子豪. All rights reserved.
//

#import "SharedResultViewController.h"
#import "EasyLifeAppDelegate.h"

@interface SharedResultViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *sharedResultDisplayTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *peopleAmountPickerView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property long numberOfPeopleToShare;
@property (strong, nonatomic) UIImage *doneButtonBackgroundImage;
@property (strong, nonatomic) UIColor *appTintColor, *appSecondColor, *appThirdColor, *appBlackColor;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - TableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Total Amount Including Tips";
    else
        return @"Money for each people";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"price";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger position = [indexPath row];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    if (position == 0) {
        if (indexPath.section == 0)
            cell.textLabel.text = [NSString stringWithFormat:@"$%.2f", self.totalSharedAmount];
        if (indexPath.section == 1)
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
    return [NSString stringWithFormat:@"%d",row + 2];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.numberOfPeopleToShare = row + 2;
    [self.sharedResultDisplayTableView reloadData];
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
