//
//  ListLocationCommand.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ListLocationCommand.h"
#import "Location.h"
#import "LocationVO.h"

@implementation ListLocationCommand

+ (instancetype)sharedInstance
{
    static ListLocationCommand *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [ListLocationCommand alloc];
        instance = [instance init];
    });
    
    return instance;
}

+ (void)listLocationsWithBlock:(ListLocationResponseBlock)responseBlock{
        
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       NSError *error = nil;
                       
                       [DAOFactory configDatabaseManager];
                       
                       id result = [[DatabaseManager sharedInstance] fetchData:ENTITY_LOCATION predicate:[NSPredicate predicateWithFormat:@"formatted_address != nil"] offset:0 limit:0 sortBy:@"lastUpdated" ascending:NO error:&error];
                       
                       NSMutableArray* vos = [NSMutableArray array];
                       
                       if ([result isKindOfClass:[NSArray class]])
                           for (Location *aLocation in result){
                               [vos addObject:[[LocationVO alloc] initWith:aLocation]];
                           }
                       
                       dispatch_async(mainQueue, ^
                                      {                                                                              
                                          if (responseBlock) responseBlock(@{@"result": [vos copy]}, error);
                                      });
                   });
}

- (void)listLocationsNearbyLatitude:(NSString *)lat andLongitude:(NSString *)lng WithBlock:(ListLocationResponseBlock)responseBlock{
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {                       
                       NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=2000&type=restaurant&key=%@", lat, lng, K_GOOGLE_APIS]];                                                                     
                       
                       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                       NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
                       request.HTTPMethod = @"GET";
                       
                       [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                           if (error) {
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (responseBlock) responseBlock(@{@"result": @""}, error);
                                              });
                           } else {
                               NSError *jsonError;
                               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                               NSLog(@"%@", jsonDictionary);
                               
                               NSArray *results = [jsonDictionary objectForKey:@"results"];
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   dispatch_async(mainQueue, ^
                                                  {
                                                      if (responseBlock) responseBlock(@{@"result": [results copy]}, error);
                                                  });
                               });
                           }
                       }]
                        resume];
                   });
}

@end
