//
//  MapsViewController.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "MapsViewController.h"
#import "DBManager.h"

@interface MapsViewController () <GMSMapViewDelegate, UIAlertViewDelegate>{
    BOOL _firstLocationUpdate;
    float zoomlevel;
}

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) GMSMarker *locationMarker;
@property (strong, nonatomic) NSMutableArray *markers;

@end

@implementation MapsViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"All Results";
    
    zoomlevel = 12;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:zoomlevel];
    
    [self prefersStatusBarHidden];
    self.mapView.camera = camera;
    self.mapView.delegate = self;
    self.mapView.settings.compassButton = NO;
    self.mapView.settings.myLocationButton = YES;
    
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.myLocationEnabled = YES;
    });
    
    [self createLocationMarks];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.locationMarker = nil;
    self.markers = nil;
    [_mapView removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma mark - Location Pins

- (void) createLocationMarks{
    self.markers = [[NSMutableArray alloc] init];
    
    NSArray *marks = [self.data objectForKey:@"marks"];
    
    for(NSDictionary *aDict in marks){
        GMSMarker *marker = [[GMSMarker alloc] init];
        CLLocationDegrees lat = [[[[aDict objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue];
        CLLocationDegrees lng = [[[[aDict objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue];
        
        marker.position = CLLocationCoordinate2DMake(lat, lng);
        marker.title = [aDict objectForKey:@"name"];
        marker.snippet = [aDict objectForKey:@"vicinity"]; //[NSString stringWithFormat:@"(%f, %f)", lat, lng];
        marker.map = self.mapView;
        marker.infoWindowAnchor = CGPointMake(0.5, -0.25);
        
        [self.markers addObject:marker];
    }
    
    [self fitMarkersToBounds];
}

#pragma mark - Database

- (void)checkDatabase{
    NSArray *marks = [self.data objectForKey:@"marks"];
    
    NSDictionary *aLocation = marks[[[self.data objectForKey:@"selectedIndex"] intValue]];
    
    Boolean isLocationSaved = [[DBManager sharedInstance] isLocationSaved:aLocation];
    
    if(isLocationSaved){//Show Delete Button
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteSelectedLocation:)];
        
        self.navigationItem.rightBarButtonItem = deleteButton;
    }
    else{//Show Save Button
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSelectedLocation:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
}

#pragma mark - UIBarButton Methods

- (void)saveSelectedLocation:(id)sender {
    NSArray *marks = [self.data objectForKey:@"marks"];
    
    NSDictionary *aLocation = marks[[[self.data objectForKey:@"selectedIndex"] intValue]];
    
    [[DBManager sharedInstance] insertLocation:aLocation];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteSelectedLocation:)];
    
    self.navigationItem.rightBarButtonItem = deleteButton;
}

- (void)deleteSelectedLocation:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName
                                                    message:@"The location will be deleted, are you sure ?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    [alert show];
}

#pragma mark - GMSMapView Delegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    return false;
}

- (void)fitMarkersToBounds {
    if([[self.data objectForKey:@"displayAll"] boolValue]){
        GMSCoordinateBounds *bounds;
        for (GMSMarker *marker in self.markers) {
            if (bounds == nil) {
                bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:marker.position
                                                              coordinate:marker.position];
            }
            bounds = [bounds includingCoordinate:marker.position];
        }
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds
                                                 withPadding:50.0f];
        [self.mapView moveCamera:update];
    }
    else{
        GMSMarker *marker = self.markers[[[self.data objectForKey:@"selectedIndex"] intValue]];
        
        GMSCameraUpdate *move = [GMSCameraUpdate setTarget:marker.position zoom:zoomlevel];
        [_mapView animateWithCameraUpdate:move];
        
        [self checkDatabase];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { //The user confirmed the action
        NSArray *marks = [self.data objectForKey:@"marks"];
        
        NSDictionary *aLocation = marks[[[self.data objectForKey:@"selectedIndex"] intValue]];
        
        [[DBManager sharedInstance] deleteLocation:aLocation];
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSelectedLocation:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!_firstLocationUpdate) {
        _firstLocationUpdate = YES;
    }
}

@end
