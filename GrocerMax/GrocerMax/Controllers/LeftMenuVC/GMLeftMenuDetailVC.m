//
//  GMLeftMenuDetailVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMLeftMenuDetailVC.h"

@interface GMLeftMenuDetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *categoryDetailTableView;
@end

@implementation GMLeftMenuDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate/DataSource Methods

#pragma mark - IBAction Methods

- (IBAction)backButtonTapped:(id)sender {
    
    
}
@end
