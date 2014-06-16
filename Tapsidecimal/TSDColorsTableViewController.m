//
//  TSDColorsTableViewController.m
//  Tapsidecimal
//
//  Created by Colin on 3/10/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import "TSDColorsTableViewController.h"
#import "TSDMainViewController.h"
#import "UIColor+Tapsidecimal.h"
#import "NSMutableArray+ColorsData.h"

@interface TSDColorsTableViewController ()

@property (strong, nonatomic) UIColor *selectedColor;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation TSDColorsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If using the Main_iPhone storyboard, hide the status bar when displaying the list
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mainViewController.colorsTablePopoverViewController = nil;
}

// Necessary to override this method to hide the status bar on the iPhone
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Table view data source methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.colorsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // stop cell from obscuring color when selected
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // grab colorsArray hex and instantiate color
    NSString *hexString = [self.colorsArray objectAtIndex:[indexPath indexAtPosition:1]];
    UIColor *cellColor = [UIColor colorWithHexString:hexString];
    cell.backgroundColor = cellColor;
    
    // get color attributes for labels
    CGFloat hue = 0.0f, saturation = 0.0f, brightness = 0.0f;
    [cellColor getHue:&hue saturation:&saturation brightness:&brightness alpha:NULL];
    
    // get references to cell contentView elements and set their values
    UILabel *hueLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *saturationLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *brightnessLabel = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel *hexLabel = (UILabel *)[cell.contentView viewWithTag:4];
    
    hueLabel.text = [NSString stringWithFormat:@"%d", (int)(hue * 360)];
    saturationLabel.text = [NSString stringWithFormat:@"%d", (int)(saturation * 100)];
    brightnessLabel.text = [NSString stringWithFormat:@"%d", (int)(brightness * 100)];
    hexLabel.text = hexString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get selected color for handling UIActionSheet choices
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedColor = selectedCell.backgroundColor;
    
    NSString *actionSheetTitle = [self.selectedColor hexString];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Copy Hex to Clipboard", @"Load Color to Main View", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    // ***NB when run on an iPad, triggers a log message: "setting the first responder view of the table but we don't know its type (cell/header/footer)"
    // but it doesn't seem to affect the UIActionSheet or tableView negatively and at least one Apple employee says it can be safely ignored: http://devforums.apple.com/message/717898#717898
    [actionSheet showFromRect:selectedCell.frame inView:selectedCell animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the color, update the .plist, and remove the row
        [self.colorsArray removeObjectAtIndex:[indexPath indexAtPosition:1]];
        [self.colorsArray writeToPlist];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
 
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Action handling
#pragma mark UIActionSheet delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [UIPasteboard generalPasteboard].string = actionSheet.title;
    }
    
    if (buttonIndex == 1) {
        // Set the mainViewController's persistent color values, then call delegate method
        CGFloat hue = 0.0f, saturation = 0.0f, brightness = 0.0f;
        [self.selectedColor getHue:&hue saturation:&saturation brightness:&brightness alpha:NULL];
        
        self.mainViewController.hue = hue;
        self.mainViewController.saturation = saturation;
        self.mainViewController.brightness = brightness;
        
        // Delegate method dismisses view controller and updates mainViewController background with HSB values
        [self.delegate colorsTableViewControllerDidFinish:self];
    }
}

#pragma mark Button handling
- (IBAction)doneAction:(id)sender
{
    [self.delegate colorsTableViewControllerDidFinish:self];
}
@end
