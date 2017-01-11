//
//  FirebaseManager.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/8/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface FirebaseManager : NSObject

+ (instancetype)sharedInstance;

+ (FIRDatabaseReference *) defaultFirebaseReference;
+ (FIRDatabaseReference *) votesFirebaseReference;
+ (FIRDatabaseReference *) usersFirebaseReference;
+ (FIRDatabaseReference *) historyFirebaseReference;

- (BOOL) isUserLoggedIn;

@end
