//
//  ListVotesCommand.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

typedef void (^ListVotesResponseBlock) (NSDictionary *result, NSError *error);

@interface ListVotesCommand : NSObject

+ (instancetype)sharedInstance;

- (void)ListVotesWithBlock:(ListVotesResponseBlock)responseBlock;
- (void)ListLiveVotesWithBlock:(ListVotesResponseBlock)responseBlock;
- (void)ListVotesByUserID:(NSString *) userID WithBlock:(ListVotesResponseBlock)responseBlock;

@end
