//
//  WSCustomTableViewCell.m
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import "WSCustomTableViewCell.h"
#import "NSDate+Extensions.h"

#define kWthetherImageURL @"http://openweathermap.org/img/w/"

@implementation WSCustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,12,270,20)];
    descriptionLabel.textAlignment=NSTextAlignmentCenter;
    descriptionLabel.backgroundColor=[UIColor clearColor];
    descriptionLabel.font=[UIFont boldSystemFontOfSize:18.0f];
    descriptionLabel.textColor=[UIColor whiteColor];
    self.description = descriptionLabel;
    [self.contentView addSubview:descriptionLabel];
    
    UIImageView *forcastImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,10,50,50)];
    //        forcastImage.image=[UIImage imageNamed:@"wathericons_0012_Layer-16.png"];
    self.forcastImage = forcastImage;
    [self.contentView addSubview:forcastImage];
    
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,62,120,20)];
    dateLabel.textAlignment=NSTextAlignmentLeft;
    dateLabel.backgroundColor=[UIColor clearColor];
    dateLabel.font=[UIFont systemFontOfSize:13.0f];
    dateLabel.textColor=[UIColor blueColor];
    self.dateLabel = dateLabel;
    [self.contentView addSubview:dateLabel];
    
    
    UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,50,140,20)];
    maxLabel.textAlignment=NSTextAlignmentLeft;
    maxLabel.backgroundColor=[UIColor clearColor];
    maxLabel.font=[UIFont systemFontOfSize:13.0f];
    maxLabel.textColor=[UIColor whiteColor];
    self.maxLabel = maxLabel;
    [self.contentView addSubview:maxLabel];
    
    
    UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,67,140,20)];
    minLabel.textAlignment=NSTextAlignmentLeft;
    minLabel.backgroundColor=[UIColor clearColor];
    minLabel.font=[UIFont systemFontOfSize:13.0f];
    minLabel.textColor=[UIColor whiteColor];
    self.minLabel = minLabel;
    [self.contentView addSubview:minLabel];
    
    
    UILabel *humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(210,50,140,20)];
    humidityLabel.textAlignment=NSTextAlignmentLeft;
    humidityLabel.backgroundColor=[UIColor clearColor];
    humidityLabel.font=[UIFont systemFontOfSize:13.0f];
    humidityLabel.textColor=[UIColor whiteColor];
    self.humidityLabel = humidityLabel;
    [self.contentView addSubview:humidityLabel];
    
    UILabel *windLabel = [[UILabel alloc] initWithFrame:CGRectMake(210,67,140,20)];
    windLabel=[[UILabel alloc] initWithFrame:CGRectMake(210,67,140,20)];
    windLabel.textAlignment=NSTextAlignmentLeft;
    windLabel.backgroundColor=[UIColor clearColor];
    windLabel.font=[UIFont systemFontOfSize:13.0f];
    windLabel.textColor=[UIColor whiteColor];
    self.windLabel = windLabel;
    [self.contentView addSubview:windLabel];
    
  }
  return self;
}

-(void) updateCellWithForecast:(WSForecast *) forecast
{
  self.forcastImage.image = nil;
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:forecast.date];
  self.dateLabel.text= [date getSimpleString];
  
  BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
  if (isMetric) {
    self.minLabel.text = [NSString stringWithFormat:@"Low %.2f °C",forecast.tempMin];
    self.maxLabel.text = [NSString stringWithFormat:@"High %.2f °C",forecast.tempMax];
    self.windLabel.text = [NSString stringWithFormat:@"Wind %.2f m/s",forecast.speed];
  }
  else {
    self.minLabel.text = [NSString stringWithFormat:@"Low %.2f °F",forecast.tempMin];
    self.maxLabel.text = [NSString stringWithFormat:@"High %.2f °F",forecast.tempMax];
    self.windLabel.text = [NSString stringWithFormat:@"Wind %.2f mph",forecast.speed];
  }
  
  self.humidityLabel.text =[NSString stringWithFormat:@"Humdity %ld %%",forecast.humidity];
  self.description.text=forecast.weatherDesc;
  
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
  dispatch_async(queue, ^(void) {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",kWthetherImageURL,forecast.weatherIcon]]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    if (image) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.forcastImage.image = image;
      });
    }
  });
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
