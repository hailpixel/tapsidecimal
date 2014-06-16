//
//  TSDMainViewController.m
//  Tapsidecimal
//
//  Created by Colin on 3/9/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import "TSDMainViewController.h"
#import "TSDColorsTableViewController.h"
#import "UIColor+Tapsidecimal.h"
#import "NSMutableArray+ColorsData.h"

@interface TSDMainViewController ()

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchRecognizer;

@property CGFloat xLagged;
@property CGFloat yLagged;
@property CGFloat xDelta;
@property CGFloat yDelta;

@property BOOL rgb;

- (void)updateColorWithPersistentValues;
- (void)updateColor:(UIColor *)color;
- (void)updateColorLabels;
- (void)setInitialColorValues;

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
- (void)panGestureUpdate:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)pinchGestureUpdate:(UIPinchGestureRecognizer *)gestureRecognizer;

- (void)giveFeedback:(NSString *)feedbackString;

@end

@implementation TSDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.panRecognizer addTarget:self action:@selector(handleGesture:)];
    [self.pinchRecognizer addTarget:self action:@selector(handleGesture:)];
    
    // Colors are stored as hex color strings in a .plist file, handled via NSMutableArray class extensions
    self.colorsArray = [NSMutableArray arrayWithContentsOfPlist];
    
    self.xDelta = 0.0f;
    self.yDelta = 0.0f;
    self.xLagged = 0.0f;
    self.yLagged = 0.0f;
    
    // NO: HSB label values, YES: RGB label values
    self.rgb = NO;
    
    self.feedbackLabel.alpha = 0.0f;
    
    [self setInitialColorValues];
}

#pragma mark - Private methods
#pragma mark Color updating
- (void)updateColorWithPersistentValues;
{
    // Set background color according to stored values
    UIColor *updatedColor = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:1.0f];
    [self updateColor:updatedColor];
}

- (void)updateColor:(UIColor *)color;
{
    // Set background color to argument and update labels accordingly
    self.view.backgroundColor = color;
    [self updateColorLabels];
}

- (void)updateColorLabels;
{
    UIColor *color = self.view.backgroundColor;
    
    self.hexLabel.text = [color hexString];
    // Generic "attribute" variables to store RGB or HSB depending the value of self.rgb
    CGFloat attribute1 = 0.0f, attribute2 = 0.0f, attribute3 = 0.0f;
    if (self.rgb) {
        [color getRed:&attribute1 green:&attribute2 blue:&attribute3 alpha:NULL];
        // Colors displayed between 0 and 255
        attribute1 *= 255;
        attribute2 *= 255;
        attribute3 *= 255;
    } else {
        // Hue displayed in degrees (0-359), saturation and brightness in percentage values (0-100)
        attribute1 = self.hue * 360;
        attribute2 = self.saturation * 100;
        attribute3 = self.brightness * 100;
    }
    
    self.attribute1.text = [NSString stringWithFormat:@"%d", (int)(attribute1)];
    self.attribute2.text = [NSString stringWithFormat:@"%d", (int)(attribute2)];
    self.attribute3.text = [NSString stringWithFormat:@"%d", (int)(attribute3)];
}

- (void)setInitialColorValues
{
    UIColor *firstColor;
    
    // If any colors are stored, most recent one is loaded, otherwise a random color is generated and loaded to the background
    // Controller HSB values set to the loaded color values
    CGFloat hue = 0.0f, saturation = 0.0f, brightness = 0.0f;
    if ([self.colorsArray count]) {
        firstColor = [UIColor colorWithHexString:[self.colorsArray objectAtIndex:0]];
        [firstColor getHue:&hue saturation:&saturation brightness:&brightness alpha:NULL];
    } else {
        hue = RANDUNIFORM, saturation = RANDUNIFORM, brightness = RANDUNIFORM;
        firstColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
    }
    
    self.hue = hue;
    self.saturation = saturation;
    self.brightness = brightness;
    
    [self updateColor:firstColor];
}

#pragma mark Gesture handling
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
{
    // Call different methods depending on which gesture recognizer was fired
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        [self panGestureUpdate:(UIPanGestureRecognizer *)gestureRecognizer];
    }
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        [self pinchGestureUpdate:(UIPinchGestureRecognizer *)gestureRecognizer];
    }
}

