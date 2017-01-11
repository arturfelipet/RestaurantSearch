//
//  ViewFactory.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewFactory : NSObject

+ (instancetype)sharedInstance;

- (UIViewController*)createFirstViewController;

- (UIViewController*)createHistoryViewController;
- (UIViewController*)createMapsViewControllerWithData:(NSDictionary *) data;
- (UIViewController*)createSearchViewController;
- (UIViewController*)createSignInViewController;
- (UIViewController*)createVotesViewController;

@end
