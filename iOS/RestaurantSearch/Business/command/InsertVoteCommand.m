//
//  InsertVoteCommand.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "InsertVoteCommand.h"
#import "FirebaseManager.h"
#import "User.h"

@import Firebase;

@interface InsertVoteCommand () {
    
}

@end

@implementation InsertVoteCommand

+ (instancetype)sharedInstance
{
    static InsertVoteCommand *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [InsertVoteCommand alloc];
        instance = [instance init];
    });
    
    return instance;
}

- (void)insertVoteWithPlaceID:(NSString *)placeID withPlaceName:(NSString *)placename withLatitude:(NSString *)lat withLongitude:(NSString *)lng withBlock:(InsertVoteResponseBlock)responseBlock{
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       NSError *error;
                       
                       NSString *userID = [FIRAuth auth].currentUser.uid;
                       [[[[FirebaseManager defaultFirebaseReference] child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                           // Get user value
                           User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
                           
                           
                           NSDateFormatter *dateFormat = [NSDateFormatter new];
                           [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                           
                           NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
                           
                           NSString *key = [[FirebaseManager usersFirebaseReference] childByAutoId].key;
                           NSDictionary *post = @{@"uid": userID,
                                                  @"author": user.username,
                                                  @"placeid": placeID,
                                                  @"placename": placename,
                                                  @"lat": lat,
                                                  @"lng": lng,
                                                  @"date": dateString};
                           
                           
                           NSDictionary *childUpdates = @{[@"/votes/" stringByAppendingString:key]: post,
                                                          [NSString stringWithFormat:@"/user-votes/%@/%@/", userID, key]: post};
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
