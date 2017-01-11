//
//  HistoryViewController.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "HistoryViewController.h"
#import "ListHistoryCommand.h"

@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    Boolean showDisplayAll;
}

@property NSMutableArray *History;

@property (weak, nonatomic) IBOutlet UITableView *tableViewHistoryResult;
@property (weak, nonatomic) IBOutlet UILabel *labelNoResult;

@end

@implementation HistoryViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableViewHistoryResult setDelegate:self];
    [self.tableViewHistoryResult setDataSource:self];
    self.tableViewHistoryResult.contentInset = UIEdgeInsetsMake(44,0,0,0);
    
    [self.tableViewHistoryResult setHidden:YES];
    [self.labelNoResult setHidden:YES];
    
    [self prefersStatusBarHidden];
    
    self.title = @"Chosen restaurants";
    
    self.History = [[NSMutableArray alloc] init];
    
    [self getHistory];
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

#pragma mark - History Methods

-(void)getHistory{
    [[ListHistoryCommand sharedInstance] ListHistoryWithBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
        } else {
            self.History = [[result objectForKey:@"result"] mutableCopy];
            
            if(self.History.count > 0){
                [self.tableViewHistoryResult setHidden:NO];
                [self.labelNoResult setHidden:YES];
                
                [self.tableViewHistoryResult reloadData];
            }
            else{
                [self.tableViewHistoryResult setHidden:YES];
                [self.labelNoResult setHidden:NO];
                
                [self.tableViewHistoryResult reloadData];
            }                        
        }        
    }];
}

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.History.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"VoteCell" forIndexPath:indexPath];
    
    NSDictionary *aVote = self.History[indexPath.row];
    
    UILabel *nameLabel = [cell.contentView viewWithTag:1];
    nameLabel.text = [NSString stringWithFormat:@"Restaurant: %@", [aVote objectForKey:@"placename"]];
    
    UILabel *placenameLable = [cell.contentView viewWithTag:2];
    placenameLable.text = [NSString stringWithFormat:@"Votes: %@", [aVote objectForKey:@"votes"]];
    
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
