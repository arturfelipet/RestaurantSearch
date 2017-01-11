//
//  Repository.h
//  Infrastructure
//
//  Created by Artur Felipe on 06/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IRepository.h"

#import "IBaseDAO.h"
#import "IRestClient.h"
#import "IRepositoryStrategy.h"

@interface Repository : NSObject <IRepository>

@property (nonatomic,strong) id<IBaseDAO> dao;
@property (nonatomic,strong) id<IRestClient> restClient;
@property (nonatomic,strong) id<IRepositoryStrategy> strategy;

- (id<IRepository>)initWithDAO:(id<IBaseDAO>)dao restClient:(id<IRestClient>)restClient strategy:(id<IRepositoryStrategy>)strategy;
- (id)execute:(Parameter*)param error:(NSError**)error;

# pragma mark Abstract class simulation
- (BOOL)isDaoValid;
- (id)fromDAO:(Parameter*)param error:(NSError**)error;
- (id)fromService:(Parameter*)param error:(NSError**)error;

@end
