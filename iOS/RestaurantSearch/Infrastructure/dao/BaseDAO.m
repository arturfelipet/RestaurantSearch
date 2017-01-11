//
//  BaseDAO.m
//  Infrastructure
//
//  Created by Artur Felipe on 09/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import "BaseDAO.h"
#import "DatabaseManager.h"
#import "BaseVO.h"

@implementation BaseDAO

- (id<IBaseDAO>)initWithParser:(id<IParser>)parser
{
    if (!parser)
        return nil;
    
    self = [self init];
    if (self)
    {
        self.parser = parser;
    }
    return self;
}

- (BOOL)save:(BaseVO*)obj error:(NSError **)error
{
    NSError *findError = nil;
    id modelObj = [self getModel:[obj uid] error:&findError];

    //If do not exist, create.
    if (!modelObj)
        modelObj = [[DatabaseManager sharedInstance] createObject:[self entityName] error:error];
    
    if (*error != nil)
        return NO;
    
    //timestamp update
    obj.lastUpdated = [NSDate date];
    
    modelObj = [self.parser vo:obj to:modelObj];
    
    return [[DatabaseManager sharedInstance] saveContext:error];
}

- (void)remove:(BaseVO*)obj error:(NSError **)error
{
    id modelObj = [self getModel:[obj uid] error:error];
    
    if (modelObj)
        [[DatabaseManager sharedInstance] deleteObject:modelObj error:error];
    else
        NSLog(@"Erro: remove object inexistent.");
}

- (id)findByID:(id)idObj error:(NSError**)error
{
    NSString *strID = ([idObj class] == [NSNumber class]) ? [idObj stringValue] : idObj;
    
    NSArray *objects = [[DatabaseManager sharedInstance] fetchData:self.entityName predicate:[NSPredicate predicateWithFormat:@"uid == %@", strID] offset:0 limit:0 sortBy:@"uid" ascending:YES error:error];
    if (objects != nil)
    {
        if (objects.count > 0)
        {
            NSArray *parsed = [self.parser modelsToVOs:objects];
            return [parsed objectAtIndex:0];
        }
        else
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_BASEDAO_NO_RESULTS userInfo:@{@"description": @"No objects fetched."}];
    }
    
    return nil;
}

- (NSArray*)list:(int)offSet size:(int)size error:(NSError**)error
{
    NSArray *models = [[DatabaseManager sharedInstance] fetchData:[self entityName] predicate:nil offset:offSet limit:size sortBy:nil ascending:YES error:error];
    if (models != nil)
        return [self.parser modelsToVOs:models];
    
    return nil;
}

- (id)getModel:(id)idObj error:(NSError**)error
{
    NSString *strID = ([idObj class] == [NSNumber class]) ? [idObj stringValue] : idObj;
    
    NSArray *objects = [[DatabaseManager sharedInstance] fetchData:self.entityName predicate:[NSPredicate predicateWithFormat:@"uid == %@", strID] offset:0 limit:0 sortBy:@"uid" ascending:YES error:error];
    
    if (objects != nil)
    {
        if (objects.count > 0)
            return [objects objectAtIndex:0];
        else
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_BASEDAO_NO_RESULTS userInfo:@{@"description": @"No model fetched."}];
    }
    
    return nil;
}

- (id)getLast:(NSString*)sortBy error:(NSError**)error
{
    NSArray *models = [[DatabaseManager sharedInstance] fetchData:[self entityName] predicate:nil offset:0 limit:1 sortBy:sortBy ascending:YES error:error];
    if (models != nil)
        return [models lastObject];
    
    return nil;
}

#pragma mark Abstract class simulation
- (NSString*)entityName {
    mustOverride();
}

@end
