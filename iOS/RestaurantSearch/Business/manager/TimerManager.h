//
//  TimerManager.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/9/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerManager : NSObject{
    
}

+(instancetype)sharedInstance;

+(NSDate *) notificationDate;
+(BOOL) isToday:(NSDate *) aDate;
+(BOOL) isDateSameWeek:(NSDate *) aDate;

-(bool)isVoteTime;
-(bool)isChooseWinnerTime;

@end
