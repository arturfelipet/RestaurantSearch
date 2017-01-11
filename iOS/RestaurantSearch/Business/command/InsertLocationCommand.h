//
//  InsertLocationCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

typedef void (^InsertLocationResponseBlock) (NSDictionary *result, NSError *error);

@interface InsertLocationCommand : NSObject

+ (instancetype)sharedInstance;
+ (void)createLocationWithTitle:(NSString *)formatted_address withLatitude:(NSNumber *)lat withLongitude:(NSNumber *)lng withBlock:(InsertLocationResponseBlock)responseBlock;

@end
