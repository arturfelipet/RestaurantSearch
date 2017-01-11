//
//  RepositoryStrategy.h
//  Infrastructure
//
//  Created by Artur Felipe on 01/11/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IRepositoryStrategy.h"
#import "IRepository.h"

@class DefaultRepositoryStrategy, LocalRepositoryStrategy, RemoteRepositoryStrategy;

@interface RepositoryStrategy : NSObject <IRepositoryStrategy>

+ (DefaultRepositoryStrategy*)defaultRepositoryStrategy;
+ (LocalRepositoryStrategy*)localRepositoryStrategy;
+ (RemoteRepositoryStrategy*)remoteRepositoryStrategy;

@end



@interface DefaultRepositoryStrategy : RepositoryStrategy <IRepositoryStrategy>

- (id)execute:(Parameter*)param repository:(id<IRepository>)repository error:(NSError**)error;

@end



@interface LocalRepositoryStrategy : RepositoryStrategy <IRepositoryStrategy>

- (id)execute:(Parameter*)param repository:(id<IRepository>)repository error:(NSError**)error;

@end



@interface RemoteRepositoryStrategy : RepositoryStrategy <IRepositoryStrategy>

- (id)execute:(Parameter*)param repository:(id<IRepository>)repository error:(NSError**)error;

@end
