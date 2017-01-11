//
//  ListUsersCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

typedef void (^ListUsersResponseBlock) (NSDictionary *result, NSError *error);

@interface ListUsersCommand : NSObject

+ (instancetype)sharedInstance;

- (void)signInWithEmail:(NSString *)mail andPassword:(NSString *)password WithBlock:(ListUsersResponseBlock)responseBlock;
- (void)signOutWithBlock:(ListUsersResponseBlock)responseBlock;

@end
