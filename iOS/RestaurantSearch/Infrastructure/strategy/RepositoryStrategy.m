//
//  RepositoryStrategy.m
//  Infrastructure
//
//  Created by Artur Felipe on 01/11/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import "RepositoryStrategy.h"
#import "Reachability.h"

/* Abstract  RepositoryStrategy */

@implementation RepositoryStrategy

+ (DefaultRepositoryStrategy*)defaultRepositoryStrategy
{
    return [[DefaultRepositoryStrategy alloc] init];
}

+ (LocalRepositoryStrategy*)localRepositoryStrategy
{
    return [[LocalRepositoryStrategy alloc] init];
}

+ (RemoteRepositoryStrategy*)remoteRepositoryStrategy
{
    return [[RemoteRepositoryStrategy alloc] init];
}

- (id)execute:(Parameter*)param repository:(id<IRepository>)repository error:(NSError**)error
{
    mustOverride();
}

@end

/* DefaultRepositoryStrategy */

@implementation DefaultRepositoryStrategy

- (id)execute:(Parameter*)param repository:(id<IRepository>)repository error:(NSError**)error
{
    if ([repository isDaoValid])
        return [repository fromDAO:param error:error];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        NSLog(@"#### Repository execute dao result");
        return [repository fromDAO:param error:error];
    }
    else
    {
        NSLog(@"#### Repository execute rest result");
        
        id response = [repository fromService:param error:error];
        if (*error == nil)
            return response;
        else
            return [repository fromDAO:param error:error];
    }
}

@end

/* LocalRepositoryStrategy */

@implementation LocalRepositoryStrategy

- (id)execute:(Parameter*)param repository:(id<IRepository>)repository error:(NSError**)error
{
    if ([repository isDaoValid])
        return [repository fromDAO:param error:error];
    else
        return nil;
}

@end

/* RemoteRepositoryStrategy */

@implementation RemoteRepositoryStrategy

- (id)execute:(Parameter*)param repository:(id<IRepository>)repository error:(NSError**)error
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:@{@"description": @"No connection"}];
    }
    else
    {
        NSLog(@"#### Repository execute rest result");
        
        id response = [repository fromService:param error:error];
        if (*error == nil)
            return response;
    }
    
    return nil;
}

@end
