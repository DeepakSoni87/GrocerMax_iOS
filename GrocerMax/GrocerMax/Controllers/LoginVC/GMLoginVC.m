//
//  GMLoginVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMLoginVC.h"
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface GMLoginVC ()<UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;

@end

@implementation GMLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView{
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
}

#pragma mark - Button Action

- (IBAction)fbLoginButtonPressed:(UIButton *)sender {

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email",@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                
                if ([FBSDKAccessToken currentAccessToken])
                {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"fetched user:%@", result);
                         }
                     }];
                }
            }
        }
    }];
}
- (IBAction)googleLoginButtonPressed:(UIButton *)sender {
   
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)forgotButtonPressed:(UIButton *)sender {
    
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
 
    [self.view endEditing:YES];
    
    if([self performValidations]) {
        
        NSDictionary *param = [[GMRequestParams sharedClass] getUserLoginRequestParamsWith:self.txt_email.text password:self.txt_password.text] ;
        
        [self showProgress];
        [[GMOperationalHandler handler] login:param withSuccessBlock:^(id loggedInUser) {
            
            [self removeProgress];
            // do work here

        } failureBlock:^(NSError *error) {
            
            [self removeProgress];
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        }];
    }
}

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    
}

#pragma mark - Validations...

- (BOOL)performValidations{
    
    if (!NSSTRING_HAS_DATA(self.txt_email.text)){
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterEmail")];
        return NO;
    }
    else if (![GMSharedClass validateEmail:self.txt_email.text])
    {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterValidEmail")];
        return NO;
        
    }else if (!NSSTRING_HAS_DATA(self.txt_password.text))
    {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterPassword")];
        return NO;
    }
    else
        return YES;
}

#pragma mark - Google Login Delegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    // ...
    
    NSLog(@"Google login Success = %@",user.profile.email);
}
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

@end
