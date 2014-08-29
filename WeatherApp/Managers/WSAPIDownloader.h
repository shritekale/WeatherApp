//
//  WAAPIDownloader.h
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSArray *);
typedef void(^FailureBlock)(NSError *);

@interface WSAPIDownloader : NSObject

+ (WSAPIDownloader *)sharedInstance;

- (void) getSearchResultsForUrlString:(NSString *) urlString andWithSuccess:(SuccessBlock) success andFailure:(FailureBlock) failure;

- (void) getCityForcastForCity:(NSString *) cityName andWithSuccess:(SuccessBlock) success andFailure:(FailureBlock) failure;

- (void) getMultipleCityForcastForCities:(NSArray *) cityArray andWithSuccess:(SuccessBlock) success andFailure:(FailureBlock) failure;
@end
