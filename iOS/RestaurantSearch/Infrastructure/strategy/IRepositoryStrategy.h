//
//  IRepositoryStrategy.h
//  Infrastructure
//
//  Created by Artur Felipe on 01/11/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRepository.h"

@protocol IRepositoryStrategy <NSObject>

@required
- (id)execute:(Parameter*)param repository:(id<IRepository>)repository error:(NSError**)error;

@end
