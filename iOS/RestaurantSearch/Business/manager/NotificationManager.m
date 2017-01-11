
//
//  NotificationManager.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/9/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "NotificationManager.h"
#import "TimerManager.h"

@interface NotificationManager () {
    
}

@end

@implementation NotificationManager

+(void)load{
    [super load];
}

- (void)dealloc {
    
}

+ (instancetype)sharedInstance{
    static NotificationManager *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [NotificationManager alloc];
        instance = [instance init];
    });
    
    return instance;
}

- (bool) scheduleNotificationWithMessage:(NSString *) message{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.repeatInterval = NSCalendarUnitDay;
    [notification setAlertBody:message];
    [notification setFireDate:[TimerManager notificationDate]];
    [notification setTimeZone:[NSTimeZone systemTimeZone]];
    [[UIApplication sharedApplication] setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
    
    return YES;
}

@end
