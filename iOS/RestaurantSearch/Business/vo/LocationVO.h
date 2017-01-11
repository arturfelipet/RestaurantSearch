//
//  LocationVO.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseVO.h"
#import "Location.h"

@interface LocationVO : BaseVO

@property (nonatomic, retain) NSString *formatted_address;
@property (nonatomic, retain) NSNumber *lat;
@property (nonatomic, retain) NSNumber *lng;

+ (NSDictionary *)initWith:(Location*)model;

- (id)initWith:(Location*)model;

@end
