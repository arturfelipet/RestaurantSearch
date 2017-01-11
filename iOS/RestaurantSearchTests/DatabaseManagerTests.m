//
//  DatabaseManagerTests.m
//  RestaurantSearchTests
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DatabaseManager.h"

@interface DatabaseManagerTests : XCTestCase

@end

@implementation DatabaseManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDBInstance
{
    id instance = [DatabaseManager sharedInstance];
    XCTAssertTrue([instance isKindOfClass:[DatabaseManager class]], @"Incorrect shared instance of DatabaseManager.");
}

- (void)testManagedObjectContextError
{
    DatabaseManager *instance = [[DatabaseManager alloc] init];
    
    [instance setDataModelURL:nil];
    [instance setStorePath:nil];
    
    id context = [[DatabaseManager sharedInstance] managedObjectContext];
    
    XCTAssertNil(context, @"ManagedObjectContext should be nil");
}

- (void)testSaveConextError
{
    DatabaseManager *instance = [[DatabaseManager alloc] init];
    
    [instance setDataModelURL:nil];
    [instance setStorePath:nil];
    
    NSError *error;
    BOOL status = [instance saveContext:&error];
    
    XCTAssertFalse(status, @"Status should be FALSE");
}

- (void)testCreateObjectNilEntityName
{
    DatabaseManager *instance = [[DatabaseManager alloc] init];
    NSError *error;
    
    id model = [instance createObject:nil error:&error];
    
    XCTAssertNil(model, @"Model should be nil for nil entityName");
}

- (void)testFetchRequestNilEntityname
{
    DatabaseManager *instance = [[DatabaseManager alloc] init];
    NSError *error;
    
    id result = [instance fetchData:nil predicate:nil offset:0 limit:0 sortBy:nil ascending:YES error:&error];
    
    XCTAssertNil(result, @"Result should be nil for nil entity name");
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
