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

#import "HttpClientHelper.h"
#import "FailCertificateDelegate.h"

@interface HttpClientHelper()
+ (NSString*) encodeURI:(NSString*)value;
+ (NSString*)parameterToQuerystring:(id)parameters;
+ (BOOL) hasBinaryParameters:(NSDictionary*) parameters;
@end

@implementation HttpClientHelper

+ (BOOL) hasBinaryParameters:(id)parameters
{
    if ([parameters isKindOfClass:[NSDictionary class]])
    {
        for(id key in parameters) {
            id value = [parameters objectForKey:key];
            if ([value isKindOfClass:[NSURL class]]) {
                return true;
            }
        }
    }
    else if ([parameters isKindOfClass:[NSArray class]])
    {
        for (id value in parameters)
            if ([value isKindOfClass:[NSURL class]])
                return true;
    }
    
    return false;
}

+ (NSString*) encodeURI:(NSString*)value {
	NSString* result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                             NULL,
                                                                                             (CFStringRef)value,
                                                                                             NULL,
                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                             kCFStringEncodingUTF8));
	return result;
}

//EDITED TO CONVERT TO JSON
+ (NSString*)parameterToQuerystring:(id)parameters
{
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString *result = [[NSString alloc] initWithData:JSONData encoding:NSASCIIStringEncoding];
    
    //NSLog(@"Json: %@", result);
    
    return result;
}

+(HttpResponse*) request:(HttpRequest*) request {
    
    NSMutableDictionary* headers = [[request headers] mutableCopy];
    
    [headers setValue:@"unirest-objc/1.0" forKey:@"user-agent"];
    
    // Add cookies to the headers
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    [headers setValuesForKeysWithDictionary:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:[request url]]]]];
    
    //NSLog(@"-----> %@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:[request url]]]);
    
    NSString *requestURL = [[request url] stringByAppendingString:@"?platform=IOS_SMARTPHONE"];
    
//    if(request.httpMethod == POST)
//        requestURL = [[[request url] stringByAppendingString:@"?platform=IOS_SMARTPHONE"] stringByRemovingPercentEncoding];
    
    int times = (int)[[requestURL componentsSeparatedByString:@"?"] count]-1;
    if(times > 1){
        NSRange lastComma = [requestURL rangeOfString:@"?" options:NSBackwardsSearch];
        
        if(lastComma.location != NSNotFound) {
            requestURL = [requestURL stringByReplacingCharactersInRange:lastComma
                                               withString: @"&"];
        }
    }
    

	NSLog(@"URL EXECUTE: ,%@",requestURL);

    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [requestObj setTimeoutInterval:DEFAULT_REST_TIMEOUT];
    [requestObj setHTTPShouldHandleCookies:YES];
	
    HttpMethod httpMethod = [request httpMethod];

    switch ([request httpMethod]) {
        case GET:
            [requestObj setHTTPMethod:@"GET"];
            break;
        case POST:
            [requestObj setHTTPMethod:@"POST"];
            break;
        case PUT:
            [requestObj setHTTPMethod:@"PUT"];
            break;
        case DELETE:
            [requestObj setHTTPMethod:@"DELETE"];
            break;
        case PATCH:
            [requestObj setHTTPMethod:@"PATCH"];
            break;
    }
    
    NSMutableData* body = [[NSMutableData alloc] init];
    
    // Add body
    if (httpMethod != GET) {
        HttpRequestWithBody* requestWithBody = (HttpRequestWithBody*) request;
        
        if ([requestWithBody isKindOfClass:[HttpRequestWithBody class]])
        {
            if ([requestWithBody body] == nil) {
                // Has parameters
                NSDictionary* parameters = [requestWithBody parameters];
                bool isBinary = [HttpClientHelper hasBinaryParameters:parameters];
                if (isBinary) {
                    
                    [headers setObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY] forKey:@"content-type"];
                    
                    for(id key in parameters) {
                        id value = [parameters objectForKey:key];
                        if ([value isKindOfClass:[NSURL class]] && value != nil) { // Don't encode files and null values
                            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
                            NSString* filename = [[value absoluteString] lastPathComponent];
                            
                            NSData* data = [NSData dataWithContentsOfURL:value];
                            
                            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, filename] dataUsingEncoding:NSUTF8StringEncoding]];
                            [body appendData:[[NSString stringWithFormat:@"Content-Length: %lu\r\n\r\n", (unsigned long)data.length] dataUsingEncoding:NSUTF8StringEncoding]];
                            [body appendData:data];
                        } else {
                            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
                            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                            [body appendData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:NSUTF8StringEncoding]];
                        }
                    }
                    
                    // Close
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
                    
//                    NSString* newStr = [NSString stringWithUTF8String:[body bytes]];
//                    NSLog(@"%@", newStr);
                } else {
                    NSString* querystring = [HttpClientHelper parameterToQuerystring:parameters];
                    body = [NSMutableData dataWithData:[querystring dataUsingEncoding:NSUTF8StringEncoding]];
                }
            } else {
                // Has a body
                body = [NSMutableData dataWithData:[requestWithBody body]];
            }
        }
        
        [requestObj setHTTPBody:body];
    }
    
    // Add headers
    for (NSString *key in headers) {
        NSString *value = [headers objectForKey:key];
        [requestObj addValue:value forHTTPHeaderField:key];
    }
    
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:requestObj returningResponse:&response error:&error];
    
    NSLog(@"debug retorno JSON: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
//    FailCertificateDelegate *fcd=[[FailCertificateDelegate alloc] init];
//    NSURLConnection *c=[[NSURLConnection alloc] initWithRequest:requestObj delegate:fcd startImmediately:NO];
//    [c setDelegateQueue:[[NSOperationQueue alloc] init]];
//    [c start];
//    
//    data = [fcd getData];
    
    HttpResponse* res = [[HttpResponse alloc] init];
    [res setCode:(int)[response statusCode]];
    [res setHeaders:[response allHeaderFields]];
    
    //    //PERSISTIR COOKIES       //obs: nao sera mais necessario
    //    NSArray *cookies =[[NSArray alloc] init];
    //    cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[response URL]];
    //    for (NSHTTPCookie *httpCookie in cookies)
    //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:httpCookie];
    
    //    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    //    [cookieProperties setObject:@"HSS_UID_H" forKey:NSHTTPCookieName];
    //    [cookieProperties setObject:@"HUID=485#HHash=0d0d7dd9-c903-4fa3-acbd-cb59e0f651b4" forKey:NSHTTPCookieValue];
    //    [cookieProperties setObject:@"pvwlservices1hom..popvono" forKey:NSHTTPCookieDomain];
    //    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    //    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    //    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    [res setRawBody:data];
    
    return res;
}

@end
