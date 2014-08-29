//
//  NSDate+Extensions.m
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

-(NSString *) getSimpleString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-LLL-yyyy"];
    return [dateFormatter stringFromDate:self];
}

@end
