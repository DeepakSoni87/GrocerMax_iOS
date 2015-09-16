//
//  GMRegisterVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 13/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRegisterVC.h"
#import "GMRegisterInputCell.h"
#import "PlaceholderAndValidStatus.h"
#import "GMUserModal.h"
#import "GMGenderCell.h"

@interface GMRegisterVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GMGenderCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *registerTableView;

@property (strong, nonatomic) IBOutlet UIView *registerHeaderView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) GMGenderCell *genderCell;

@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) UITextField *currentTextField;
@end

static NSString * const kInputFieldCellIdentifier           = @"inputFieldCellIdentifier";

static NSString * const kFirstNameCell                      =  @"First Name";
static NSString * const kLastNameCell                       =  @"Last Name";
static NSString * const kMobileCell                         =  @"Mobile No";
static NSString * const kEmailCell                          =  @"Email";
static NSString * const kPasswordCell                       =  @"Password";
static NSString * const kGenderCell                         =  @"Gender";


@implementation GMRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    [self.registerTableView setTableHeaderView:self.registerHeaderView];
    [self.registerTableView setTableFooterView:self.footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    [self.registerTableView registerNib:[UINib nibWithNibName:@"MAInputFieldCell" bundle:nil] forCellReuseIdentifier:kInputFieldCellIdentifier];
}

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)cellArray {
    
    if(!_cellArray) {
        
        _cellArray = [NSMutableArray arrayWithObjects:
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kFirstNameCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kLastNameCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kMobileCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kEmailCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kPasswordCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kGenderCell placeHolder:@"required" andStatus:kNone],
                      nil];
    }
    return _cellArray;
}

- (GMGenderCell *)genderCell {
    
    if(!_genderCell) _genderCell = [[[NSBundle mainBundle] loadNibNamed:@"GMGenderCell" owner:self options:nil] lastObject];
    return _genderCell;
}

- (GMUserModal *)userModal {
    
    if(!_userModal) _userModal = [[GMUserModal alloc] init];
    return _userModal;
}

#pragma mark - UITavleView Delegate/Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMRegisterInputCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlaceholderAndValidStatus *objPlaceholderAndStatus = [self.cellArray objectAtIndex:indexPath.row];
    if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kGenderCell]) {
        
        [self.genderCell setDelegate:self];
        return self.genderCell;
    }
    else {
        
        GMRegisterInputCell *inputFieldCell = (GMRegisterInputCell *)[tableView dequeueReusableCellWithIdentifier:kInputFieldCellIdentifier];
        inputFieldCell.inputTextField.delegate = self;
        [self configureInputFieldCell:inputFieldCell withIndex:indexPath.row];
        return inputFieldCell;
    }
}

- (void)configureInputFieldCell:(GMRegisterInputCell*)inputCell withIndex:(NSInteger)cellIndex {
    
    PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:cellIndex];
    inputCell.inputTextField.returnKeyType = UIReturnKeyNext;
    inputCell.inputTextField.placeholder = objPlaceholderAndStatus.placeholder ;
    inputCell.statusType = (StatusType) objPlaceholderAndStatus.statusType ;
    inputCell.inputTextField.tag = cellIndex;
    inputCell.inputTextField.secureTextEntry = NO;
    inputCell.cellNameLabel.text = objPlaceholderAndStatus.inputFieldCellType;
    
    if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kFirstNameCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.firstName) ? self.userModal.firstName : @"";
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kLastNameCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.lastName) ? self.userModal.lastName : @"";
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kMobileCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.mobile) ? self.userModal.mobile : @"";
        inputCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        inputCell.inputTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kEmailCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.email) ? self.userModal.email : @"";
        inputCell.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kPasswordCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.password) ? self.userModal.password : @"";
        inputCell.inputTextField.secureTextEntry = YES;
    }
}

#pragma mark- UITextField Delegates...

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    self.currentTextField = textField;
    return YES;  // Hide both keyboard and blinking cursor.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 0: {
            
            NSString *firstName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = firstName;
            [self.userModal setFirstName:firstName];
            [self checkValidFirstName];
        }
            break;
        case 1: {
            
            NSString *lastName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = lastName;
            [self.userModal setLastName:lastName];
            [self checkValidLastName];
        }
            break;
        case 2: {
            
            NSString *phoneNumber = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = phoneNumber;
            [self.userModal setMobile:phoneNumber];
            [self checkValidMobileNumber];
        }
            break;
        case 3: {
            
            NSString *email = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = email;
            [self.userModal setEmail:email];
            [self checkValidEmailAddress];
        }
            break;
        case 4: {
            
            NSString *password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = password;
            [self.userModal setPassword:password];
            [self checkValidPassword];
        }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self focusToNextInputField];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *ACCEPTABLE_CHARACTERS;
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 0: {
            ACCEPTABLE_CHARACTERS = @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            if([resultString length] > 30)
                return NO;
        }
            break;
        case 1: {
            ACCEPTABLE_CHARACTERS = @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            if([resultString length] > 30)
                return NO;
        }
            break;
        case 2: {
            
            if([resultString length] > 10)
                return NO;
        }
            break;
        case 3: {
            
            if([resultString length] > 30)
                return NO;
        }
            break;
        case 4: {
            
            if([resultString length] > 20)
                return NO;
        }
            break;
        default:
            break;
    }
    
    if (ACCEPTABLE_CHARACTERS != nil) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else
        return YES;
}

- (void)focusToNextInputField {
    
    [self.currentTextField resignFirstResponder];
    NSInteger nextTag = self.currentTextField.tag + 1;
    GMRegisterInputCell *cell = (GMRegisterInputCell*)[self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:nextTag inSection:0]];
    if ([GMRegisterInputCell class] == [cell class]) {
        UIResponder* nextResponder = cell.inputTextField;
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
        }
    }
}

#pragma mark-
#pragma mark Validations...

- (BOOL)performValidations {
    
    BOOL resultedBool = YES;
    
    if (![self checkValidFirstName]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidLastName]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidMobileNumber]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidEmailAddress]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidPassword]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    return resultedBool;
}

- (BOOL)checkValidFirstName {
    
    BOOL resultedBool = YES;
    int  rowNumber = 0;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.userModal.firstName)){
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidLastName{
    
    BOOL resultedBool = YES;
    int  rowNumber = 1;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.userModal.lastName)) {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidMobileNumber{
    
    BOOL resultedBool = YES;
    int  rowNumber = 2;
    GMRegisterInputCell* cell ;
    if (![GMSharedClass validateMobileNumberWithString:self.userModal.mobile]) {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidEmailAddress{
    
    BOOL resultedBool = YES;
    int  rowNumber = 3;
    GMRegisterInputCell* cell ;
    if (![GMSharedClass validateEmail:self.userModal.email]) {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidPassword{
    
    BOOL resultedBool = YES;
    int  rowNumber = 4;
    GMRegisterInputCell* cell ;
    if(NSSTRING_HAS_DATA(self.userModal.password) && [self.userModal.password length] >= 6) {
        
        cell = (GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
        return YES;
    }
    else {
        
        cell = (GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }
    return resultedBool;
}

#pragma mark - IBAction Methods

- (IBAction)createAccountButtonTapped:(id)sender {
    
    if([self performValidations]) {
        
    }
}

#pragma mark - GenderCell Delegate Method

- (void)genderSelectionWithType:(GMGenderType)genderType {
    
    [self.userModal setGender:genderType];
}
@end
