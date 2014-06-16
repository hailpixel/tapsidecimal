//
//  TSDAppDelegate.m
//  Tapsidecimal
//
//  Created by Colin on 3/9/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import "TSDAppDelegate.h"

@interface TSDAppDelegate ()

- (void)appearanceSetup;

@end

@implementation TSDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self appearanceSetup];
    
    return YES;
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


#pragma mark - Private methods
- (void)appearanceSetup
{
    // Set nav bar font differently for iPad and iPhone
    UIFont *navBarTitleFont;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) navBarTitleFont = [UIFont fontWithName:@"HiraKakuProN-W3" size:20.0];
    else navBarTitleFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:20.0];
    
    // Colors defined in Constants.pch
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:@{NSForegroundColorAttributeName: WHITEPRIMARY,
                                                                                      NSFontAttributeName: navBarTitleFont}];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:1.0f]];
    [[UINavigationBar appearance] setAlpha:0.85f];
    
    // Maintain font but change size for bar buttons
    UIFont *barButtonItemFont = [UIFont fontWithName:navBarTitleFont.fontName size:16.0f];
    [attributes addEntriesFromDictionary:@{NSFontAttributeName: barButtonItemFont}];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

@end