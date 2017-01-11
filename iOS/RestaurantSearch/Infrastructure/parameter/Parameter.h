//
//  Parameter.h
//  Infrastructure
//
//  Created by Artur Felipe on 04/11/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantsInfrastructure.h"

typedef enum {
    ServiceTypeGet = 1,
    ServiceTypePost,
    ServiceTypeDelete,
    ServiceTypePut
} ServiceType;

@interface Parameter : NSObject

@property (nonatomic,strong) NSNumber* limit;
@property (nonatomic,strong) NSNumber* offset;
@property (nonatomic,strong) NSString* sessionId;

@property (nonatomic,strong) NSString* uid;

@property (nonatomic,strong) NSDictionary *header;
@property (nonatomic,strong) NSDictionary *parameters;
@property (nonatomic) ServiceType serviceType;
@property (nonatomic,strong) NSURL *url;

//ERROR
@property (nonatomic,strong) NSString *errorDescription;

- (id)initWithLimit:(NSNumber*)limit offset:(NSNumber*)offset;
- (id)initWithUid:(NSString*)uid;
- (id)initWithSessionId:(NSString*)sessionId andLimit:(NSNumber*) limit;

@end
