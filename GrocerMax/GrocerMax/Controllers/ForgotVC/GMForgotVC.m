//
//  GMForgotVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMForgotVC.h"

@interface GMForgotVC ()

@property (weak, nonatomic) IBOutlet UIView *emailBgView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@end

@implementation GMForgotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GETTER/SETTER Methods

- (void)setEmailBgView:(UIView *)emailBgView {
    
    _emailBgView = emailBgView;
    [_emailBgView.layer setCornerRadius:5.0];
    [_emailBgView.layer setBorderWidth:1.0];
    [_emailBgView.layer setBorderColor:[UIColor inputTextFieldColor].CGColor];
}

#pragma mark - IBAction Methods

- (IBAction)submitButtonTapped:(id)sender {
    
    
}
@end
