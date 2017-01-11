//
//  FirebaseManager.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/8/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "FirebaseManager.h"

@interface FirebaseManager (){
    
}

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *usersRef;
@property (strong, nonatomic) FIRDatabaseReference *votesRef;
@property (strong, nonatomic) FIRDatabaseReference *historyRef;

@end

@implementation FirebaseManager

+(void)load
{
    [super load];
}

+ (instancetype)sharedInstance
{
    static FirebaseManager *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [FirebaseManager alloc];
        instance = [instance init];
        
        [instance start];
    });
    
    return instance;
}

- (BOOL) isUserLoggedIn{
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user) {
        return YES;
    }
    else{
        return NO;
    }
}

- (void) start{
    _ref = [[FIRDatabase database] reference];
    [_ref keepSynced:YES];
    
    _votesRef = [[[FIRDatabase database] reference] child:@"votes"];
    [_votesRef keepSynced:YES];
    
    _usersRef = [[[FIRDatabase database] reference] child:@"users"];
    [_usersRef keepSynced:YES];
    
    _usersRef = [[[FIRDatabase database] reference] child:@"history"];
    [_usersRef keepSynced:YES];        
}

+ (FIRDatabaseReference *) defaultFirebaseReference{
    return [FirebaseManager sharedInstance].ref;
}

+ (FIRDatabaseReference *) votesFirebaseReference{
    return [FirebaseManager sharedInstance].votesRef;
}

+ (FIRDatabaseReference *) usersFirebaseReference{
    return [FirebaseManager sharedInstance].usersRef;
}

+ (FIRDatabaseReference *) historyFirebaseReference{
    return [FirebaseManager sharedInstance].usersRef;
}

@end
