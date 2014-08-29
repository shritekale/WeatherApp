//
//  WSCityForcastTableViewCell.h
//  WeatherApp
//
//  Created by Shri on 28/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSCityForecast.h"

@interface WSCityForcastTableViewCell : UITableViewCell

-(void) updateCellWithForecastForCity:(WSCityForecast *) cityName;

@end
