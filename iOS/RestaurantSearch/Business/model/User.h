//
//  User.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/8/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(strong, nonatomic) NSString *username;

- (instancetype)initWithUsername:(NSString *)username NS_DESIGNATED_INITIALIZER;

@end
