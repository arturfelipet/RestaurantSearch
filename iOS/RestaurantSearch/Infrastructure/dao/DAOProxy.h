//
//  DAOProxy.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 2/22/13.
//
//

#import <Foundation/Foundation.h>

@interface DAOProxy : NSProxy
{
    id target;
}

- (id)init:(id)target;

@end
