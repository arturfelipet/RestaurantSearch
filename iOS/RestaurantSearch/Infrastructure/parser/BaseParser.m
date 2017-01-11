//
//  BaseParser.m
//  Infrastructure
//
//  Created by Artur Felipe on 08/10/13.
//  Copyright (c) 2013 Artur Felipe. All rights reserved.
//

#import "BaseParser.h"

@implementation BaseParser

- (id)vo:(id)vo to:(id)model {
    mustOverride();
}
- (NSArray*)modelsToVOs:(NSArray*)models {
    mustOverride();
}
- (id)wrap:(id)obj {
    mustOverride();
}
- (id)unwrap:(id)obj {
    mustOverride();
}

@end
