//
//  IRepository.h
//  Infrastructure
//
//  Created by Artur Felipe on 03/10/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parameter.h"
@protocol IRepository <NSObject>

@required
- (id)execute:(Parameter*)param error:(NSError**)error;
- (BOOL)isDaoValid;
- (id)fromDAO:(Parameter*)param error:(NSError**)error;
- (id)fromService:(Parameter*)param error:(NSError**)error;

@end
