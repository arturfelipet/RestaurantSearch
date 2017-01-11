//
//  BaseDAO.h
//  Infrastructure
//
//  Created by Artur Felipe on 09/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IBaseDAO.h"
#import "BaseParser.h"

@interface BaseDAO : NSObject <IBaseDAO>

@property (nonatomic,strong) BaseParser *parser;

- (id<IBaseDAO>)initWithParser:(id<IParser>)parser;

#pragma mark Abstract class simulation
- (NSString*)entityName;

@end
