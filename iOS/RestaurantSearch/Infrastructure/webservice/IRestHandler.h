//
//  IRestHandler.h
//  Infrastructure
//
//  Created by Artur Felipe on 20/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Parameter;

@protocol IRestHandler <NSObject>

- (id)success:(id)data param:(Parameter*)param error:(NSError**)error;
- (id)fail:(NSError**)error;

@end
