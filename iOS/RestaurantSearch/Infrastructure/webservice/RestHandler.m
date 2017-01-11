//
//  RestHandler.m
//  Infrastructure
//
//  Created by Artur Felipe on 27/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import "RestHandler.h"

@implementation RestHandler

/*
 * Abstract Methods
 */
- (id)success:(id)data param:(Parameter*)param error:(NSError**)error {
   
    mustOverride();
}

- (id)fail:(NSError**)error {
    mustOverride();
}

- (id)report:(NSError**)error{
    NSLog(@"Report Called");
    return nil;
}

@end
