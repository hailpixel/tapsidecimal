//
//  UIColor+Tapsidecimal.h
//  Tapsidecimal
//
//  Created by Colin on 3/10/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tapsidecimal)

- (NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

//- (UIColor *)colorWithChangesToHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness;
//- (UIColor *)colorWithChangesToHue:(CGFloat)hue brightness:(CGFloat)brightness;
//- (UIColor *)colorWithChangesToSaturation:(CGFloat)saturation;

@end
