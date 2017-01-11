//
//  Repository.m
//  Infrastructure
//
//  Created by Artur Felipe on 06/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import "Repository.h"
#import "RepositoryStrategy.h"

@implementation Repository

- (id<IRepository>)initWithDAO:(id<IBaseDAO>)dao restClient:(id<IRestClient>)restClient strategy:(id<IRepositoryStrategy>)strategy
{
    if ([strategy isKindOfClass:[DefaultRepositoryStrategy class]] && (!dao || !restClient))
        return nil;
    
    if ([strategy isKindOfClass:[LocalRepositoryStrategy class]] && !dao)
        return nil;
    
    if ([strategy isKindOfClass:[RemoteRepositoryStrategy class]] && !restClient)
        return nil;
    
    self = [self init];
    if (self)
    {
        self.dao = dao;
        self.restClient = restClient;
        self.strategy = strategy;
    }
    return self;
}

- (id)execute:(Parameter*)param error:(NSError**)error
{
    if (!self.strategy)
        self.strategy = [RepositoryStrategy defaultRepositoryStrategy];
    
    return [self.strategy execute:param repository:self error:error];
}

/*
 * Abstract methods  
 */
- (BOOL)isDaoValid {
    mustOverride();
}
- (id)fromDAO:(Parameter*)param error:(NSError**)error {
    mustOverride();
}
- (id)fromService:(Parameter*)param error:(NSError**)error {
    mustOverride();
}

@end
