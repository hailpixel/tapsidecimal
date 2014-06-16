//
//  UIColor+Tapsidecimal.m
//  Tapsidecimal
//
//  Created by Colin on 3/10/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import "UIColor+Tapsidecimal.h"

@implementation UIColor (Tapsidecimal)

- (NSString *)hexString
{
    CGFloat red = 0.0f, green = 0.0f, blue = 0.0f;
    [self getRed:&red green:&green blue:&blue alpha:NULL];
    red *= 255, blue *= 255, green *= 255;
    
    NSArray *colorParts = @[
                            [NSNumber numberWithInt:red],
                            [NSNumber numberWithInt:green],
                            [NSNumber numberWithInt:blue],
                            ];
    
    NSMutableString *hexString = [NSMutableString stringWithString:@"#"];
    for (NSNumber *colorPart in colorParts) {
        [hexString appendString:[NSString stringWithFormat:@"%02X", [colorPart intValue]]];
    }
    
    return hexString;
}

#pragma mark - Convenience constructors
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *pureHex;
    if ([hexString hasPrefix:@"#"]) pureHex = [hexString substringFromIndex:1];
    else if ([hexString hasPrefix:@"0x"]) pureHex = [hexString substringFromIndex:2];
    
    NSString *redString = [pureHex substringToIndex:2];
    NSString *greenString = [pureHex substringWithRange:NSMakeRange(2, 2)];
    NSString *blueString = [pureHex substringWithRange:NSMakeRange(4, 2)];
    
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redString] scanHexInt:&red];
    [[NSScanner scannerWithString:greenString] scanHexInt:&green];
    [[NSScanner scannerWithString:blueString] scanHexInt:&blue];
    
    return [UIColor colorWithRed:((float)red / 255) green:((float)green / 255) blue:((float)blue / 255) alpha:1.0f];
}

//- (UIColor *)colorWithChangesToHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness
//{
//    CGFloat colorHue = 0.0f, colorSaturation = 0.0f, colorBrightness = 0.0f;
//    [self getHue:&colorHue saturation:&colorSaturation brightness:&colorBrightness alpha:NULL];
//    
//    colorHue += hue;
//    if (colorHue > 1.0f) colorHue -= 1.0f;
//    else if (colorHue < 0.0f) colorHue += 1.0f;
//    
//    colorSaturation += saturation;
//    colorBrightness += brightness;
//    
//    return [UIColor colorWithHue:colorHue saturation:colorSaturation brightness:colorBrightness alpha:1.0f];
//}
//
//- (UIColor *)colorWithChangesToHue:(CGFloat)hue brightness:(CGFloat)brightness
//{
//    return [self colorWithChangesToHue:hue saturation:0.0f brightness:brightness];
//}
//
//- (UIColor *)colorWithChangesToSaturation:(CGFloat)saturation
//{
//    return [self colorWithChangesToHue:0.0f saturation:saturation brightness:0.0f];
//}

@end