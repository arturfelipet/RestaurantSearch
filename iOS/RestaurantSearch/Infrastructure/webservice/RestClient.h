//
//  RestClient.h
//  Infrastructure
//
//  Created by Artur Felipe on 24/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRestClient.h"
#import "RestHandler.h"
#import "BaseParser.h"
#import "ConstantsInfrastructure.h"

@interface RestClient : NSObject <IRestClient>

@property (nonatomic,strong) RestHandler *handler;
@property (nonatomic,strong) BaseParser *parser;

- (id<IRestClient>)initWithRestHandler:(id<IRestHandler>)handler parser:(id<IParser>)parser;
- (id)execute:(Parameter*)param error:(NSError**)error;

//Abstract class simulation
- (NSURL*)url:(Parameter*)param;

@end
