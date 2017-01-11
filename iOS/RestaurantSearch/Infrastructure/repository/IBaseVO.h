//
//  IBaseVO.h
//  Infrastructure
//
//  Created by Artur Felipe on 12/11/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IBaseVO <NSObject>

- (id)uid;
- (id)initWith:(id)model;
- (id)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)asDictionary;

@end
