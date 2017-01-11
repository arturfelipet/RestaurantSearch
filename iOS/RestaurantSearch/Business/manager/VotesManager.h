//
//  VotesManager.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/8/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VotesManager : NSObject{
    
}

@property (strong, nonatomic) NSMutableArray *votes;
@property (strong, nonatomic) NSMutableArray *places;

+(instancetype)sharedInstance;

-(void) refreshVotes;

-(int) getVotesForPlaceID:(NSString *) placeID;
-(NSMutableArray *) getMostVotedPlaces;
-(NSDictionary *)consolidateVotes;

-(bool)hasUserAlreadyVotedToday;
-(bool)isVoteValidForPlaceID:(NSString *) placeID;

@end
