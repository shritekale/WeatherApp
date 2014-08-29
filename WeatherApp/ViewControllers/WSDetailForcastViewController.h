//
//  WSDetailForcastViewController.h
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSForecast.h"
#import "WSCustomTableViewCell.h"

@interface WSDetailForcastViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
  IBOutlet UITableView *whetherDetailTable;
  NSMutableArray *forecastArray;
  WSForecast *forecastObject;
  
  UIActivityIndicatorView *spinner;
}

@property(strong,nonatomic) NSString *cityName;
@property (nonatomic, strong) NSString* latitude;
@property (nonatomic, strong) NSString* longitude;

@end
