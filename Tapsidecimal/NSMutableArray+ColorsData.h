//
//  NSMutableArray+ColorsData.h
//  Tapsidecimal
//
//  Created by Colin on 3/12/14.
//  Copyright (c) 2014 Colin Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ColorsData)

- (void)writeToPlist;
+ (NSMutableArray *)arrayWithContentsOfPlist;

@end
