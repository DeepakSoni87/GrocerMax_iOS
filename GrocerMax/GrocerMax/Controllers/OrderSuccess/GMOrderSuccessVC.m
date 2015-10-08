//
//  GMOrderSuccessVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 28/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderSuccessVC.h"
#import "GMCartModal.h"

@interface GMOrderSuccessVC ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdlabel;
@end

@implementation GMOrderSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.orderIdlabel setText:[NSString stringWithFormat:@"order Id: %@", self.orderId]];
    GMCartModal *cartModal = [GMCartModal loadCart];
    [cartModal.cartItems removeAllObjects];
    [cartModal.deletedProductItems removeAllObjects];
    [cartModal archiveCart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)continueShoppingButtonTapped:(id)sender {
    
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    [self.tabBarController setSelectedIndex:0];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
//    [self.tabBarController setSelectedIndex:0];
}

@end
