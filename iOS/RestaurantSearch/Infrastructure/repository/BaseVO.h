//
//  BaseVO.h
//  Infrastructure
//
//  Created by Artur Felipe on 09/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBaseVO.h"

@interface BaseVO : NSObject <IBaseVO>

@property (nonatomic,strong) NSDate *lastUpdated;
@property (nonatomic) BOOL offline;

# pragma mark Abstract class simulation
- (id)uid;
- (id)initWith:(id)model;
- (id)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)asDictionary;

@end
