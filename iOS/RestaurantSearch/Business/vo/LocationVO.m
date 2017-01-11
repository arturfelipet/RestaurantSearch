//
//  LocationVO.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "LocationVO.h"
#import "Location.h"

@implementation LocationVO

- (id)initWith:(Location*)model
{
    self = [super init];
    
    if (self)
    {
        self.lastUpdated = model.lastUpdated;
        self.formatted_address = model.formatted_address;
        self.lat = model.lat;
        self.lng = model.lng;
    }
    
    return self;
}

+ (NSDictionary *)initWith:(Location*)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:model.lastUpdated forKey:@"lastUpdated"];
    [dict setObject:model.formatted_address forKey:@"formatted_address"];
    [dict setObject:model.lat forKey:@"lat"];
    [dict setObject:model.lng forKey:@"lng"];
    
    return dict;
}

@end
