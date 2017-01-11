//
//  SearchViewController.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SearchViewController.h"
#import "NotificationManager.h"
#import "TimerManager.h"
#import "VotesManager.h"
#import "ListHistoryCommand.h"
#import "ListLocationCommand.h"
#import "ListUsersCommand.h"
#import "InsertVoteCommand.h"


@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    Boolean showDisplayAll;
}

@property NSMutableArray *objects;

@property (strong, nonatomic) NSIndexPath * selectedIndexPath;

@property (weak, nonatomic) IBOutlet UITableView *tableViewSearchResult;
@property (weak, nonatomic) IBOutlet UILabel *labelNoResult;

@end

@implementation SearchViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableViewSearchResult setDelegate:self];
    [self.tableViewSearchResult setDataSource:self];
    self.tableViewSearchResult.contentInset = UIEdgeInsetsMake(44,0,0,0);
    
    [self.tableViewSearchResult setHidden:YES];
    [self.labelNoResult setHidden:YES];
    
    [self prefersStatusBarHidden];        
    
    self.title = @"Restaurants Nearby";
    
    [self configNavigationBarButtons];
    [self setUpNotifications];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [[VotesManager sharedInstance] refreshVotes];
    
    [self observeUserLocation];
    
    [self lookForPlacesNearby];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

#pragma mark - UIBarButtons Actions

-(void)signOut{
    [[ListUsersCommand sharedInstance] signOutWithBlock:^(NSDictionary *result, NSError *error) {
        UIViewController *controller = [[ViewFactory sharedInstance] createFirstViewController];
        
        [self.navigationController setViewControllers:@[controller] animated:YES];
    }];
}

-(void)showVotes{
    UIViewController *controller = [[ViewFactory sharedInstance] createVotesViewController];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Notifications Setup

-(void)setUpNotifications{
    [[NotificationManager sharedInstance] scheduleNotificationWithMessage:@"Hey, Today Restaurant has been choosen, come take a look."];
}

#pragma mark - Navigation Bar Setup

-(void)configNavigationBarButtons{
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(signOut)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    
    UIBarButtonItem *votesBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Votes" style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(showVotes)];
    self.navigationItem.rightBarButtonItem = votesBarButton;
}

#pragma mark - Search Methods

- (void)observeUserLocation {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(locationUpdated:)
     name:[CoreLocationManager notificationObserverString]
     object:nil];
}

- (void)locationUpdated:(NSNotification*)notification{
    [self lookForPlacesNearby];
}

-(void)lookForPlacesNearby{
    if(self.objects.count == 0){
        if([[[CoreLocationManager sharedInstance] locations] lastObject]){
            CLLocation *location = [[[CoreLocationManager sharedInstance] locations] lastObject];
            
            NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            NSString *lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            
            [[ListLocationCommand sharedInstance] listLocationsNearbyLatitude:lat
                                                                 andLongitude:lng WithBlock:^(NSDictionary *result, NSError *error) {
                if (error) {
                    NSLog(@"error: %@", error.localizedDescription);
                } else {
                    NSArray *results = [result objectForKey:@"result"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.objects = [[NSMutableArray alloc] init];
                        
                        showDisplayAll = NO;
                        
                        if(results.count > 0){
                            [self.tableViewSearchResult setHidden:NO];
                            [self.labelNoResult setHidden:YES];
                            
                            if(results.count >= 2){
                                showDisplayAll = YES;
                            }
                            
                            for (NSDictionary *result in results) {                                
                                [self.objects addObject:result];
                            }
                            
                            [[VotesManager sharedInstance] setPlaces:[self.objects mutableCopy]];
                            self.objects = [[VotesManager sharedInstance] getMostVotedPlaces];
                        }
                        else{
                            //Show Message No Results and hide the tableview.
                            [self.tableViewSearchResult setHidden:YES];
                            [self.labelNoResult setHidden:NO];
                        }
                        
                        [self.tableViewSearchResult reloadData];
                    });
                }
            }];
        }
    }
}

