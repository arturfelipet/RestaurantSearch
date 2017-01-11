//
//  CoreLocationManager.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/7/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CoreLocationManager.h"

#define LocationUpdatedNotification @"LocationUpdatedNotification"

@interface CoreLocationManager() <CLLocationManagerDelegate>{
    CLLocationManager *_manager;
    NSArray *_locations;
    NSString *_locationUpdatedNotification;
}

@end

@implementation CoreLocationManager

#pragma mark - Initialization

+ (instancetype)sharedInstance
{
    static CoreLocationManager *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [CoreLocationManager alloc];
        instance = [instance init];
    });
    
    return instance;
}

+(void)load
{
    [super load];
    
    [[CoreLocationManager sharedInstance] startUpdatingLocations];
}

- (void)startUpdatingLocations{
    _manager = [[CLLocationManager alloc] init];
    if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_manager requestWhenInUseAuthorization];
    }
    _manager.delegate = self;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.distanceFilter = 5.0f;
    [_manager startUpdatingLocation];
}

- (NSArray *) locations{
    return _locations;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"Please authorize location services");
        return;
    }
    
    NSLog(@"CLLocationManager error: %@", error.localizedFailureReason);
    return;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    _locations = locations;
    
    [self notifyObservers];
}

- (void)notifyObservers {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:LocationUpdatedNotification
     object:nil];
}

+ (NSString *) notificationObserverString{
    return LocationUpdatedNotification;
}

@end
