//
//  User.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/8/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init {
    return [self initWithUsername:@""];
}

- (instancetype)initWithUsername:(NSString *)username {
    self = [super init];
    if (self) {
        self.username = username;
    }
    return self;
}

@end
