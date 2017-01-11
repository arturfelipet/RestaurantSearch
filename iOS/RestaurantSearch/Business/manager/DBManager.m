//
//  DBManager.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "DBManager.h"
#import "ListLocationCommand.h"
#import "InsertLocationCommand.h"
#import "DeleteLocationCommand.h"
#import "LocationVO.h"

@interface DBManager () {
    
}

@property (strong, nonatomic) NSMutableArray *locations;

@end



@implementation DBManager

+(void)load
{
    [super load];
    
    [[DBManager sharedInstance] listLocations];
}

- (void)dealloc {
    self.locations = nil;
}

+ (instancetype)sharedInstance
{
    static DBManager *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [DBManager alloc];
        instance = [instance init];
    });
    
    return instance;
}

- (void)listLocations{
    [ListLocationCommand listLocationsWithBlock:^(NSDictionary *result, NSError *error) {
        if(result){
            self.locations = [[result objectForKey:@"result"] mutableCopy];
        }
    }];
}

- (void)insertLocation:(NSDictionary *) aLocation{
    
    NSNumber *lat = [NSNumber numberWithDouble:[[[[aLocation objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue]];
    
    NSNumber *lng = [NSNumber numberWithDouble:[[[[aLocation objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue]];
    
    [InsertLocationCommand createLocationWithTitle:[aLocation objectForKey:@"formatted_address"]
                                      withLatitude:lat
                                     withLongitude:lng
                                         withBlock:^(NSDictionary *result, NSError *error) {
                                             
                                             [[DBManager sharedInstance] listLocations];
    }];
}

- (void)deleteLocation:(NSDictionary *) aLocation{
    LocationVO *aLocationToDelete = nil;
    
    for(LocationVO *aLocationVO in self.locations){
        if([aLocationVO.formatted_address isEqualToString:[aLocation objectForKey:@"formatted_address"]]){
            aLocationToDelete = aLocationVO;
        }
    }
    
    [DeleteLocationCommand deleteLocation:aLocationToDelete
                                WithBlock:^(NSDictionary *result, NSError *error) {
                                    
                                    [[DBManager sharedInstance] listLocations];
    }];
}

- (Boolean)isLocationSaved:(NSDictionary *) aLocation{
    if(self.locations.count == 0){
        return false;
    }
    else{
        for(LocationVO *aLocationVO in self.locations){
            if([aLocationVO.formatted_address isEqualToString:[aLocation objectForKey:@"formatted_address"]]){
                return true;
            }
        }
        
        return false;
    }
}

@end
