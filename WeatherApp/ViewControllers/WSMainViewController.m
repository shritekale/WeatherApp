//
//  WSMainViewController.m
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import "WSMainViewController.h"
#import "WSCityForcastTableViewCell.h"
#import "WSCityForecast.h"
#import "WSAPIDownloader.h"
#import "Constants.h"

#define kTableViewCellHeight 60.0

@interface WSMainViewController ()
- (NSMutableArray *) getCityList;
@end

@implementation WSMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:kSortTitle style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonPressed:)];
        self.navigationItem.rightBarButtonItem = sortButton;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.cityTextField setText:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title= kWeatherTitle;
    self.locationTable.tableFooterView= [[UIView alloc] init];
    
    [[WSAPIDownloader sharedInstance] getMultipleCityForcastForCities:[self getCityList] andWithSuccess:^(NSArray *resultArray) {
        [self.locationArray removeAllObjects];
        self.locationArray = [NSMutableArray arrayWithArray:resultArray];
        [self.locationTable reloadData];

    } andFailure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kGenralMessageTitle message:kErrorDownloadingMessage delegate:nil cancelButtonTitle:kOKTitle otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *) getCityList {
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:kCityPlist ofType:@"plist"];
    NSArray *plistDataArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    for (id eachObject in plistDataArray) {
        if ([eachObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *cityDict = (NSDictionary *) eachObject;
            WSCityForecast *cityForcast = [[WSCityForecast alloc] init];
            cityForcast.cityID = [cityDict objectForKey:@"cityID"];
            cityForcast.cityName = [cityDict objectForKey:@"cityName"];
            [cityArray addObject:cityForcast];
        }
    }
    return cityArray;
}

#pragma mark
#pragma mark IBActions

-(IBAction) searchButtonPressed:(id)sender {
    if (self.cityTextField.text.length > 0) {
        [self.cityTextField resignFirstResponder];
        WSDetailForcastViewController *detailForcast=[[WSDetailForcastViewController alloc] initWithNibName:@"WSDetailForcastViewController" bundle:nil];
        detailForcast.cityName=self.cityTextField.text;
        [self.navigationController pushViewController:detailForcast animated:YES];
        detailForcast=nil;
    }
    
}

-(IBAction)locationButtonPressed:(id)sender {
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=kCLLocationAccuracyKilometer;
    }
    shouldShowDetailsView = YES;
    [self.locationManager startUpdatingLocation];
}

- (void) sortButtonPressed:(id) sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:kSelectOrder delegate:self cancelButtonTitle:kCancelTitle destructiveButtonTitle:nil otherButtonTitles: kAscending, kDescending, nil];
    [actionSheet showInView:self.view];
}

#pragma mark
#pragma mark CLlocationManager Delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    if (shouldShowDetailsView) {
        WSDetailForcastViewController *detailForcast=[[WSDetailForcastViewController alloc] initWithNibName:@"WSDetailForcastViewController" bundle:nil];
        detailForcast.latitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
        detailForcast.longitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
        [self.navigationController pushViewController:detailForcast animated:YES];
        detailForcast=nil;
    }
    shouldShowDetailsView = NO;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    shouldShowDetailsView = NO;
    UIAlertView *errorAlertView = [[UIAlertView alloc]initWithTitle:nil message:kErrorLocationMessage  delegate:self cancelButtonTitle:kOKTitle otherButtonTitles:nil];
    [errorAlertView show];
}


#pragma mark
#pragma mark TableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"WSCityForcastTableViewCell";
    
    WSCityForcastTableViewCell *cell = (WSCityForcastTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WSCityForcastTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WSCityForecast *cityForcast = [self.locationArray objectAtIndex:indexPath.row];
    [cell updateCellWithForecastForCity:cityForcast];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSDetailForcastViewController *detailForcast=[[WSDetailForcastViewController alloc] initWithNibName:@"WSDetailForcastViewController" bundle:nil];
    WSCityForecast *cityForcast = [self.locationArray objectAtIndex:indexPath.row];
    detailForcast.cityName=cityForcast.cityName;
    [self.navigationController pushViewController:detailForcast animated:YES];
    detailForcast=nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

#pragma mark
#pragma mark Actionsheet Delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self sortCitiesAscending:YES];
            break;
        case 1:
            [self sortCitiesAscending:NO];
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void) sortCitiesAscending:(BOOL) yes {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:(NSArray *) self.locationArray];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"citytTemp"                                                 ascending:yes];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:sortDescriptors];
    self.locationArray = [NSMutableArray arrayWithArray:sortedArray];
    [self.locationTable reloadData];
}

@end
