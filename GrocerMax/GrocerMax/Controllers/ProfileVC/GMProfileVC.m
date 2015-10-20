//
//  GMProfileVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 12/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProfileVC.h"
#import "GMLoginVC.h"
#import "GMMyAddressesVC.h"
#import "GMEditProfileVC.h"
#import "GMOrderHistryVC.h"

#import "GMAddBillingAddressVC.h"
#import "GMAddShippingAddressVC.h"
#import "MGSocialMedia.h"
#import "GMChangePasswordVC.h"
#import <MessageUI/MessageUI.h>


@interface GMProfileModal : NSObject

@property (nonatomic, strong) NSString *displayCellText;

@property (nonatomic, strong) NSString *optionsClassName;

- (instancetype)initWithCellText:(NSString *)cellText andClassName:(NSString *)className;
@end

@implementation GMProfileModal

- (instancetype)initWithCellText:(NSString *)cellText andClassName:(NSString *)className {
    
    if(self = [super init]) {
        
        _displayCellText = cellText;
        _optionsClassName = className;
    }
    return self;
}

@end

@interface GMProfileVC () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (strong, nonatomic) IBOutlet UIView *profileHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

@property (weak, nonatomic) IBOutlet UILabel *userMobileLabel;

@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) GMUserModal *userModal;
@end

static NSString * const kprofileCellIdentifier              = @"profileCellIdentifier";

static NSString * const kOrderHistoryCell                   =  @"Order History";
static NSString * const kMyAddressCell                      =  @"Shipping Addresses";
static NSString * const kEditProfileCell                    =  @"Edit My Information";
static NSString * const kInviteFriendsCell                  =  @"Invite Friends";
static NSString * const kCallUsCell                         =  @"Call Us";
static NSString * const kWriteToUsCell                      =  @"Write To Us";
static NSString * const kChangePasswordCell                 =  @"Change Password";
static NSString * const kLogOutCell                         =  @"Log out";

static NSString * const customerCareNumber = @"8010500700";

@implementation GMProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_TabProfile withCategory:@"" label:nil value:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"My Profile";
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    
    [self createCellArray];
    [self configureTableHeaderView];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Profile_Screen];
}

- (void)createCellArray {
    
    [self.cellArray removeAllObjects];
    GMProfileModal *orderHistory = [[GMProfileModal alloc] initWithCellText:kOrderHistoryCell andClassName:@"GMOrderHistryVC"];
    [self.cellArray addObject:orderHistory];
    GMProfileModal *myAddress = [[GMProfileModal alloc] initWithCellText:kMyAddressCell andClassName:@"GMMyAddressesVC"];
    [self.cellArray addObject:myAddress];
    GMProfileModal *editProfile = [[GMProfileModal alloc] initWithCellText:kEditProfileCell andClassName:@"GMEditProfileVC"];
    [self.cellArray addObject:editProfile];
    GMProfileModal *inviteFriend = [[GMProfileModal alloc] initWithCellText:kInviteFriendsCell andClassName:@""];
    [self.cellArray addObject:inviteFriend];
    GMProfileModal *callUs = [[GMProfileModal alloc] initWithCellText:kCallUsCell andClassName:@""];
    [self.cellArray addObject:callUs];
    GMProfileModal *writeUs = [[GMProfileModal alloc] initWithCellText:kWriteToUsCell andClassName:@""];
    [self.cellArray addObject:writeUs];
    
    GMProfileModal *changePassword = [[GMProfileModal alloc] initWithCellText:kChangePasswordCell andClassName:@""];
    [self.cellArray addObject:changePassword];
    
    GMProfileModal *logout = [[GMProfileModal alloc] initWithCellText:kLogOutCell andClassName:@""];
    [self.cellArray addObject:logout];
    
    [self.profileTableView reloadData];
}

