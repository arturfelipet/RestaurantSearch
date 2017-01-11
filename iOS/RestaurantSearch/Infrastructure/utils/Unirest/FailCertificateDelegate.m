//
//  FailCertificateDelegate.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 8/1/14.
//  Copyright (c) 2014 Artur Felipe. All rights reserved.
//

#import "FailCertificateDelegate.h"

@implementation FailCertificateDelegate

@synthesize dataDownloaded,downloaded;

-(id)init{
    self = [super init];
    if (self){
        dataDownloaded=nil;
        downloaded=[[NSCondition alloc] init];
    }
    return self;
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:    (NSURLProtectionSpace *)protectionSpace {
    NSLog(@"canAuthenticateAgainstProtectionSpace:");
    return [protectionSpace.authenticationMethod         isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:    (NSURLAuthenticationChallenge *)challenge {
    NSLog(@"didReceiveAuthenticationChallenge:");
    [challenge.sender useCredential:[NSURLCredential     credentialForTrust:challenge.protectionSpace.serverTrust]     forAuthenticationChallenge:challenge];
}

-(NSData *)getData{
    return dataDownloaded;
}

@end
