//
//  IBaseDAO.h
//  Infrastructure
//
//  Created by Artur Felipe on 03/10/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBaseVO.h"

@class BaseVO;

@protocol IBaseDAO <NSObject>

@required
- (BOOL)save:(BaseVO*)obj error:(NSError**)error;
- (void)remove:(BaseVO*)obj error:(NSError**)error;
- (id)findByID:(NSString*)idObj error:(NSError**)error;
- (NSArray*)list:(int)offSet size:(int)size error:(NSError**)error;
- (id)getModel:(id)idObj error:(NSError**)error;
- (id)getLast:(NSString*)sortBy error:(NSError**)error;

@end
