//
//  GMOrderSuccessVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 28/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderSuccessVC.h"
#import "GMCartModal.h"
#import "GMProfileVC.h"
#import "MGSocialMedia.h"

@interface GMOrderSuccessVC ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdlabel;
@end

@implementation GMOrderSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.orderIdlabel setText:[NSString stringWithFormat:@"order Id is  %@", self.orderId]];
    
    NSDictionary* style1 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmRedColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName : FONT_BOLD(18),
                             NSForegroundColorAttributeName : [UIColor gmBlackColor],
                             };
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"Order ID is " attributes:style1];
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:self.orderId attributes:style2]];
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\nPlease check your mail for details" attributes:style1]];
    
    [self.orderIdlabel setAttributedText:attString];

    [[GMSharedClass sharedClass] clearCart];
    [self.tabBarController updateBadgeValueOnCartTab];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_OrderSuccess withCategory:@"" label:nil value:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_CartPaymentSucess_Screen];
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
- (IBAction)actionOrderHistory:(id)sender {
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:NO];
    GMProfileVC *profileVC = [APP_DELEGATE rootProfileVCFromFourthTab];
    
    
    if([profileVC respondsToSelector:@selector(goOrderHistoryList)]){
        [profileVC goOrderHistoryList];
    } else {
        GMProfileVC *profileVC = [[GMProfileVC alloc] initWithNibName:@"GMProfileVC" bundle:nil];
        UIImage *profileVCTabImg = [[UIImage imageNamed:@"profile_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        UIImage *profileVCTabSelectedImg = [[UIImage imageNamed:@"profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:profileVCTabImg selectedImage:profileVCTabSelectedImg];
        [self adjustShareInsets:profileVC.tabBarItem];
        [[self.tabBarController.viewControllers objectAtIndex:1] setViewControllers:@[profileVC] animated:YES];
        [profileVC goOrderHistoryList];
    }
}

- (IBAction)shareBtnAction:(UIButton *)sender {

    MGSocialMedia *socalMedia = [MGSocialMedia sharedSocialMedia];
    [socalMedia showActivityView:@"Hey, Checkout this product!!!"];
}


@end
