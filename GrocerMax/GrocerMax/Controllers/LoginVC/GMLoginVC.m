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
#import "GMRegisterVC.h"
#import "GMForgotVC.h"
#import "GMProfileVC.h"
#import "GMProvideMobileInfoVC.h"

@interface GMLoginVC ()<UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txt_email;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@end

@implementation GMLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureView];
    if(self.isPresent)
        self.closeBtn.hidden = NO;
    else
        self.closeBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    if(self.isPresent) {
        
        if([[GMSharedClass sharedClass] getUserLoggedStatus] == YES)
            [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        if([[GMSharedClass sharedClass] getUserLoggedStatus] == YES) {
            [self setSecondTabAsProfile];
        } else {
            [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_LogIn_Screen];
        }
    }
    
}

- (void)configureView{
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].scopes = @[@"https://www.googleapis.com/auth/userinfo.email", @"https://www.googleapis.com/auth/userinfo.profile"];
}

- (void)setTxt_email:(UITextField *)txt_email {
    
    _txt_email = txt_email;
    _txt_email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.45]}];
}

- (void)setTxt_password:(UITextField *)txt_password {
    
    _txt_password = txt_password;
    _txt_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.45]}];
}

#pragma mark - Button Action
- (IBAction)closeBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
                    
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,first_name,last_name,email,gender"}]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"fetched user:%@", result);
                             
                             NSDictionary *resultDic = result;

                             if(resultDic != nil) {
                                 if ([result objectForKey:@"email"]) {
                                     
                                     GMUserModal *userModal = [GMUserModal new];
                                     [userModal setFbId:[result objectForKey:@"id"]];
                                     [userModal setEmail:[result objectForKey:@"email"]];
                                     [userModal setFirstName:[result objectForKey:@"first_name"]];
                                     [userModal setLastName:[result objectForKey:@"last_name"]];
                                     [userModal setGender:[[result objectForKey:@"gender"] isEqualToString:@"male"]?GMGenderTypeMale:GMGenderTypeFemale];

                                     GMProvideMobileInfoVC *vc = [[GMProvideMobileInfoVC alloc] initWithNibName:@"GMProvideMobileInfoVC" bundle:nil];
                                     vc.userModal = userModal;
                                     [self.navigationController pushViewController:vc animated:YES];
                                 }
                             }
                             
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
    
    GMForgotVC *forgotVC = [[GMForgotVC alloc] initWithNibName:@"GMForgotVC" bundle:nil];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
 
    [self.view endEditing:YES];
    
    if([self performValidations]) {
        
        NSDictionary *param = [[GMRequestParams sharedClass] getUserLoginRequestParamsWith:self.txt_email.text password:self.txt_password.text] ;
        
        [self showProgress];
        [[GMOperationalHandler handler] login:param withSuccessBlock:^(GMUserModal *userModal) {
            
            [self removeProgress];
            [userModal setEmail:self.txt_email.text];
            [userModal persistUser];
            [[GMSharedClass sharedClass] setUserLoggedStatus:YES];
            if(self.isPresent) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                
                [self setSecondTabAsProfile];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        } failureBlock:^(NSError *error) {
            
            [self removeProgress];
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        }];
    }
}

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    
    GMRegisterVC *registerVC = [[GMRegisterVC alloc] initWithNibName:@"GMRegisterVC" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
//    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
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
    
    if (user.profile.email) {
    
        GMUserModal *userModal = [GMUserModal new];
        [userModal setGoogleId:user.userID];
        [userModal setEmail:user.profile.email];
        [userModal setFirstName:user.profile.name];
        [userModal setLastName:@""];
        [userModal setGender:GMGenderTypeMale];// suppose it defaul
        
        GMProvideMobileInfoVC *vc = [[GMProvideMobileInfoVC alloc] initWithNibName:@"GMProvideMobileInfoVC" bundle:nil];
        vc.userModal = userModal;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma mark - Flip Animation methods

- (void)flipVC:(UIViewController*) controller to:(UIViewAnimationTransition) trasition {
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:trasition
                           forView:self.navigationController.view cache:NO];
    
    if (controller)
        [self.navigationController pushViewController:controller animated:YES];
    
    [UIView commitAnimations];
}


@end
