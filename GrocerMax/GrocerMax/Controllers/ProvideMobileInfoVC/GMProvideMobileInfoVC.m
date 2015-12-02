//
//  GMProvideMobileInfoVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 29/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProvideMobileInfoVC.h"
#import "GMOtpVC.h"
#import "GMProfileVC.h"

@interface GMProvideMobileInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *manualTextLbl;
@property (weak, nonatomic) IBOutlet UIView *txtBGView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *txtField;

@end

@implementation GMProvideMobileInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self ConfigureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_ProvideMobileInfo_Screen];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark - ConfigureView

-(void)ConfigureView {
    
    self.txtBGView.layer.cornerRadius = 5.0;
    self.txtBGView.layer.masksToBounds = YES;
    self.txtBGView.layer.borderWidth = 1.0;
    self.txtBGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.submitBtn.layer.cornerRadius = 5.0;
    self.submitBtn.layer.masksToBounds = YES;
    
    if (self.userModal.email.length > 1) {// for phone
        self.manualTextLbl.text = @"Please provide your phone for further communication";
        self.txtField.placeholder = @"Enter Phone";
    }else{// for email
        self.manualTextLbl.text = @"Please provide your email for further communication";
        self.txtField.placeholder = @"Enter Email";
    }
}

#pragma mark - Button Action

- (IBAction)submitBtnPressed:(UIButton *)sender {
    
    if (self.userModal.email.length > 1) {// for phone
        if ([self performValidationsOnPhone]) {
            [self.userModal setMobile:self.txtField.text];
            [self fbRegisterOnServer];
        }
    }else{// for email
        
        if ([self performValidationsOnEmail]) {
            [self.userModal setEmail:self.txtField.text];
            [self fbRegisterOnServer];
        }
    }
}

#pragma mark - Validations...

- (BOOL)performValidationsOnEmail{
    
    if (!NSSTRING_HAS_DATA(self.txtField.text)){
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterEmail")];
        return NO;
    }
    else if (![GMSharedClass validateEmail:self.txtField.text])
    {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterValidEmail")];
        return NO;
    }
    
    else
        return YES;
}

- (BOOL)performValidationsOnPhone{
    
    if (!NSSTRING_HAS_DATA(self.txtField.text)){
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterPhonNumber")];
        return NO;
    }
    else if (![GMSharedClass validateMobileNumberWithString:self.txtField.text])
    {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterValidPhonNumber")];
        return NO;
    }
    
    else
        return YES;
}

#pragma mark - Send data on server

- (void)fbRegisterOnServer {
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [paramDict setObject:self.userModal.email forKey:kEY_uemail];
    [paramDict setObject:@"" forKey:kEY_quote_id];
    [paramDict setObject:self.userModal.firstName ? self.userModal.firstName : @"" forKey:kEY_fname];
    [paramDict setObject:self.userModal.lastName ? self.userModal.lastName : @"" forKey:kEY_lname];
    [paramDict setObject:self.userModal.mobile forKey:kEY_number];

    [self showProgress];
    [[GMOperationalHandler handler] fgLoginRequestParamsWith:paramDict withSuccessBlock:^(id data) {
        
        [self removeProgress];
        NSDictionary *resDic = data;
        
        if ([resDic objectForKey:kEY_UserID]) {
            [self.userModal setQuoteId:resDic[kEY_QuoteId]];
            [self.userModal setUserId:resDic[kEY_UserID]];
            
            
            if ([resDic objectForKey:kEY_Mobile]) {
                if ([[resDic objectForKey:kEY_Mobile] objectForKey:@"mobileNumber"]) {
                    [self.userModal setMobile:[[resDic objectForKey:kEY_Mobile] objectForKey:@"mobileNumber"]];
                }
            }
            else if ([resDic objectForKey:@"Mobile"]) {
                [self.userModal setMobile:[resDic objectForKey:@"Mobile"]];
            }
            
            
            [self.userModal setTotalItem:[NSNumber numberWithInteger:[resDic[kEY_TotalItem] integerValue]]];
            
            [self.userModal persistUser];// save user modal in memory
            [[GMSharedClass sharedClass] setUserLoggedStatus:YES];// save logged in status
            [self setSecondTabAsProfile];//So user is registered, now set 2nd tab as profile
        }
                
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}


@end
