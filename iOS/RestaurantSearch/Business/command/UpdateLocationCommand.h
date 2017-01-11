//
//  UpdateLocationCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "LocationVO.h"

typedef void (^UpdateLocationResponseBlock) (NSDictionary *result, NSError *error);

@interface UpdateLocationCommand : NSObject

+ (instancetype)sharedInstance;
+ (void)updateSearch:(LocationVO *)aLocationVO WithBlock:(UpdateLocationResponseBlock)responseBlock;

@end
