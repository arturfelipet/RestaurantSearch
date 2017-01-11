//
//  IParser.h
//  Infrastructure
//
//  Created by Artur Felipe on 08/10/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IParser <NSObject>

@optional
- (NSArray*)modelsToVOs:(NSArray*)models;
- (id)modelToVO:(id)model;

@required
- (id)vo:(id)vo to:(id)model;
- (id)wrap:(id)obj;
- (id)unwrap:(id)obj;

@end
