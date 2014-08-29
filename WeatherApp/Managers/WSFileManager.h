//
//  WSFileManager.h
//  Whether_leftshift
//
//  Created by Shri on 03/05/14.
//  Copyright (c) 2014 Shri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSFileManager : NSObject

+ (WSFileManager *)sharedInstance;

- (void) storeLocationArray:(NSMutableArray *) locArray;
- (NSMutableArray *) getLocationArray;

@end
