//
//  TSDColorsTableViewController.h
//  Tapsidecimal
//
//  Created by Colin on 3/10/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSDColorsTableViewController;
@class TSDMainViewController;

@protocol TSDColorsTableViewControllerDelegate

@optional
- (void)colorsTableViewControllerDidFinish:(TSDColorsTableViewController *)controller;

@end

@interface TSDColorsTableViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) id <TSDColorsTableViewControllerDelegate> delegate;
@property (strong, nonatomic) TSDMainViewController *mainViewController;

@property (strong, nonatomic) NSMutableArray *colorsArray;

- (IBAction)doneAction:(id)sender;

@end
