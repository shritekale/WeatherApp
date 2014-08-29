//
//  WSDetailForcastViewController.m
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import "WSDetailForcastViewController.h"
#import "WSAPIDownloader.h"

#define kWeatherCityAPI @"http://api.openweathermap.org/data/2.5/forecast/daily?cnt=14&units=metric&APPID=ce72dd0c04db65348c6de8271b277152&q="
#define kWeatherLocationAPI @"http://api.openweathermap.org/data/2.5/forecast/daily?cnt=14&mode=json&units=metric&APPID=ce72dd0c04db65348c6de8271b277152"

#define kTableViewCellHeight 90.0

@interface WSDetailForcastViewController ()

@end

@implementation WSDetailForcastViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    forecastArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  
  [super viewDidLoad];
  
  self.navigationItem.title= self.cityName;
  whetherDetailTable.tableFooterView=[[UIView alloc]init];


  NSString *urlString;
  
  if ([self.cityName length] > 0) {
    urlString=[NSString stringWithFormat:@"%@%@",kWeatherCityAPI , self.cityName];
  }
  else if ([self.latitude length] > 0 && [self.longitude length] > 0) {
    urlString=[NSString stringWithFormat:@"%@&lat=%@&lon=%@",kWeatherLocationAPI, self.latitude, self.longitude];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Something went wrong.. Please go back and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return;
  }
  
  BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
  if (!isMetric) {
    urlString = [urlString stringByReplacingOccurrencesOfString:@"metric" withString:@"imperial"];
  }
  
  spinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [spinner setCenter:self.view.center];
  [self.view addSubview:spinner];
  [spinner startAnimating];
  
  [[WSAPIDownloader sharedInstance] getSearchResultsForUrlString:urlString andWithSuccess:^(NSArray *resultArray) {
    forecastArray = [NSMutableArray arrayWithArray:resultArray];
    [spinner stopAnimating];
    [whetherDetailTable reloadData];
  } andFailure:^(NSError *error) {
    [spinner stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"There was an error downloading content." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }];
  
}

- (void)didReceiveMemoryWarning
{
  spinner = nil;
  [super didReceiveMemoryWarning];
}

#pragma mark
#pragma mark TableViewDelegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [forecastArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"WSCustomTableViewCell";
  WSCustomTableViewCell *cell = (WSCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[WSCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  [cell updateCellWithForecast:[forecastArray objectAtIndex:indexPath.row]];
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return kTableViewCellHeight;
}


@end
