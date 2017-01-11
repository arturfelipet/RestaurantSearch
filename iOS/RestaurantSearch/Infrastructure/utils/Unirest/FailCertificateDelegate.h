//
//  FailCertificateDelegate.h
//  RestaurantSearch
//
//  Created by Artur Felipe on 8/1/14.
//  Copyright (c) 2014 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FailCertificateDelegate : NSObject <NSURLConnectionDataDelegate>

@property(atomic,retain)NSCondition *downloaded;
@property(nonatomic,retain)NSData *dataDownloaded;

-(NSData *)getData;

@end
