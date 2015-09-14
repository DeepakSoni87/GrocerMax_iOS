//
//  GMRegisterVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 13/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRegisterVC.h"

@interface GMRegisterVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *registerTableView;

@property (strong, nonatomic) IBOutlet UIView *registerHeaderView;

@end

@implementation GMRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods

- (IBAction)createAccountButtonTapped:(id)sender {
}

@end
