//
//  ViewFactory.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewFactory.h"

#import "MapsViewController.h"
#import "FirebaseManager.h"

@interface ViewFactory(){
    
}

@property (nonatomic, strong) UIStoryboard *sb;
@property (nonatomic, strong) UIViewController *homeViewController;

@end


@implementation ViewFactory

@synthesize sb;

+ (instancetype)sharedInstance{
    static ViewFactory *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [ViewFactory alloc];
        instance = [instance init];
    });
    
    return instance;
}

- (void)dealloc{
    NSLog(@"%@ dealloced !!!" , NSStringFromClass([self class]));
}

//This method would create the first view controller that at some cases could be a login, a home or others.
- (UIViewController*)createFirstViewController{
    if([[FirebaseManager sharedInstance] isUserLoggedIn]){
        return [self createSearchViewController];
    }
    else{
        return [self createSignInViewController];
    }
}

- (UIViewController*)createHistoryViewController{
    sb = [UIStoryboard storyboardWithName:kSTORYBOARD_MAIN bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    return vc;
}

- (UIViewController*)createMapsViewControllerWithData:(NSDictionary *) data{
    sb = [UIStoryboard storyboardWithName:kSTORYBOARD_MAIN bundle:nil];
    MapsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MapsViewController"];
    [vc setData:data];
    
    return vc;
}

- (UIViewController*)createSearchViewController{
    sb = [UIStoryboard storyboardWithName:kSTORYBOARD_MAIN bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SearchViewController"];
    return vc;
}

- (UIViewController*)createSignInViewController{
    sb = [UIStoryboard storyboardWithName:kSTORYBOARD_MAIN bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SignInViewController"];
    return vc;
}

- (UIViewController*)createVotesViewController{
    sb = [UIStoryboard storyboardWithName:kSTORYBOARD_MAIN bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"VotesViewController"];
    return vc;
}

@end
