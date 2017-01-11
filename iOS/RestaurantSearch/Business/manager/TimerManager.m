//
//  TimerManager.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/9/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "TimerManager.h"

@implementation TimerManager

+(void)load{
    [super load];
}

- (void)dealloc {
    
}

+ (instancetype)sharedInstance{
    static TimerManager *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [TimerManager alloc];
        instance = [instance init];                
    });
    
    return instance;
}

+ (BOOL)date:(NSDate*)date isAfterDate:(NSDate*)evalDate{
    if ([date compare:evalDate] == NSOrderedAscending)
        return NO;
    
    return YES;
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

+(NSDate *) notificationDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *compsForFireDate = [calendar components:(NSCalendarUnitYear | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate: [NSDate date]];
    
    NSArray *notificationTime = [K_WinnerNotificationTime componentsSeparatedByString:@":"];
    
    [compsForFireDate setHour:[notificationTime[0] intValue]];
    [compsForFireDate setMinute:[notificationTime[1] intValue]] ;
    [compsForFireDate setSecond:0] ;
    
    return [calendar dateFromComponents:compsForFireDate];
}

+(BOOL) isToday:(NSDate *) aDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    NSDate *today = [cal dateFromComponents:components];
    
    components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:aDate];
    
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL) isDateSameWeek:(NSDate *) aDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *today = [NSDate date];
    
    NSDateComponents *todaysComponents =
    [gregorian components:NSCalendarUnitWeekOfYear
                 fromDate:today];
    
    NSUInteger todaysWeek = [todaysComponents weekOfYear];
    
    
    
    NSDateComponents *otherComponents =
    [gregorian components:NSCalendarUnitWeekOfYear fromDate:aDate];
    
    NSUInteger anotherWeek = [otherComponents weekOfYear];
    
    if(todaysWeek==anotherWeek){
        return YES;
    }else{
        return NO;
    }        
}

- (bool)isVoteTime{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat: @"yyyy-MM-dd"];
    NSString *todayDateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *startString = [NSString stringWithFormat:@"%@ %@", todayDateString, K_VotesStartTime];
    NSString *endString = [NSString stringWithFormat:@"%@ %@", todayDateString, K_VotesEndTime];
    
    
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [dateFormat dateFromString:startString];
    NSDate *endDate = [dateFormat dateFromString:endString];
    
    NSDate *nowDate = [NSDate date];
    
    BOOL voteTimeOpen = [TimerManager date:nowDate isBetweenDate:startDate andDate:endDate];
    
    return voteTimeOpen;
}

- (bool)isChooseWinnerTime{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat: @"yyyy-MM-dd"];
    NSString *todayDateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *endString = [NSString stringWithFormat:@"%@ %@", todayDateString, K_VotesEndTime];
    
    
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [dateFormat dateFromString:endString];
    
    NSDate *nowDate = [NSDate date];
    
    BOOL chooseWinnerTime = [TimerManager date:nowDate isAfterDate:endDate];
    
    return chooseWinnerTime;
}

@end
