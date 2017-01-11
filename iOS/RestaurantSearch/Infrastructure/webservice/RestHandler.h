//
//  RestHandler.h
//  Infrastructure
//
//  Created by Artur Felipe on 27/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRestHandler.h"

@class Parameter;

@interface RestHandler : NSObject <IRestHandler>

//Abstract class simulation
- (id)success:(id)data param:(Parameter*)param error:(NSError**)error;
- (id)fail:(NSError**)error;
- (id)report:(NSError**)error;

@end
