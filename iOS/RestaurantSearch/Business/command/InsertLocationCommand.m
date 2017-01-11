//
//  InsertLocationCommand.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "InsertLocationCommand.h"
#import "Location.h"
#import "LocationVO.h"

@implementation InsertLocationCommand

+ (instancetype)sharedInstance
{
    static InsertLocationCommand *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [InsertLocationCommand alloc];
        instance = [instance init];
    });
    
    return instance;
}

+ (void)createLocationWithTitle:(NSString *)formatted_address withLatitude:(NSNumber *)lat withLongitude:(NSNumber *)lng withBlock:(InsertLocationResponseBlock)responseBlock{
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       NSError *error;
                       BOOL success = NO;
                       
                       [DAOFactory configDatabaseManager];
                       
                       Location *aLocation = [[DatabaseManager sharedInstance] createObject:ENTITY_LOCATION error:&error];
                       
                       aLocation.formatted_address = formatted_address;
                       aLocation.lat = lat;
                       aLocation.lng = lng;
                       aLocation.lastUpdated = [NSDate date];
                                       
                       [[DatabaseManager sharedInstance] saveContext:&error];
                       
                       if(!error){
                           success = YES;
                       }
                       
                       dispatch_async(mainQueue, ^
                                      {
                                          responseBlock(@{@"result": [[LocationVO alloc] initWith:aLocation]}, error);
                                      });
                   });
}

@end
