//
//  DeleteLocationCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationVO.h"

typedef void (^DeleteLocationResponseBlock) (NSDictionary *result, NSError *error);

@interface DeleteLocationCommand : NSObject

+ (instancetype)sharedInstance;
+ (void)deleteLocation:(LocationVO *)aLocationVO WithBlock:(DeleteLocationResponseBlock)responseBlock;

@end
