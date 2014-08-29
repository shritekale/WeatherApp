//
//  WSCityForecast.m
//  WeatherApp
//
//  Created by Shri on 28/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import "WSCityForecast.h"

@implementation WSCityForecast

-(id) initWithForecastDictionary:(NSDictionary *) dict {
    
    if (self == [super init]) {
        self.citytTemp = [[[dict objectForKey:@"main"] objectForKey:@"temp"] doubleValue];
        self.cityName = [dict objectForKey:@"name"];
        self.cityID = [dict objectForKey:@"id"];
    }
    return self;
}

@end
