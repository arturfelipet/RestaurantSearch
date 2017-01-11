//
//  SignInViewController.m
//  RestaurantSearch
//
//  Created by Artur Felipe on 01/07/17.
//  Copyright © 2017 Artur Felipe. All rights reserved.
//

#import "SignInViewController.h"
#import "InsertUserCommand.h"
#import "ListUsersCommand.h"

@interface SignInViewController () <UITextFieldDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignInViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];
    
    self.title = @"Sign Up";
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
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didSignUpOrLogin{
    UIViewController *controller = [[ViewFactory sharedInstance] createSearchViewController];
    
    [self.navigationController setViewControllers:@[controller] animated:YES];
}

- (void)showMessagePrompt:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:nil
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UI Actions
- (IBAction)signUp:(id)sender {
    if([self validateUIFIelds]){
        [[InsertUserCommand sharedInstance] createUserWithEmail:_emailTextField.text
                                                   withPassword:_passwordTextField.text
                                                   withUserName:_userNameTextField.text
                                                      withBlock:^(NSDictionary *result, NSError *error) {
                                                          if (error) {
                                                              [self showMessagePrompt:error.localizedDescription];
                                                              return;
                                                          }
                                                          
                                                          [self didSignUpOrLogin];
                                                      }];
    }
}

- (IBAction)emailLogin:(id)sender {
    if([self validateUIFIelds]){
        [[ListUsersCommand sharedInstance] signInWithEmail:_emailTextField.text
                                               andPassword:_passwordTextField.text
                                                 WithBlock:^(NSDictionary *result, NSError *error) {
                                                     if (error) {
                                                         [self showMessagePrompt:error.localizedDescription];
                                                         return;
                                                     }
                                                     
                                                     [self didSignUpOrLogin];
        }];
    }
}

#pragma mark - UI Help
- (BOOL) validateUIFIelds{
    if(_userNameTextField.text.length == 0){
        [self showMessagePrompt:@"Please type an username"];
        return NO;
    }
    else if(_emailTextField.text.length == 0){
        [self showMessagePrompt:@"Please type your mail address"];
        return NO;
    }
    else if(_passwordTextField.text.length == 0){
        [self showMessagePrompt:@"Please type the password"];
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - UITextFieldDelegate protocol methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
