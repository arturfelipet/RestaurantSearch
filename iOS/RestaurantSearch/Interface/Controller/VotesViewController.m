//
//  VotesViewController.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "VotesViewController.h"
#import "ListVotesCommand.h"

@interface VotesViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    Boolean showDisplayAll;
}

@property NSMutableArray *votes;

@property (weak, nonatomic) IBOutlet UITableView *tableViewVotesResult;
@property (weak, nonatomic) IBOutlet UILabel *labelNoResult;

@end

@implementation VotesViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableViewVotesResult setDelegate:self];
    [self.tableViewVotesResult setDataSource:self];
    self.tableViewVotesResult.contentInset = UIEdgeInsetsMake(44,0,0,0);
    
    [self.tableViewVotesResult setHidden:YES];
    [self.labelNoResult setHidden:YES];
    
    [self prefersStatusBarHidden];
    
    self.title = @"Today Votes";
    self.votes = [[NSMutableArray alloc] init];
    
    [self keepListeningForNewVotes];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
}

#pragma mark - Votes Methods

-(void)keepListeningForNewVotes{
    [[ListVotesCommand sharedInstance] ListLiveVotesWithBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
        } else {
            NSDictionary *vote = [result objectForKey:@"result"];
            if(vote){
                [self.votes addObject:vote];
            }
            
            if(self.votes.count > 0){
                [self.tableViewVotesResult setHidden:NO];
                [self.labelNoResult setHidden:YES];

                [self.tableViewVotesResult insertRowsAtIndexPaths:@[
                                                                    [NSIndexPath indexPathForRow:self.votes.count - 1 inSection:0]
                                                                    ]
                                                 withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else{
                [self.tableViewVotesResult setHidden:YES];
                [self.labelNoResult setHidden:NO];
            }
        }
    }];
}

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.votes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"VoteCell" forIndexPath:indexPath];
    
    NSDictionary *aVote = self.votes[indexPath.row];
    
    UILabel *nameLabel = [cell.contentView viewWithTag:1];
    nameLabel.text = [aVote objectForKey:@"author"];
    
    UILabel *placenameLable = [cell.contentView viewWithTag:2];
    placenameLable.text = [NSString stringWithFormat:@"%@", [aVote objectForKey:@"placename"]];
    
    UILabel *dateLable = [cell.contentView viewWithTag:3];
    dateLable.text = [NSString stringWithFormat:@"%@", [aVote objectForKey:@"date"]];        
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
