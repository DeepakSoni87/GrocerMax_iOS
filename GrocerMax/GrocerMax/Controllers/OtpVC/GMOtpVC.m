//
//  GMOtpVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOtpVC.h"

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

#pragma mark - GETTER/SETTER Methods

- (void)setOtpBgView:(UIView *)otpBgView {
    
    _otpBgView = otpBgView;
    [_otpBgView.layer setCornerRadius:5.0];
    [_otpBgView.layer setBorderWidth:1.0];
    [_otpBgView.layer setBorderColor:[UIColor inputTextFieldColor].CGColor];
}

#pragma mark - IBAction Methods

- (IBAction)submitButtonTapped:(id)sender {
    
    
}
@end
