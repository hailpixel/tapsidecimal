//
//  TSDColorsDataMutableArray.m
//  Tapsidecimal
//
//  Created by Colin on 3/12/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import "TSDColorsDataMutableArray.h"

@interface TSDColorsDataMutableArray ()

+ (NSURL *)dataLocation;

@end

@implementation TSDColorsDataMutableArray

- (void)writeToPlist
{
    [self writeToURL:[[self class] dataLocation] atomically:YES];
}


+ (TSDColorsDataMutableArray *)array
{
    TSDColorsDataMutableArray *newArray = [super arrayWithContentsOfURL:[self dataLocation]];
    
    if (newArray) return newArray;
    else return [super array];
}


#pragma mark - Private methods
+ (NSURL *)dataLocation
{
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [URLs lastObject];
    
    return [documentsURL URLByAppendingPathComponent:@"colorsArray.plist"];
}

@end
