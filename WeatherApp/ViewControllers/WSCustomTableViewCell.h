//
//  WSCustomTableViewCell.h
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSForecast.h"

@interface WSCustomTableViewCell : UITableViewCell {
  
}

@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UILabel *description;
@property (nonatomic, weak) UILabel *minLabel;
@property (nonatomic, weak) UILabel *maxLabel;
@property (nonatomic, weak) UILabel *humidityLabel;
@property (nonatomic, weak) UILabel *windLabel;
@property (nonatomic, weak) UIImageView *forcastImage;

-(void) updateCellWithForecast:(WSForecast *) foreCast;
@end
