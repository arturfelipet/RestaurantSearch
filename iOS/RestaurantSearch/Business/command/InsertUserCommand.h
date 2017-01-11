//
//  InsertUserCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

typedef void (^InsertUserResponseBlock) (NSDictionary *result, NSError *error);

@interface InsertUserCommand : NSObject

+ (instancetype)sharedInstance;

- (void)createUserWithEmail:(NSString *)mail withPassword:(NSString *)password withUserName:(NSString *)username withBlock:(InsertUserResponseBlock)responseBlock;

@end
