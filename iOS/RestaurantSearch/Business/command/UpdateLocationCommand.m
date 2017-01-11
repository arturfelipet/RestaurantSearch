//
//  UpdateLocationCommand.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "UpdateLocationCommand.h"
#import "Location.h"

@implementation UpdateLocationCommand

+ (instancetype)sharedInstance
{
    static UpdateLocationCommand *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [UpdateLocationCommand alloc];
        instance = [instance init];
    });
    
    return instance;
}

+ (void)updateSearch:(LocationVO *)aLocationVO WithBlock:(UpdateLocationResponseBlock)responseBlock{
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       
                       NSError *error;
                       BOOL success = NO;
                       NSMutableArray *updatedArray = [[NSMutableArray alloc] init];
                       
                       [DAOFactory configDatabaseManager];
                       
                       id result = [[DatabaseManager sharedInstance] fetchData:ENTITY_LOCATION
                                                                     predicate:[NSPredicate predicateWithFormat:@"ANY formatted_address == %@ and lastUpdated == %@", aLocationVO.formatted_address, aLocationVO.lastUpdated] offset:0 limit:0 sortBy:nil ascending:YES error:&error];
                       
                       if(result){
                           if([result isKindOfClass:[NSArray class]]){
                               if(((NSArray *)result).count > 0){
                                   for(Location *aLocation in result){
                                       aLocation.formatted_address = aLocationVO.formatted_address;
                                       aLocation.lat = aLocationVO.lat;
                                       aLocation.lng = aLocationVO.lng;
                                       aLocation.lastUpdated = [NSDate date];
                                       
                                       [[DatabaseManager sharedInstance] saveContext:&error];
                                       
                                       id result = [[DatabaseManager sharedInstance] fetchData:ENTITY_LOCATION predicate:[NSPredicate predicateWithFormat:@"ANY formatted_address == %@ and lastUpdated == %@", aLocation.formatted_address, aLocation.lastUpdated] offset:0 limit:0 sortBy:nil ascending:YES error:&error];
                                       
                                       if(result){
                                           if([result isKindOfClass:[NSArray class]]){
                                               if(((NSArray *)result).count > 0){
                                                   for(Location *aLocation in result){
                                                       [updatedArray addObject:[[LocationVO alloc] initWith:aLocation]];
                                                   }
                                               }
                                           }
                                       }
                                   }
                                   
                                   if(!error){
                                       success = YES;
                                   }
                               }
                           }
                           
                           dispatch_async(mainQueue, ^
                                          {
                                              if (responseBlock) responseBlock(@{@"result": [updatedArray copy]}, error);
                                          });
                       }
                       else{
                           dispatch_async(mainQueue, ^
                                          {
                                              if (responseBlock) responseBlock(nil, error);
                                          });
                       }
                   });

}

@end
