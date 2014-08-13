//
//  EasyLifeAppDelegate.m
//  EasyLife
//
//  Created by 张 子豪 on 5/15/14.
//  Copyright (c) 2014 Albert. All rights reserved.
//

#import "EasyLifeAppDelegate.h"
#import "DatabaseAvailability.h"
#import "UIColor+MLPFlatColors.h"

@interface EasyLifeAppDelegate()
@property (strong, nonatomic)UIManagedDocument *document;
@property (strong, nonatomic)NSManagedObjectContext *databaseContext;
@end

@implementation EasyLifeAppDelegate

- (UIColor *)appTintColor {
    if (!_appTintColor) {
        _appTintColor = [UIColor flatBlueColor];
    }
    return _appTintColor;
}

- (UIColor *)appSecondColor {
    if (!_appSecondColor) {
        _appSecondColor = [UIColor flatYellowColor];
    }
    return _appSecondColor;
}

- (UIColor *)appThirdColor {
    if (!_appThirdColor) {
        _appThirdColor = [UIColor flatTealColor];
    }
    return _appThirdColor;
}

- (UIColor *)appRedColor {
    if (!_appRedColor) {
        _appRedColor = [UIColor flatRedColor];
    }
    return _appRedColor;
}

- (UIColor *)appBlackColor {
    if (!_appBlackColor) {
        _appBlackColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    }
    return _appBlackColor;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // set the status bar color to be white
    self.window.tintColor = self.appTintColor; // set the tint color of the app
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // multithread to do the file work
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"MyXpense";
        NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        self.document = document;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) { // file exists
            [document openWithCompletionHandler:^(BOOL success) {
                if (success)
                    [self documentIsReady];
                else
                    NSLog(@"couldn't open file at url %@", url);
            }];
        } else { // file doesn't exist
            [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                if (success)
                    [self documentIsReady];
                else
                    NSLog(@"couldn't create file at url %@", url);
            }];
        }
    });
    [Parse setApplicationId:@"uXPx5g1etDKDgxtLAD1WlwN8LJybPpJPNJSmJoQo" clientKey:@"1UMQhKHWcU1mWfhb4ypT6zhJoCxEhCYqs8ToOuby"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}

- (void)documentIsReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.databaseContext = self.document.managedObjectContext;
        });
    }
}

- (void)setDatabaseContext:(NSManagedObjectContext *)databaseContext // post information to notification center
{
    _databaseContext = databaseContext;
    NSDictionary *userInfo = self.databaseContext ? @{DatabaseAvailabilityContext : self.databaseContext} : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseAvailabilityNotification object:self userInfo:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
