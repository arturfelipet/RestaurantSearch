//
//  ListVotesCommand.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "ListVotesCommand.h"
#import "FirebaseManager.h"
@import Firebase;

@interface ListVotesCommand () {
    
}

@end

@implementation ListVotesCommand

+ (instancetype)sharedInstance
{
    static ListVotesCommand *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [ListVotesCommand alloc];
        instance = [instance init];
    });
    
    return instance;
}

- (void)dealloc {
    
}

- (void)ListVotesWithBlock:(ListVotesResponseBlock)responseBlock{
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       NSError *error = nil;
                       
                       NSDateFormatter *dateFormat = [NSDateFormatter new];
                       [dateFormat setDateFormat: @"yyyy-MM-dd"];
                       NSString *todayDateString = [dateFormat stringFromDate:[NSDate date]];
                       
                       NSString *startDate = [NSString stringWithFormat:@"%@ %@", todayDateString, K_SearchStartTime];
                       NSString *endDate = [NSString stringWithFormat:@"%@ %@", todayDateString, K_SearchEndTime];
                       
                       [[[[[[FirebaseManager defaultFirebaseReference] child:@"votes"] queryOrderedByChild:@"date"] queryStartingAtValue:startDate] queryEndingAtValue:endDate] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                           NSEnumerator *children = [snapshot children];
                           FIRDataSnapshot *child;
                           NSMutableArray *votes = [[NSMutableArray alloc] init];
                           
                           while (child = [children nextObject]) {
                               [votes addObject:child.value];
                           }
                           
                           dispatch_async(mainQueue, ^
                                          {
                                              if (responseBlock) responseBlock(@{@"result": [votes copy]}, error);
                                          });
                           
                       } withCancelBlock:^(NSError * _Nonnull error) {
                           NSLog(@"%@", error.localizedDescription);
                           
                           dispatch_async(mainQueue, ^
                                          {
                                              if (responseBlock) responseBlock(@{@"result": @""}, error);
                                          });
                       }];
                   });
    
}

- (void)ListLiveVotesWithBlock:(ListVotesResponseBlock)responseBlock{
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       NSError *error = nil;
                       
                       NSDateFormatter *dateFormat = [NSDateFormatter new];
                       [dateFormat setDateFormat: @"yyyy-MM-dd"];
                       NSString *todayDateString = [dateFormat stringFromDate:[NSDate date]];
                       
                       NSString *startDate = [NSString stringWithFormat:@"%@ %@", todayDateString, K_SearchStartTime];
                       NSString *endDate = [NSString stringWithFormat:@"%@ %@", todayDateString, K_SearchEndTime];
                       
                       [[[[[[FirebaseManager votesFirebaseReference] queryOrderedByChild:@"date"] queryStartingAtValue:startDate] queryEndingAtValue:endDate] queryLimitedToLast:50]
                        observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {

                            NSLog(@"key: %@ value: %@", snapshot.key, snapshot.value);
                            
                            NSMutableDictionary *vote = [[NSMutableDictionary alloc] init];
                            [vote setObject:[snapshot.value objectForKey:@"author"]  forKey:@"author"];
                            [vote setObject:[snapshot.value objectForKey:@"date"]  forKey:@"date"];
                            [vote setObject:[snapshot.value objectForKey:@"lat"]  forKey:@"lat"];
                            [vote setObject:[snapshot.value objectForKey:@"lng"]  forKey:@"lng"];
                            [vote setObject:[snapshot.value objectForKey:@"placeid"]  forKey:@"placeid"];
                            [vote setObject:[snapshot.value objectForKey:@"placename"]  forKey:@"placename"];
                            [vote setObject:[snapshot.value objectForKey:@"uid"]  forKey:@"uid"];
                            
                            dispatch_async(mainQueue, ^
                                           {
                                               if (responseBlock) responseBlock(@{@"result": [vote copy]}, error);
                                           });
                        }];
                   });
    
}

- (void)ListVotesByUserID:(NSString *) userID WithBlock:(ListVotesResponseBlock)responseBlock{
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       NSError *error = nil;                       
                       
                       [[[[[FirebaseManager defaultFirebaseReference] child:@"votes"] queryOrderedByChild:@"uid"] queryEqualToValue:userID]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                           NSEnumerator *children = [snapshot children];
                           FIRDataSnapshot *child;
                           NSMutableArray *votes = [[NSMutableArray alloc] init];
                           
                           while (child = [children nextObject]) {
                               [votes addObject:child.value];
                           }
                           
                           dispatch_async(mainQueue, ^
                                          {
                                              if (responseBlock) responseBlock(@{@"result": [votes copy]}, error);
                                          });
                           
                       } withCancelBlock:^(NSError * _Nonnull error) {
                           NSLog(@"%@", error.localizedDescription);
                           
                           dispatch_async(mainQueue, ^
                                          {
                                              if (responseBlock) responseBlock(@{@"result": @""}, error);
                                          });
                       }];
                   });
    
}

@end
