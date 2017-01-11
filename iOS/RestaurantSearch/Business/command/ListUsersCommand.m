//
//  ListUsersCommand.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "ListUsersCommand.h"
@import Firebase;

@interface ListUsersCommand () {
    
}

@end

@implementation ListUsersCommand

+ (instancetype)sharedInstance
{
    static ListUsersCommand *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [ListUsersCommand alloc];
        instance = [instance init];
    });
    
    return instance;
}

- (void)dealloc {
    
}

- (void)signInWithEmail:(NSString *)mail andPassword:(NSString *)password WithBlock:(ListUsersResponseBlock)responseBlock{
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       [[FIRAuth auth] signInWithEmail:mail
                                              password:password
                                            completion:^(FIRUser *user, NSError *error) {
                                                if (error) {
                                                    dispatch_async(mainQueue, ^
                                                                   {
                                                                       if (responseBlock) responseBlock(@{@"result": @""}, error);
                                                                   });
                                                }
                                                
                                                dispatch_async(mainQueue, ^
                                                               {
                                                                   if (responseBlock) responseBlock(@{@"result": user.uid}, error);
                                                               });
                                            }];                                              
                   });
    
}

- (void)signOutWithBlock:(ListUsersResponseBlock)responseBlock{
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       NSError *error;
                       BOOL status = [[FIRAuth auth] signOut:&error];
                       if (!status) {
                           dispatch_async(mainQueue, ^
                                          {
                                              if (responseBlock) responseBlock(@{@"result": @""}, error);
                                          });
                       }
                       
                       dispatch_async(mainQueue, ^
                                      {
                                          if (responseBlock) responseBlock(@{@"result": @"ok"}, error);
                                      });
                   });
}

@end
