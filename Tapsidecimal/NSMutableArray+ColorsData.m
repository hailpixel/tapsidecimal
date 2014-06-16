//
//  NSMutableArray+ColorsData.m
//  Tapsidecimal
//
//  Created by Colin on 3/12/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import "NSMutableArray+ColorsData.h"

@implementation NSMutableArray (ColorsData)

- (void)writeToPlist
{
    [self writeToURL:[[self class] dataLocation] atomically:YES];
}

+ (NSMutableArray *)arrayWithContentsOfPlist
{
    NSMutableArray *newArray = [super arrayWithContentsOfURL:[self dataLocation]];
    
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
