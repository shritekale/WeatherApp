//
//  WSMainViewController.h
//  WeatherApp
//
//  Created by Shri on 27/08/2014.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "MapKit/MKPlacemark.h"
#import "WSDetailForcastViewController.h"

@interface WSMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate, UIActionSheetDelegate, UITextFieldDelegate> {
  
  BOOL shouldShowDetailsView;  
}

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSMutableArray *locationArray;
@property(nonatomic, weak) IBOutlet UITableView *locationTable;
@property(nonatomic, weak) IBOutlet UITextField *cityTextField;

@end
