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
#import "GMChangePasswordVC.h"

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

@interface GMProfileVC () <UITableViewDataSource, UITableViewDelegate>

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
static NSString * const kMyAddressCell                      =  @"My Addresses";
static NSString * const kEditProfileCell                    =  @"Edit My Information";
static NSString * const kInviteFriendsCell                  =  @"Invite Friends";
static NSString * const kCallUsCell                         =  @"Call Us";
static NSString * const kWriteToUsCell                      =  @"Write To Us";
static NSString * const kChangePasswordCell                      =  @"Change Password";

@implementation GMProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationItem.title = @"My Profile";
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    if([[GMSharedClass sharedClass] getUserLoggedStatus]) {
        
        [self createCellArray];
        [self configureTableHeaderView];
    }
    else {
        
        GMLoginVC *loginVC = [[GMLoginVC alloc] initWithNibName:@"GMLoginVC" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:NO];
    }
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
    
    
    [self.profileTableView reloadData];
}

- (void)configureTableHeaderView {
    
    self.userModal = [GMUserModal loggedInUser];
    if(NSSTRING_HAS_DATA(self.userModal.lastName))
        [self.userNameLabel setText:[NSString stringWithFormat:@"%@ %@", self.userModal.firstName, self.userModal.lastName]];
    else
        [self.userNameLabel setText:self.userModal.firstName];
    [self.userEmailLabel setText:self.userModal.email];
    [self.userMobileLabel setText:[NSString stringWithFormat:@"+91 %@", self.userModal.mobile]];
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
    cell.textLabel.font = FONT_REGULAR(11);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProfileModal *profileModal = [self.cellArray objectAtIndex:indexPath.row];
    if([profileModal.displayCellText isEqualToString:kInviteFriendsCell]) {
        
    }
    else if([profileModal.displayCellText isEqualToString:kCallUsCell]) {
        
    }
    else if([profileModal.displayCellText isEqualToString:kWriteToUsCell]) {
        
    }
    else if([profileModal.displayCellText isEqualToString:kChangePasswordCell]){
        GMChangePasswordVC *changePasswordVC  = [GMChangePasswordVC new];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
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

@end
