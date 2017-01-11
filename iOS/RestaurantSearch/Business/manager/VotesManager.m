//
//  VotesManager.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 1/8/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "VotesManager.h"
#import "FirebaseManager.h"
#import "TimerManager.h"
#import "ListHistoryCommand.h"
#import "InsertHistoryCommand.h"
#import "ListVotesCommand.h"

@import Firebase;

@interface VotesManager () {
    BOOL alreadyVoted;
}

@property (strong, nonatomic) NSMutableArray *placesWithVotes;
@property (strong, nonatomic) NSMutableArray *history;

@end

@implementation VotesManager

+(void)load{
    [super load];
}

- (void)dealloc {
    self.votes = nil;
}

+ (instancetype)sharedInstance{
    static VotesManager *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [VotesManager alloc];
        instance = [instance init];
        
        [instance refreshVotes];
    });
    
    return instance;
}

- (void) refreshVotes{
    self.places = [[NSMutableArray alloc] init];
    self.placesWithVotes = [[NSMutableArray alloc] init];
    self.votes = [[NSMutableArray alloc] init];
    alreadyVoted = YES;
    
    [self getTodayVotes];
    [self getUserVotes];
    [self getHistory];
}

-(void)getTodayVotes{
    [[ListVotesCommand sharedInstance] ListVotesWithBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
        } else {
            self.votes = [[result objectForKey:@"result"] mutableCopy];
            
            [self getMostVotedPlaces];
        }
    }];
}

-(void)getUserVotes{
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[ListVotesCommand sharedInstance] ListVotesByUserID:userID WithBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
        }
        
        NSArray *userVotes = [[result objectForKey:@"result"] mutableCopy];
        
        if(userVotes.count > 0){
            bool foundTodayDate = NO;
            NSDateFormatter *dateFormat = [NSDateFormatter new];
            [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            
            for(NSDictionary* aVote in userVotes){
                NSDate *voteDate = [dateFormat dateFromString:[aVote objectForKey:@"date"]];
                if([TimerManager isToday:voteDate]){
                    foundTodayDate = YES;
                }
            }
            
            if(foundTodayDate){
                alreadyVoted = YES;
            }
            else{
                alreadyVoted = NO;
            }
        }
        else{
            alreadyVoted = NO;
        }
    }];
}

- (void) getHistory{
    [[ListHistoryCommand sharedInstance] ListHistoryWithBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
        } else {
            self.history = [[result objectForKey:@"result"] mutableCopy];
        }
    }];
}

-(int)getVotesForPlaceID:(NSString *) placeID{
    int counter = 0;
    for(NSDictionary *aVote in self.votes){
        NSString * votePlaceID = [aVote objectForKey:@"placeid"];
        if([votePlaceID isEqualToString:placeID]){
            counter++;
        }
    }
    return counter;
}

-(NSMutableArray *) getMostVotedPlaces{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(NSDictionary *aPlace in self.places){
        NSMutableDictionary *aPlaceMutable = [aPlace mutableCopy];
        int votes = [self getVotesForPlaceID:[aPlace objectForKey:@"place_id"]];
        [aPlaceMutable setValue:[NSString stringWithFormat:@"%d",votes] forKey:@"votes"];
        
        [tempArray addObject:[aPlaceMutable copy]];
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"votes"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.placesWithVotes = [[tempArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    [self sendChoosenRestaurantToHistory];
    
    return self.placesWithVotes;
}

-(NSDictionary *)consolidateVotes{
    [self getMostVotedPlaces];
    
    NSDictionary *restaurantOfTheDay = nil;
    
    if(self.placesWithVotes.count > 0){
        restaurantOfTheDay = self.placesWithVotes[0];
    }
    
    return restaurantOfTheDay;
}

- (void)sendChoosenRestaurantToHistory{
    if([[TimerManager sharedInstance] isChooseWinnerTime]){
        [[ListHistoryCommand sharedInstance] ListTodayHistoryWithBlock:^(NSDictionary *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@", error.localizedDescription);
            } else {
                NSArray *results = [result objectForKey:@"result"];
                
                if(results.count == 0){
                    NSDictionary *choosenRestaurant = [[VotesManager sharedInstance] consolidateVotes];
                    
                    [[InsertHistoryCommand sharedInstance] insertHistoryWithPlaceID:[choosenRestaurant objectForKey:@"place_id"]
                                                                      withPlaceName:[choosenRestaurant objectForKey:@"name"]
                                                                      withVoteCount:[NSString stringWithFormat:@"%@", [choosenRestaurant objectForKey:@"votes"]]
                                                                       withLatitude:[[[[choosenRestaurant objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] stringValue]
                                                                      withLongitude:[[[[choosenRestaurant objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] stringValue]
                                                                          withBlock:^(NSDictionary *result, NSError *error) {
                                                                              if(error){
                                                                                  NSLog(@"%@", error.localizedDescription);
                                                                              }
                                                                          }];
                    
                }
            }
        }];
    }
}

-(bool)hasUserAlreadyVotedToday{
    return alreadyVoted;
}

-(void)setUserAlreadyVotedToday{
    alreadyVoted = YES;
}

-(bool)isVoteValidForPlaceID:(NSString *) placeID{
    bool valid = YES;
    
    for(NSDictionary *chosenRestaurants in self.history){
        if([[chosenRestaurants objectForKey:@"placeid"] isEqualToString:placeID]){
            NSDateFormatter *dateFormat = [NSDateFormatter new];
            [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *voteDate = [dateFormat dateFromString:[chosenRestaurants objectForKey:@"date"]];
            
            if([TimerManager isDateSameWeek:voteDate]){
                valid = NO;
            }
        }                
    }
    
    return valid;
}

@end
