//
//  ListLocationCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

typedef void (^ListLocationResponseBlock) (NSDictionary *result, NSError *error);

@interface ListLocationCommand : NSObject

+ (instancetype)sharedInstance;
+ (void)listLocationsWithBlock:(ListLocationResponseBlock)responseBlock;

- (void)listLocationsNearbyLatitude:(NSString *)lat andLongitude:(NSString *)lng WithBlock:(ListLocationResponseBlock)responseBlock;

@end