#pragma mark - Votes Methods

-(void)voteForPlace:(NSDictionary *)aPlace{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[aPlace objectForKey:@"name"]
                                                    message:@"Would you like to vote for this restaurant today ?"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)postVote{
    NSDictionary *aPlace = self.objects[self.selectedIndexPath.row];
    
    [[InsertVoteCommand sharedInstance] insertVoteWithPlaceID:[aPlace objectForKey:@"place_id"]
                                                withPlaceName:[aPlace objectForKey:@"name"]
                                                 withLatitude:[[[[aPlace objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] stringValue]
                                                withLongitude:[[[[aPlace objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] stringValue]
                                                    withBlock:^(NSDictionary *result, NSError *error) {
                                                        if(error){
                                                            NSLog(@"%@", error.localizedDescription);
                                                        }
                                                        
                                                        [[VotesManager sharedInstance] refreshVotes];
                                                        
                                                        [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                                         target:self.tableViewSearchResult
                                                                                       selector:@selector(reloadData)
                                                                                       userInfo:nil
                                                                                        repeats:NO];
                                                    }];
}


#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self postVote];
    }
}

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(showDisplayAll){
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(showDisplayAll && section == 0){
        return 2;
    }
    
    return self.objects.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 1:
            sectionName = @"Choose the one you want to have lunch today";
            break;
            
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if(showDisplayAll && indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
        
        if(indexPath.row == 0){
            cell.textLabel.text = @"Display Restaurants on Map";
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = @"Display chosen restaurants";
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
        
        NSDictionary *aPlace = self.objects[indexPath.row];
        
        UILabel *nameLabel = [cell.contentView viewWithTag:1];
        nameLabel.text = [aPlace objectForKey:@"name"];
        
        
        NSString *rating = [aPlace objectForKey:@"rating"];
        if(!rating){
            rating = @"0.0";
        }
        UILabel *ratingLable = [cell.contentView viewWithTag:2];
        ratingLable.text = [NSString stringWithFormat:@"Google Rating: %@", rating];
        
        
        int votes = [[VotesManager sharedInstance] getVotesForPlaceID:[aPlace objectForKey:@"place_id"]];
        UILabel *votesLabel = [cell.contentView viewWithTag:3];
        votesLabel.text = [NSString stringWithFormat:@"Votes: %d", votes];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller = nil;
    if(showDisplayAll && indexPath.row == 0 && indexPath.section == 0){ //Display All places on maps
        
        NSMutableArray *marks = [[NSMutableArray alloc] init];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        for(NSDictionary *aDict in self.objects){
            [marks addObject:aDict];
        }
        [data setObject:marks forKey:@"marks"];
        [data setObject:@"1" forKey:@"displayAll"];
        [data setObject:@"0"  forKey:@"selectedIndex"];
        
        controller = [[ViewFactory sharedInstance] createMapsViewControllerWithData:data];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    if(showDisplayAll && indexPath.row == 1 && indexPath.section == 0){ //Display History
        controller = [[ViewFactory sharedInstance] createHistoryViewController];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(indexPath.section == 1){//Wanna vote for a place
        NSDictionary *aPlace = self.objects[indexPath.row];                
        
        if(![[TimerManager sharedInstance] isVoteTime]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName
                                                            message:@"Vote time is closed"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        else if([VotesManager sharedInstance].hasUserAlreadyVotedToday){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName
                                                            message:@"You already voted today"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else if(![[VotesManager sharedInstance] isVoteValidForPlaceID:[aPlace objectForKey:@"place_id"]]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName
                                                            message:@"You already had lunch here this week, please vote for another Restaurant."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }        
        else{
            self.selectedIndexPath = indexPath;
            
            [self voteForPlace:aPlace];
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {    
    return NO;
}

@end
