//
//  ListHistoryCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

typedef void (^ListHistoryResponseBlock) (NSDictionary *result, NSError *error);

@interface ListHistoryCommand : NSObject

+ (instancetype)sharedInstance;

- (void)ListHistoryWithBlock:(ListHistoryResponseBlock)responseBlock;
- (void)ListLiveHistoryWithBlock:(ListHistoryResponseBlock)responseBlock;

- (void)ListTodayHistoryWithBlock:(ListHistoryResponseBlock)responseBlock;

@end
