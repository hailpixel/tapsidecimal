//
//  TSDMainViewController.h
//  Tapsidecimal
//
//  Created by Colin on 3/9/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import "TSDColorsTableViewController.h"

@interface TSDMainViewController : UIViewController <TSDColorsTableViewControllerDelegate, UIPopoverControllerDelegate>

@property CGFloat hue;
@property CGFloat saturation;
@property CGFloat brightness;

@property (strong, nonatomic) NSMutableArray *colorsArray;

@property (weak, nonatomic) IBOutlet UILabel *attribute1Tag;
@property (weak, nonatomic) IBOutlet UILabel *attribute2Tag;
@property (weak, nonatomic) IBOutlet UILabel *attribute3Tag;

@property (weak, nonatomic) IBOutlet UILabel *attribute1;
@property (weak, nonatomic) IBOutlet UILabel *attribute2;
@property (weak, nonatomic) IBOutlet UILabel *attribute3;

@property (weak, nonatomic) IBOutlet UIButton *attributeSwitchButton;
- (IBAction)attributeSwitchAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *hexLabel;
- (IBAction)hexCopy:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;

- (IBAction)saveAction:(id)sender;
- (IBAction)listAction:(id)sender;

// For iPad only
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) UIPopoverController *colorsTablePopoverViewController;

@end