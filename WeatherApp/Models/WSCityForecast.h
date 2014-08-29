//
//  WSCityForecast.h
//  WeatherApp
//
//  Created by Shri on 28/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSCityForecast : NSObject {
    
}

@property (nonatomic, assign) double citytTemp;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityID;

-(id) initWithForecastDictionary:(NSDictionary *) dict;

@end
