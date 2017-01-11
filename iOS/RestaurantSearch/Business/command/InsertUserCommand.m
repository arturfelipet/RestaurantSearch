//
//  InsertUserCommand.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "InsertUserCommand.h"
#import "FirebaseManager.h"
#import "User.h"

@import Firebase;

@interface InsertUserCommand () {
    
}

@end

@implementation InsertUserCommand

+ (instancetype)sharedInstance
{
    static InsertUserCommand *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [InsertUserCommand alloc];
        instance = [instance init];
    });
    
    return instance;
}

- (void)createUserWithEmail:(NSString *)mail withPassword:(NSString *)password withUserName:(NSString *)username withBlock:(InsertUserResponseBlock)responseBlock{
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create([[NSString stringWithFormat:@"RestaurantSearch.%@", NSStringFromClass([self class])] UTF8String], NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(backgroundQueue, ^
                   {
                       [[FIRAuth auth] createUserWithEmail:mail
                                                  password:password
                                                completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                                    if (error) {
                                                        dispatch_async(mainQueue, ^
                                                                       {
                                                                           responseBlock(@{@"result": @""}, error);
                                                                       });
                                                    }
                                                    else{
                                                        FIRUserProfileChangeRequest *changeRequest =
                                                        [[FIRAuth auth].currentUser profileChangeRequest];
                                                        changeRequest.displayName = username;
                                                        [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                                                            [[[[FirebaseManager defaultFirebaseReference] child:@"users"] child:user.uid] setValue:@{@"username": username}];
                                                            
                                                            if (error) {
                                                                dispatch_async(mainQueue, ^
                                                                               {
                                                                                   responseBlock(@{@"result": @""}, error);
                                                                               });
                                                            }
                                                            else{
                                                                dispatch_async(mainQueue, ^
                                                                               {
                                                                                   NSString *userID = [FIRAuth auth].currentUser.uid;
                                                                                   
                                                                                   responseBlock(@{@"result": userID}, error);
                                                                               });
                                                            }
                                                        }];
                                                    }
                                                }];                                              
                   });
}

@end
