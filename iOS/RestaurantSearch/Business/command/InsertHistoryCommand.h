//
//  InsertHistoryCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

typedef void (^InsertHistoryResponseBlock) (NSDictionary *result, NSError *error);

@interface InsertHistoryCommand : NSObject

+ (instancetype)sharedInstance;

- (void)insertHistoryWithPlaceID:(NSString *)placeID withPlaceName:(NSString *)placename withVoteCount:(NSString*) votes withLatitude:(NSString *)lat withLongitude:(NSString *)lng withBlock:(InsertHistoryResponseBlock)responseBlock;

@end
