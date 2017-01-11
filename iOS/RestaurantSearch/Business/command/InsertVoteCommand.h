//
//  InsertVoteCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//



typedef void (^InsertVoteResponseBlock) (NSDictionary *result, NSError *error);

@interface InsertVoteCommand : NSObject

+ (instancetype)sharedInstance;

- (void)insertVoteWithPlaceID:(NSString *)placeID withPlaceName:(NSString *)placename withLatitude:(NSString *)lat withLongitude:(NSString *)lng withBlock:(InsertVoteResponseBlock)responseBlock;

@end
