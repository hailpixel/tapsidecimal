//
//  TSDMainViewController.h
//  Tapsidecimal
//
//  Created by Colin on 3/9/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import "TSDFlipsideViewController.h"

@interface TSDMainViewController : UIViewController <TSDFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