- (void)configureTableHeaderView {
    
    self.userModal = [GMUserModal loggedInUser];
    if(NSSTRING_HAS_DATA(self.userModal.lastName))
        [self.userNameLabel setText:[NSString stringWithFormat:@"%@ %@", self.userModal.firstName, self.userModal.lastName]];
    else
        [self.userNameLabel setText:self.userModal.firstName];
    [self.userEmailLabel setText:self.userModal.email];
    if(NSSTRING_HAS_DATA(self.userModal.mobile)) {
        [self.userMobileLabel setText:[NSString stringWithFormat:@"+91 %@", self.userModal.mobile]];
    }
    else{
        [self.userMobileLabel setText:@""];
    }
    self.profileTableView.tableHeaderView = self.profileHeaderView;
    self.profileTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)cellArray {
    
    if(!_cellArray) _cellArray = [NSMutableArray array];
    return _cellArray;
}

- (void)setUserProfileImageView:(UIImageView *)userProfileImageView {
    
    _userProfileImageView = userProfileImageView;
    [_userProfileImageView.layer setCornerRadius:CGRectGetWidth(_userProfileImageView.frame)/2];
}

#pragma mark - UITableView Datasource/Delegate Methods

static CGFloat const kProfileCellHeight = 44.0f;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kProfileCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kprofileCellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kprofileCellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    GMProfileModal *profileModal = [self.cellArray objectAtIndex:indexPath.row];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage forwardArrowImage]];
    cell.textLabel.text = profileModal.displayCellText;
    cell.textLabel.textColor = [UIColor colorFromHexString:@"#1d1d1d"];
    cell.textLabel.font = FONT_REGULAR(14);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProfileModal *profileModal = [self.cellArray objectAtIndex:indexPath.row];
    if([profileModal.displayCellText isEqualToString:kInviteFriendsCell]) {
        
        [self shareExperience];
    }
    else if([profileModal.displayCellText isEqualToString:kCallUsCell]) {
        [self call];
    }
    else if([profileModal.displayCellText isEqualToString:kWriteToUsCell]) {
        [self openMailComposerVC];
    }
    else if([profileModal.displayCellText isEqualToString:kChangePasswordCell]) {
        
        GMChangePasswordVC *changePasswordVC  = [GMChangePasswordVC new];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    } else if([profileModal.displayCellText isEqualToString:kLogOutCell]) {
        
        [[GMSharedClass sharedClass] logout];
        [[GMSharedClass sharedClass] clearCart];
        [self.tabBarController updateBadgeValueOnCartTab];
        [self setSecondTabAsLogIn];
    }
    else {
        
        UIViewController *vc = [[NSClassFromString(profileModal.optionsClassName) alloc] initWithNibName:profileModal.optionsClassName bundle:nil];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)shareExperience{
    
    MGSocialMedia *socalMedia = [MGSocialMedia sharedSocialMedia];
    [socalMedia showActivityView:@"Hey, I cut my grocery bill by 30% at GrocerMax.com. Over 8000 grocery items, all below MRP and unbelievable offers. Apply code APP200 and start with Flat Rs. 200 off on your first bill."];
    
}

- (void)call {
    
    NSString *callString = [NSString stringWithFormat:@"tel:%@", customerCareNumber];
    NSURL *phoneURL = [NSURL URLWithString:callString];
    static UIWebView *webView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webView = [UIWebView new];
    });
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

- (void)openMailComposerVC {
    
    // Email Subject
    NSString *emailTitle = @"Customer Support Request";
    // Email Content
    NSString *messageBody = @"Hi";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"care@grocermax.com"];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];;
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else
        NSLog(@"This device cannot send email");
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Set 2nd tab as login VC
- (void)setSecondTabAsLogIn{
    
    GMLoginVC *loginVC = [[GMLoginVC alloc] initWithNibName:@"GMLoginVC" bundle:nil];
    UIImage *profileVCTabImg = [[UIImage profile_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *profileVCTabSelectedImg = [[UIImage profile_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    loginVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:profileVCTabImg selectedImage:profileVCTabSelectedImg];
    
    [[self.tabBarController.viewControllers objectAtIndex:1] setViewControllers:@[loginVC] animated:YES];
}


- (void)goOrderHistoryList {
    GMOrderHistryVC *orderHistryVC = [GMOrderHistryVC new];
    [self.navigationController pushViewController:orderHistryVC animated:YES];
}
@end
