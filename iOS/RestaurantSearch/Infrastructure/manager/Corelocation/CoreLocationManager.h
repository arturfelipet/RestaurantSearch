//
//  CoreLocationManager.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/7/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreLocationManager : NSObject{
    
}

+ (instancetype)sharedInstance;
+ (NSString *) notificationObserverString;

- (NSArray *) locations;
- (void)startUpdatingLocations;

@end



