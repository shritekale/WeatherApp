//
//  WAAPIDownloader.m
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import "WSAPIDownloader.h"
#import "WSForecast.h"
#import "WSCityForecast.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kWeatherCityAPI @"http://api.openweathermap.org/data/2.5/weather?units=metric&q="
#define kWeatherMultiCityAPI @"http://api.openweathermap.org/data/2.5/group?units=metric&id="


@implementation WSAPIDownloader

+ (WSAPIDownloader *)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) getSearchResultsForUrlString:(NSString *) urlString andWithSuccess:(SuccessBlock) success andFailure:(FailureBlock) failure {
  dispatch_async(kBgQueue, ^{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData* responseData = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
    NSError *error;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([responseData length] <= 0) {
      failure([NSError errorWithDomain:@"NoData" code:404 userInfo:nil]);
      return;
    }
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions
                                                           error:&error];
    
    if (error == nil) {
      NSString *responseCode = [json objectForKey:@"cod"];
      if ([responseCode isEqualToString:@"200"]) {
        NSArray *listArray = [json objectForKey:@"list"];
        NSMutableArray *forecastArray = [[NSMutableArray alloc] initWithCapacity:[listArray count]];
        for (NSDictionary *eachDict in listArray) {
          WSForecast *singleForcast = [[WSForecast alloc] initWithForecastDictionary:eachDict];
          [forecastArray addObject:singleForcast];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
          success((NSArray *)forecastArray);
        });
      }
      else {
        dispatch_sync(dispatch_get_main_queue(), ^{
          failure([NSError errorWithDomain:@"ErrorData" code:[responseCode integerValue] userInfo:nil]);
        });
      }
    }
    else {
      dispatch_sync(dispatch_get_main_queue(), ^{
        failure(error);
      });
    }
  });
}


- (void) getCityForcastForCity:(NSString *) cityName andWithSuccess:(SuccessBlock) success andFailure:(FailureBlock) failure {
    dispatch_async(kBgQueue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *urlString= [NSString stringWithFormat:@"%@%@",kWeatherCityAPI , cityName];
        BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
        if (!isMetric) {
            urlString = [urlString stringByReplacingOccurrencesOfString:@"metric" withString:@"imperial"];
        }

        NSData* responseData = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
        NSError *error;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseData length] <= 0) {
            failure([NSError errorWithDomain:@"NoData" code:404 userInfo:nil]);
            return;
        }
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions
                                                               error:&error];
        if (error == nil) {
            NSMutableArray *forecastArray = [[NSMutableArray alloc] initWithCapacity:1];
            WSCityForecast *cityForcast = [[WSCityForecast alloc] initWithForecastDictionary:json];
            [forecastArray addObject:cityForcast];
            dispatch_sync(dispatch_get_main_queue(), ^{
                success((NSArray *)forecastArray);
            });
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failure([NSError errorWithDomain:@"ErrorData" code:[[json objectForKey:@"cod"] integerValue] userInfo:nil]);
            });
        }
    });
}

- (void) getMultipleCityForcastForCities:(NSArray *) cityArray andWithSuccess:(SuccessBlock) success andFailure:(FailureBlock) failure {
    dispatch_async(kBgQueue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *cityIDs = @"";
        for (WSCityForecast *cityForcast in cityArray) {
            cityIDs = [cityIDs stringByAppendingString:cityForcast.cityID];
            cityIDs = [cityIDs stringByAppendingString:@","];
        }
        NSString *urlString= [NSString stringWithFormat:@"%@%@",kWeatherMultiCityAPI , cityIDs];
        BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
        if (!isMetric) {
            urlString = [urlString stringByReplacingOccurrencesOfString:@"metric" withString:@"imperial"];
        }
        
        NSData* responseData = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
        NSError *error;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseData length] <= 0) {
            failure([NSError errorWithDomain:@"NoData" code:404 userInfo:nil]);
            return;
        }
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions
                                                               error:&error];
        if (error == nil) {
            NSArray *listArray = [json objectForKey:@"list"];
            NSMutableArray *forecastArray = [[NSMutableArray alloc] initWithCapacity:[listArray count]];
            for (NSDictionary *eachDict in listArray) {
                WSCityForecast *cityForcast = [[WSCityForecast alloc] initWithForecastDictionary:eachDict];
                [forecastArray addObject:cityForcast];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                success((NSArray *)forecastArray);
            });
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failure([NSError errorWithDomain:@"ErrorData" code:[[json objectForKey:@"cod"] integerValue] userInfo:nil]);
            });
        }
    });

}

@end
