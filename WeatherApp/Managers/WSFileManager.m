//
//  WSFileManager.m
//  Whether_leftshift
//
//  Created by Shri on 03/05/14.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import "WSFileManager.h"

@implementation WSFileManager

+ (WSFileManager *)sharedInstance {
  static WSFileManager *sharedInstance;
  @synchronized(self) {
    if (!sharedInstance)
      sharedInstance = [[WSFileManager alloc] init];
    return sharedInstance;
  }
}

- (void) storeLocationArray:(NSMutableArray *) locArray {
 
  NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Data.plist"];

  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:path] == NO) {
    [fileManager createFileAtPath:path contents:nil attributes:nil];
  }
  [locArray writeToFile:path atomically:YES];
}

- (NSMutableArray *) getLocationArray {

  NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Data.plist"];

  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:path] == NO) {
    return nil;
  }
  NSMutableArray *locationArray=[NSMutableArray arrayWithContentsOfFile:path];
  return locationArray;
}

@end
