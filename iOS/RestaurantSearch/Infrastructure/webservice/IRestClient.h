//
//  IRestClient.h
//  Infrastructure
//
//  Created by Artur Felipe on 27/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parameter.h"
@protocol IRestClient <NSObject>

@required
- (id)execute:(Parameter*)param error:(NSError**)error;
- (NSURL*)url:(Parameter*)param;

@end
