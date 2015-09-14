//
//  GMProfileVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 12/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProfileVC.h"

@interface GMProfileVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (strong, nonatomic) IBOutlet UIView *profileHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

@property (weak, nonatomic) IBOutlet UILabel *userMobileLabel;
@end

@implementation GMProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource/Delegate Methods

@end
