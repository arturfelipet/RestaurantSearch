//
//  DAOProxy.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 2/22/13.
//
//

#import "DAOProxy.h"
#import "DatabaseManager.h"

@implementation DAOProxy

- (id)init:(id)_target
{
    if (self) {
        target = _target;
    }
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    @synchronized([DatabaseManager sharedInstance])
    {
        [invocation invokeWithTarget:target];
    }
}

@end
