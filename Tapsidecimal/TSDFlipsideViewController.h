//
//  TSDFlipsideViewController.h
//  Tapsidecimal
//
//  Created by Colin on 3/9/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSDFlipsideViewController;

@protocol TSDFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(TSDFlipsideViewController *)controller;
@end

@interface TSDFlipsideViewController : UIViewController

@property (weak, nonatomic) id <TSDFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
