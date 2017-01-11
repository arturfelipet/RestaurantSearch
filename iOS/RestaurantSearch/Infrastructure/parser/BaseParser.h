//
//  BaseParser.h
//  Infrastructure
//
//  Created by Artur Felipe on 08/10/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IParser.h"

@interface BaseParser : NSObject <IParser>

- (id)vo:(id)vo to:(id)model;
- (NSArray*)modelsToVOs:(NSArray*)models;

- (id)wrap:(id)obj;
- (id)unwrap:(id)obj;

@end
