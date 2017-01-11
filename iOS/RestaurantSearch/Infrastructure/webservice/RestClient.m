//
//  RestClient.m
//  Infrastructure
//
//  Created by Artur Felipe on 24/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import "RestClient.h"
#import "Unirest.h"

@implementation RestClient

- (id<IRestClient>)initWithRestHandler:(id<IRestHandler>)handler parser:(id<IParser>)parser
{
    if (!handler || !parser)
        return nil;
    
    self = [self init];
    if (self)
    {
        self.handler = handler;
        self.parser = parser;
    }
    return self;
}

- (id)execute:(Parameter*)param error:(NSError**)error
{
    NSDictionary* headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"accept", nil];

//    NSLog(@"URL EXECUTE: ,%@",[[self url:param] absoluteString]);
    
    NSDictionary* parameters = nil;
    if(param.parameters){
        parameters = param.parameters;
    }
    
    HttpJsonResponse *response = nil;
    
    if(!param.serviceType){
        response = [[Unirest get:^(SimpleRequest *request)
                     {
                         [request setUrl:[[self url:param] absoluteString]];
                         [request setHeaders:headers];
                     }] asJson];
    }
    else{
        if (param.serviceType == ServiceTypePost){
            NSLog(@"POST");
            
            response = [[Unirest post:^(MultipartRequest *request)
                         {
                             [request setUrl:[[self url:param] absoluteString]];
                             [request setHeaders:headers];
                             [request setParameters:parameters];
                         }] asJson];
        }
        else if (param.serviceType == ServiceTypePut){
            NSLog(@"PUT");
            
            response = [[Unirest put:^(SimpleRequest *request)
                         {
                             [request setUrl:[[self url:param] absoluteString]];
                             [request setHeaders:headers];
                             [request setParameters:parameters];
                         }] asJson];
        }
        else if (param.serviceType == ServiceTypeDelete){
            NSLog(@"DELETE");
            
            response = [[Unirest delete:^(SimpleRequest *request)
                         {
                             [request setUrl:[[self url:param] absoluteString]];
                             [request setHeaders:headers];
                         }] asJson];
        }
        else{ // GET
            NSLog(@"GET");
            
            response = [[Unirest get:^(SimpleRequest *request)
                         {
                             NSString *url = nil;
                             if(parameters){
                                 NSArray*keys=[parameters allKeys];
                                 
                                 NSMutableString *temp = [[NSMutableString alloc] init];
                                 for (NSString *key in keys) {
                                     if(temp.length == 0)
                                     {
                                         [temp appendString:[NSString stringWithFormat:@"%@=%@",key, [parameters valueForKey:key]]];
                                     }
                                     else{
                                         [temp appendString:[NSString stringWithFormat:@"&%@=%@",key, [parameters valueForKey:key]]];
                                     }
                                 }
                                 
                                 url = [[[self url:param] absoluteString] stringByAppendingString:[NSString stringWithFormat:@"?%@", temp]];
                             }
                             else{
                                 url = [[self url:param] absoluteString];
                             }
                             [request setUrl:url];
                             [request setHeaders:headers];
                         }] asJson];
        }
    }
    
    
    if ([response code] == 200)
    {
        JsonNode *body = [response body];
        id obj = ([body array] != nil) ? [body array] : [body object];
        
        id wrapped = [self.parser wrap:obj];
        
        return [self.handler success:wrapped param:param error:error];
    }
    else if ([response code] == 503){
        NSString *errorMessage = @"HTTP Response 503: timeout.";
        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:[response code] userInfo:@{@"description": errorMessage}];
        return [self.handler fail:&error];
    }
    else
    {
        id obj = [[response body] object] ? [[response body] object] : [[response body] array] ? [[response body] array] : [NSNull null];
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:[response code] userInfo:@{@"body": obj}];
        return [self.handler fail:error];
    }
}

- (NSURL*)url:(Parameter*)param {
    mustOverride();
}

@end
