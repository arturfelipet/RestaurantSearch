//
//  DeleteLocationCommand.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "DeleteLocationCommand.h"
#import "Location.h"

@implementation DeleteLocationCommand

+ (instancetype)sharedInstance
{
    static DeleteLocationCommand *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [DeleteLocationCommand alloc];
        instance = [instance init];
    });
    
    return instance;
}

+ (void)deleteLocation:(LocationVO *)aLocationVO WithBlock:(DeleteLocationResponseBlock)responseBlock{
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       NSError *error;
                       BOOL success = NO;
                       NSMutableArray *deletedArray = [[NSMutableArray alloc] init];
                       
                       [DAOFactory configDatabaseManager];
                       
                       id result = [[DatabaseManager sharedInstance] fetchData:ENTITY_LOCATION predicate:[NSPredicate predicateWithFormat:@"ANY formatted_address == %@ and lastUpdated == %@", aLocationVO.formatted_address, aLocationVO.lastUpdated] offset:0 limit:0 sortBy:nil ascending:YES error:&error];
                       
                       if(result){
                           if([result isKindOfClass:[NSArray class]]){
                               if(((NSSet *)result).count > 0){
                                   for(Location *aLocation in result){
                                       [[DatabaseManager sharedInstance] deleteObject:aLocation error:&error];
                                       
                                       [deletedArray addObject:[[LocationVO alloc] initWith:aLocation]];
                                   }
                                   
                                   if(!error){
                                       success = YES;
                                   }
                               }
                           }
                       }
                       
                       dispatch_async(mainQueue, ^
                                      {
                                          if (responseBlock) responseBlock(@{@"result": [deletedArray copy]}, error);
                                      });
                   });
}

@end
