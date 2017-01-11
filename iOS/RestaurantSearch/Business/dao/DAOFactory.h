//
//  DAOFactory.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 09/09/13.
//  Copyright (c) 2014 Artur Felipe. All rights reserved.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManager.h"

@interface DAOFactory : NSObject

+ (void)configDatabaseManager;
+ (void)configDatabaseManagerForInstance:(DatabaseManager *) instance;

@end
