//
//  NotificationManager.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/9/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject{
    
}

+ (instancetype)sharedInstance;

- (bool) scheduleNotificationWithMessage:(NSString *) message;

@end
