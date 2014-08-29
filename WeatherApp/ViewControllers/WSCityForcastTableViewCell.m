//
//  WSCityForcastTableViewCell.m
//  WeatherApp
//
//  Created by Shri on 28/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import "WSCityForcastTableViewCell.h"
#import "WSAPIDownloader.h"

@implementation WSCityForcastTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.textLabel.font= [UIFont systemFontOfSize:17.0f];
        self.textLabel.textColor=[UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void) updateCellWithForecastForCity:(WSCityForecast *) cityForcast {
    
    self.textLabel.text = cityForcast.cityName;
    BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
    if (isMetric) {
        self.detailTextLabel.text = [NSString stringWithFormat:@"Temp: %.2f °C", cityForcast.citytTemp];
    }
    else {
        self.detailTextLabel.text = [NSString stringWithFormat:@"Temp: %.2f °F", cityForcast.citytTemp];
    }

    self.detailTextLabel.font= [UIFont systemFontOfSize:13.0f];
    self.detailTextLabel.textColor=[UIColor whiteColor];

/*
    [[WSAPIDownloader sharedInstance] getCityForcastForCity:cityName andWithSuccess:^(NSArray *resultArray) {
        WSCityForecast *cityForcast = (WSCityForecast *) [resultArray firstObject];
        BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
        if (isMetric) {
            self.detailTextLabel.text = [NSString stringWithFormat:@"Temp: %.2f °C", cityForcast.citytTemp];
        }
        else {
            self.detailTextLabel.text = [NSString stringWithFormat:@"Temp: %.2f °F", cityForcast.citytTemp];
        }
    } andFailure:^(NSError * error) {
        self.detailTextLabel.text = @"Error retriving temp";
    }];
*/
}

@end
