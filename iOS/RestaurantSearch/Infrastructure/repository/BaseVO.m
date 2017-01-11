//
//  BaseVO.m
//  Infrastructure
//
//  Created by Artur Felipe on 09/09/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import "BaseVO.h"

@implementation BaseVO

- (id)uid {
    mustOverride();
}
- (id)initWith:(id)model {
    mustOverride();
}
- (id)initWithDictionary:(NSDictionary*)dict {
    mustOverride();
}
- (NSDictionary*)asDictionary {
    mustOverride();
}

@end
