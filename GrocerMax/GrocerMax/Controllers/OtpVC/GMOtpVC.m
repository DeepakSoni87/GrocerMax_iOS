//
//  GMOtpVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOtpVC.h"
#import "GMRegistrationResponseModal.h"

@interface GMOtpVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *otpBgView;

@property (weak, nonatomic) IBOutlet UITextField *oneTimePasswordTF;
@end

@implementation GMOtpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_OTP_Screen];
}

#pragma mark - GETTER/SETTER Methods

- (void)setOtpBgView:(UIView *)otpBgView {
    
    _otpBgView = otpBgView;
    [_otpBgView.layer setCornerRadius:5.0];
    [_otpBgView.layer setBorderWidth:1.0];
    [_otpBgView.layer setBorderColor:[UIColor inputTextFieldColor].CGColor];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
#pragma mark - IBAction Methods

- (IBAction)submitButtonTapped:(id)sender {
    
    [self.view endEditing:YES];
    if(NSSTRING_HAS_DATA(self.oneTimePasswordTF.text) && [self.oneTimePasswordTF.text isEqualToString:self.userModal.otp]) {
        [self.view endEditing:YES];
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        if(NSSTRING_HAS_DATA(self.userModal.firstName))
            [userDic setObject:self.userModal.firstName forKey:kEY_fname];
        if(NSSTRING_HAS_DATA(self.userModal.lastName))
            [userDic setObject:self.userModal.lastName forKey:kEY_lname];
        if(NSSTRING_HAS_DATA(self.userModal.email))
            [userDic setObject:self.userModal.email forKey:kEY_uemail];
        if(NSSTRING_HAS_DATA(self.userModal.mobile))
            [userDic setObject:self.userModal.mobile forKey:kEY_number];
        if(NSSTRING_HAS_DATA(self.userModal.password))
            [userDic setObject:self.userModal.password forKey:kEY_password];
        [userDic setObject:@"1" forKey:kEY_otp];
        [self showProgress];
        [[GMOperationalHandler handler] createUser:userDic withSuccessBlock:^(GMRegistrationResponseModal *registrationResponse) {
            
            if([registrationResponse.flag isEqualToString:@"1"]) {
                
                [self.userModal setUserId:registrationResponse.userId];
                [self.userModal persistUser];
                [[GMSharedClass sharedClass] setUserLoggedStatus:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
                [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
            
            [self removeProgress];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
            [self removeProgress];
        }];
    }
    else
        [[GMSharedClass sharedClass] showErrorMessage:@"Please enter OTP."];
}
@end
