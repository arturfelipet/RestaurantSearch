//
//  DBManager.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject


+ (instancetype)sharedInstance;

- (void)listLocations;
- (void)insertLocation:(NSDictionary *) aLocation;
- (void)deleteLocation:(NSDictionary *) aLocation;
- (Boolean)isLocationSaved:(NSDictionary *) aLocation;

@end