- (void)panGestureUpdate:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Update hue and brightness according to past delta values because gestureRecognizer fires on a gesture's ending
    self.hue += (self.xDelta/1000);
    self.brightness -= (self.yDelta/1000);
    
    // Loop hue value, rather than max/min values
    if (self.hue < 0.0f) self.hue += 1;
    else if (self.hue >= 1.0f) self.hue -= 1;
    
    if (self.brightness < 0.0f || self.brightness > 1.0f) self.brightness = MAX(MIN(self.brightness, 1.0f), 0.0f);
    
    [self updateColorWithPersistentValues];
    
    // Calculate the delta if the gesture is still occurring, otherwise reset delta values
    // Handling delta values in this way prevents a second gesture resulting in an abrupt change in the background color
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.xDelta = point.x - self.xLagged;
        self.yDelta = point.y - self.yLagged;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.xDelta = 0.0f;
        self.yDelta = 0.0f;
    }
    
    self.xLagged = point.x;
    self.yLagged = point.y;
}

- (void)pinchGestureUpdate:(UIPinchGestureRecognizer *)gestureRecognizer
{
    self.saturation += gestureRecognizer.velocity * 0.005f;
    if (self.saturation < 0.0f || self.saturation > 1.0f) self.saturation = MAX(MIN(self.saturation, 1.0f), 0.0f);
    
    [self updateColorWithPersistentValues];
}

#pragma mark Feedback
- (void)giveFeedback:(NSString *)feedbackString;
{
    self.feedbackLabel.text = feedbackString;
    self.feedbackLabel.alpha = 1.0f;
    [UIView animateWithDuration:0.75f animations:^{
        self.feedbackLabel.alpha = 0.0f;
    }];
}


#pragma mark - Actions handling
- (IBAction)attributeSwitchAction:(id)sender
{
    // Hitting the RGB/HSB button switches the attributes displayed by the attribute labels
    self.rgb = !self.rgb;
    
    if (self.rgb) {
        self.attribute1Tag.text = @"R";
        self.attribute2Tag.text = @"G";
        [self.attributeSwitchButton setTitle:@"HSB" forState:UIControlStateNormal];
    } else {
        self.attribute1Tag.text = @"H";
        self.attribute2Tag.text = @"S";
        [self.attributeSwitchButton setTitle:@"RGB" forState:UIControlStateNormal];
    }
    
    [self updateColorLabels];
}

- (void)hexCopy:(id)sender
{
    [UIPasteboard generalPasteboard].string = self.hexLabel.text;
    [self giveFeedback:@"COPIED"];
}

- (IBAction)saveAction:(id)sender
{
    // Save all new colors to .plist
    [self.colorsArray insertObject:[self.view.backgroundColor hexString] atIndex:0];
    [self.colorsArray writeToPlist];
    [self giveFeedback:@"SAVED"];
}

- (IBAction)listAction:(id)sender
{
    [self performSegueWithIdentifier:@"showColorsList" sender:self];
}


#pragma mark - ColorsTableViewController delegate methods
- (void)colorsTableViewControllerDidFinish:(TSDColorsTableViewController *)controller
{
    // different VCs to be dismissed on iPhones and iPads
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.colorsTablePopoverViewController dismissPopoverAnimated:YES];
    }
    
    [self updateColorWithPersistentValues];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showColorsList"]) {
        TSDColorsTableViewController *dvc = segue.destinationViewController;
        dvc.delegate = self;
        dvc.mainViewController = self;
        dvc.colorsArray = self.colorsArray;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.colorsTablePopoverViewController = popoverController;
            popoverController.delegate = self;
        }
    }
}

#pragma mark - iPad only
- (IBAction)togglePopover:(id)sender
{
    if (self.colorsTablePopoverViewController) {
        [self.colorsTablePopoverViewController dismissPopoverAnimated:YES];
        self.colorsTablePopoverViewController = nil;
    } else {
        [self performSegueWithIdentifier:@"showColorsList" sender:self];
    }
}
@end
