/*
 The MIT License
 
 Copyright (c) 2013 Mashape (http://mashape.com)
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "HttpJsonResponse.h"

@implementation HttpJsonResponse

@synthesize body = _body;

- (NSDictionary *)nestedDictionaryByReplacingNullsWithNil:(NSDictionary*)sourceDictionary
{
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:sourceDictionary];
    const id nul = [NSNull null];
    [sourceDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        object = [sourceDictionary objectForKey:key];
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *innerDict = object;
            [replaced setObject:[self nestedDictionaryByReplacingNullsWithNil:innerDict] forKey:key];
            
        }
        else if([object isKindOfClass:[NSArray class]]){
            NSMutableArray *nullFreeRecords = [NSMutableArray array];
            NSMutableArray *internalArray = [NSMutableArray array];
            for (id record in object) {
                
                if([record isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *nullFreeRecord = [self nestedDictionaryByReplacingNullsWithNil:record];
                    [nullFreeRecords addObject:nullFreeRecord];
                } else {
                    [internalArray addObject:record];
                }
            }
            if ([internalArray count] > 0) {
                [nullFreeRecords addObject:internalArray];
            }
            [replaced setObject:nullFreeRecords forKey:key];
        }
        else
        {
            if(object == nul) {
                [replaced removeObjectForKey:key];
            }
        }
    }];
    
    return [NSDictionary dictionaryWithDictionary:replaced];
}

- (NSArray*)arrayOfDictionariesByReplacingNullsWithNil:(NSArray*)sourceArray
{
    NSMutableArray *resultArray = [NSMutableArray new];
    
    for (NSDictionary *d in sourceArray)
        [resultArray addObject:[self nestedDictionaryByReplacingNullsWithNil:d]];
    
    return [NSArray arrayWithArray:resultArray];
}

-(HttpJsonResponse*) initWithSimpleResponse:(HttpResponse*) httpResponse {
    self = [super init];
    [self setCode:[httpResponse code]];
    [self setHeaders:[httpResponse headers]];
    [self setRawBody:[httpResponse rawBody]];
    
    JsonNode* body = [[JsonNode alloc] init];
    
    NSError * error = nil;
    
    id json;
    if ([httpResponse rawBody]){
        json = [NSJSONSerialization JSONObjectWithData:[httpResponse rawBody] options:NSJSONReadingMutableLeaves error:&error];
        
//        NSString* dataUTF8Str = [[NSString alloc] initWithData:[httpResponse rawBody] encoding:NSUTF8StringEncoding];
//        
//        if ([dataUTF8Str rangeOfString:@"\\u"].location == NSNotFound){
//            json = [NSJSONSerialization JSONObjectWithData:[httpResponse rawBody] options:NSJSONReadingMutableLeaves error:&error];
//        }
//        else{
//            NSString* dataStr = [[NSString alloc] initWithData:[httpResponse rawBody] encoding:NSNonLossyASCIIStringEncoding];
//            
////            NSString *dataUTF8Str = [dataStr stringByReplacingPercentEscapesUsingEncoding:NSNonLossyASCIIStringEncoding];
//            
//            NSData *dataUTF8 = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//        
//            json = [NSJSONSerialization JSONObjectWithData:dataUTF8 options:NSJSONReadingMutableLeaves error:&error];
//        }
    }
    else
        NSLog(@"Erro no JSON parser: rawBody NULO.");
    
    if ([json isKindOfClass:[NSDictionary class]])
        json = [self nestedDictionaryByReplacingNullsWithNil:json];
    else if ([json isKindOfClass:[NSArray class]])
        json = [self arrayOfDictionariesByReplacingNullsWithNil:json];
    
    if ([json isKindOfClass:[NSArray class]]) {
        [body setArray:json];
    } else {
        [body setObject:json];
    }
    
    [self setBody:body];
    return self;
}

@end
