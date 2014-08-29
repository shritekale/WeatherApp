//
//  WSForecast.h
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSForecast : NSObject
{
    
}
@property (nonatomic, assign)long date;
@property (nonatomic, assign)double tempDay;
@property (nonatomic, assign)double tempMin;
@property (nonatomic, assign)double tempMax;

@property (nonatomic, assign)double pressure;
@property (nonatomic, assign)double speed;
@property (nonatomic, assign)long humidity;

@property (nonatomic, strong)NSString *weatherDesc;
@property (nonatomic, strong)NSString *weatherIcon;

-(id) initWithForecastDictionary:(NSDictionary *) dict;

@end
