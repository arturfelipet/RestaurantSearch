//
//  InsertHistoryCommand.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "InsertHistoryCommand.h"
#import "FirebaseManager.h"
#import "User.h"

@import Firebase;

@interface InsertHistoryCommand () {
    
}

@end

@implementation InsertHistoryCommand

+ (instancetype)sharedInstance
{
    static InsertHistoryCommand *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [InsertHistoryCommand alloc];
        instance = [instance init];
    });
    
    return instance;
}

- (void)insertHistoryWithPlaceID:(NSString *)placeID withPlaceName:(NSString *)placename withVoteCount:(NSString*) votes withLatitude:(NSString *)lat withLongitude:(NSString *)lng withBlock:(InsertHistoryResponseBlock)responseBlock{
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       NSError *error;
                       
                       NSString *userID = [FIRAuth auth].currentUser.uid;
                       [[[[FirebaseManager defaultFirebaseReference] child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                           
                           User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
                           
                           
                           NSDateFormatter *dateFormat = [NSDateFormatter new];
                           [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                           
                           NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
                           
                           NSString *key = [[FirebaseManager usersFirebaseReference] childByAutoId].key;
                           NSDictionary *post = @{@"uid": userID,
                                                  @"author": user.username,
                                                  @"placeid": placeID,
                                                  @"placename": placename,
                                                  @"votes": votes,
                                                  @"lat": lat,
                                                  @"lng": lng,
                                                  @"date": dateString};
                           
                           
                           NSDictionary *childUpdates = @{[@"/history/" stringByAppendingString:key]: post,
                                                          [NSString stringWithFormat:@"/user-history/%@/%@/", userID, key]: post};
                           [[FirebaseManager defaultFirebaseReference] updateChildValues:childUpdates];
                           
                           dispatch_async(mainQueue, ^
                                          {
                                              responseBlock(@{@"result": [post copy]}, error);
                                          });
                       } withCancelBlock:^(NSError * _Nonnull error) {
                           NSLog(@"%@", error.localizedDescription);
                           
                           dispatch_async(mainQueue, ^
                                          {
                                              responseBlock(@{@"result": @""}, error);
                                          });
                       }];
                   });
}

@end
