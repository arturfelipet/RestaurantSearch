//
//  RestaurantSearchTests.m
//  RestaurantSearchTests
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DatabaseManager.h"
#import "ListLocationCommand.h"
#import "ListVotesCommand.h"
#import "NotificationManager.h"
#import "VotesManager.h"

@interface RestaurantSearchTests : XCTestCase

@end

@implementation RestaurantSearchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
    User story #1
    As a democratic team member, I want my team to see a list of restaurants close to where we are, so that the team doesn't need to spend time googling/looking for restaurants around the client's office in which they are working from.
    Acceptance criteria
        ● Users can see a list of restaurants geographically located nearby their actual locations.
        ● Users can see if and how many votes the restaurants appearing in the list have had on that day.
 */

- (void)testListRestaurantsNearby {
    //Using constant location because this location has for certain restaurants nearby so it should always result in a valid list of locations.
    NSString *lat = @"37.332331";
    NSString *lng = @"-122.031219";
    
    XCTestExpectation *listLocationsExpectation = [self expectationWithDescription:@"list locations"];
    
    __block NSError *anerror;
    
    [[ListLocationCommand sharedInstance] listLocationsNearbyLatitude:lat
                                                         andLongitude:lng WithBlock:^(NSDictionary *result, NSError *error) {
                                                             anerror = error;
                                                             
                                                             XCTAssertNil(error, @"error should be nil");
                                                             
                                                             NSArray *locations = [[result objectForKey:@"result"] mutableCopy];
                                                             
                                                             if(locations.count > 0){
                                                                 [listLocationsExpectation fulfill];
                                                             }
                                                         }];
    
    
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(anerror, @"error should be nil");
    }];
}

- (void)testListRestaurantsVotes {    
    XCTestExpectation *listVotesExpectation = [self expectationWithDescription:@"list votes"];
    
    __block NSError *anerror;
    
    [[ListVotesCommand sharedInstance] ListVotesWithBlock:^(NSDictionary *result, NSError *error) {
        anerror = error;
        
        NSArray *votes = [[result objectForKey:@"result"] mutableCopy];
            
        XCTAssertNil(error, @"error should be nil");
        XCTAssertNotNil(votes, @"error should be nil");
            
        [listVotesExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(anerror, @"error should be nil");
    }];
}

/*
    User story #2
    As a hungry team member, I want to vote on my favourite restaurant, so that I can democratically convince my colleagues to come have lunch with me at places I like.
    Acceptance criteria
        ● Users can only cast one vote per restaurant per day.
 */

- (void)testVotesPerRestaurantPerDay{
    bool alreadyVotedToday = [VotesManager sharedInstance].hasUserAlreadyVotedToday;
    
    XCTAssertTrue(alreadyVotedToday, @"alreadyVotedToday should be true");
}

/*
    User story #3
    As a voting process facilitator, I want to avoid going to the same restaurant on the same week, so that there are no complaints from other colleagues.
    Acceptance criteria
        ● A restaurant cannot be chosen more than once on the same week.
 */

- (void)testUniqueChosenRestaurantsPerWeek{
    //Place ID of a restaurant that already had lunch this week
    //Each time the user tris to vote, Votes manager check history of choosen restaurants that week.
    //isVoteValidForPlaceID validates if the place id can have a vote.
    NSString *votedPlaceID = @"ChIJy_jI65i1j4ARhkl5AjxRYU8";
    bool canVoteForPlace = [[VotesManager sharedInstance] isVoteValidForPlaceID:votedPlaceID];
    
    XCTAssertFalse(canVoteForPlace, @"alreadyChosenRestaurant should be false");
}

/*
    User story #4
    As a hungry worker, I want to be notified before 1 pm everyday what was the chosen restaurant, so that me and my stomach can prepare ourselves for what's coming.
    Acceptance criteria
        ● Users can see the most voted restaurants on the day before and after the voting process is finished.
        ● Users get notified about the chosen restaurant when the daily deadline is reached.
 */

- (void)testListVotesBeforeAndAfterVoting{
    XCTestExpectation *listVotesExpectation = [self expectationWithDescription:@"list votes"];
    
    __block NSError *anerror;
    
    [[ListVotesCommand sharedInstance] ListVotesWithBlock:^(NSDictionary *result, NSError *error) {
        anerror = error;
        
        NSArray *votes = [[result objectForKey:@"result"] mutableCopy];
        
        XCTAssertNil(error, @"error should be nil");
        XCTAssertNotNil(votes, @"error should be nil");
        
        [listVotesExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(anerror, @"error should be nil");
    }];
}

- (void)testNotifyByTheDeadline{
    bool notificationScheduled = [[NotificationManager sharedInstance] scheduleNotificationWithMessage:@"Hey, Today Restaurant has been choosen, come take a look."];
    
    XCTAssertTrue(notificationScheduled, @"notificationScheduled should be true");
}

/*
    User story #5
    As an old school kinda team member, I want the app and its future updates to work perfectly on my old mobile phone, so that I don't miss out on the new restaurants around our future new client's offices.
    Acceptance criteria
        ● Users can see the location-based list of restaurants even when using older devices and older OSs.
 */

- (void)testForOlderDevices{
    int minOSSupported = __IPHONE_OS_VERSION_MIN_REQUIRED;
    
    XCTAssertEqual(minOSSupported, 80000, @"min iOS version supported should be 8");
}

@end
