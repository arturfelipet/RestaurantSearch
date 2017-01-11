//
//  Parameter.m
//  Infrastructure
//
//  Created by Artur Felipe on 04/11/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import "Parameter.h"

@implementation Parameter

- (id)initWithLimit:(NSNumber*)limit offset:(NSNumber*)offset
{
    if (!limit || !offset)
        return nil;
    
    self = [self init];
    if (self)
    {
        self.limit = limit;
        self.offset = offset;
    }
    return self;
}

- (id)initWithUid:(NSString*)uid
{
    if (!uid)
        return nil;
    
    self = [self init];
    if (self)
    {
        self.uid = uid;
    }
    return self;
}

- (id)initWithSessionId:(NSString*)sessionId andLimit:(NSNumber*) limit {
    if (!sessionId)
        return nil;
    
    self = [self init];
    if (self)
    {
        self.sessionId = sessionId;
        self.limit = limit;
    }
    return self;
}

@end
