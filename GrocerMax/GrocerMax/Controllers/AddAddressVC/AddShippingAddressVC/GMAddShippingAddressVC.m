//
//  GMAddShippingAddressVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMAddShippingAddressVC.h"
#import "GMRegisterInputCell.h"
#import "PBPickerVC.h"
#import "GMLocalityBaseModal.h"

@interface GMAddShippingAddressVC ()  <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PBPickerDoneCancelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *shippingAddressTableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) NSMutableArray *localityArray;

@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) UITextField *currentTextField;

/** This property is for picker for name prefix, occupation, marital status */
@property (nonatomic, strong) PBPickerVC* valuePickerVC;

@property (nonatomic, assign) BOOL isDefaultShippingAddress;
@end

static NSString * const kInputFieldCellIdentifier           = @"inputFieldCellIdentifier";

static NSString * const kHouseCell                      =  @"House No.";
static NSString * const kStreetCell                     =  @"Street Address/ Locality";
static NSString * const kClosestLandmarkCell            =  @"Closest landmark";
static NSString * const kCityCell                       =  @"City";
static NSString * const kStateCell                      =  @"State";
static NSString * const kPincodeCell                    =  @"Pincode";

@implementation GMAddShippingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)registerCellsForTableView {
    
    [self.shippingAddressTableView registerNib:[UINib nibWithNibName:@"GMRegisterInputCell" bundle:nil] forCellReuseIdentifier:kInputFieldCellIdentifier];
}

- (void)fetchLocalitiesFromServer {
    
    [self showProgress];
    [[GMOperationalHandler handler] getLocalitiesOfCity:@"1" withSuccessBlock:^(GMLocalityBaseModal *localityBaseModal) {
        
        [self removeProgress];
        if(localityBaseModal)
            self.localityArray = [NSMutableArray arrayWithArray:localityBaseModal.localityArray];
    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)cellArray {
    
    if(!_cellArray) {
        
        _cellArray = [NSMutableArray arrayWithObjects:
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kHouseCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kStreetCell placeHolder:@"eg. A-1221, DLF OakWood Apartment" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kClosestLandmarkCell placeHolder:@"to get your groceries to you quicker" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kStateCell placeHolder:@"eg. Gurgaon" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kPincodeCell placeHolder:@"Select from dropdown" andStatus:kNone],
                      nil];
    }
    return _cellArray;
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
    
    GMRegisterInputCell *inputFieldCell = (GMRegisterInputCell *)[tableView dequeueReusableCellWithIdentifier:kInputFieldCellIdentifier];
    inputFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
    inputFieldCell.inputTextField.delegate = self;
    [self configureInputFieldCell:inputFieldCell withIndex:indexPath.row];
    return inputFieldCell;
}

- (void)configureInputFieldCell:(GMRegisterInputCell*)inputCell withIndex:(NSInteger)cellIndex {
    
    PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:cellIndex];
    inputCell.inputTextField.returnKeyType = UIReturnKeyNext;
    inputCell.inputTextField.placeholder = objPlaceholderAndStatus.placeholder ;
    inputCell.statusType = (StatusType) objPlaceholderAndStatus.statusType ;
    inputCell.inputTextField.tag = cellIndex;
    inputCell.inputTextField.secureTextEntry = NO;
    inputCell.cellNameLabel.text = objPlaceholderAndStatus.inputFieldCellType;
    [inputCell.showButton setHidden:YES];
    inputCell.inputTextField.keyboardType = UIKeyboardTypeDefault;
    inputCell.inputTextField.enabled = YES;
    [inputCell.inputTextField setBackgroundColor:[UIColor whiteColor]];
    
    if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kHouseCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.firstName) ? self.userModal.firstName : @"";
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kStreetCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.lastName) ? self.userModal.lastName : @"";
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kClosestLandmarkCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.mobile) ? self.userModal.mobile : @"";
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kCityCell]) {
        
        inputCell.inputTextField.enabled = NO;
        [inputCell.inputTextField setBackgroundColor:[UIColor inputTextFieldDisableColor]];
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.email) ? self.userModal.email : @"";
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kStateCell]) {
        
        inputCell.inputTextField.enabled = NO;
        [inputCell.inputTextField setBackgroundColor:[UIColor inputTextFieldDisableColor]];
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.email) ? self.userModal.email : @"";
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kPincodeCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.mobile) ? self.userModal.mobile : @"";
        inputCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        inputCell.inputTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
}

#pragma mark- UITextField Delegates...

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.currentTextField = textField;
    if (self.currentTextField.tag == 1) {
        
        textField.inputView = [self configureValuePicker];
    }
    else{
        self.currentTextField.inputView = nil;
    }
    return YES;  // Hide both keyboard and blinking cursor.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 0: {
            
            NSString *firstName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = firstName;
            [self.userModal setFirstName:firstName];
            [self checkValidHouseNo];
        }
            break;
        case 1: {
            
            if(!NSSTRING_HAS_DATA(textField.text))
                [self.userModal setLastName:textField.text];
            [self checkValidStreetAddress];
        }
            break;
        case 2: {
            
            NSString *phoneNumber = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = phoneNumber;
            [self.userModal setMobile:phoneNumber];
            [self checkValidClosestLandmark];
        }
            break;
        case 3: {
            
            NSString *email = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = email;
            [self.userModal setEmail:email];
            [self checkValidCity];
        }
            break;
        case 4: {
            
            if(!NSSTRING_HAS_DATA(textField.text))
                [self.userModal setPassword:textField.text];
            [self checkValidState];
        }
            break;
        case 5: {
            
            NSString *password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = password;
            [self.userModal setPassword:password];
            [self checkValidPincode];
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
    
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
            
        case 5: {
            
            if([resultString length] >= 6)
                return NO;
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)focusToNextInputField {
    
    [self.currentTextField resignFirstResponder];
    NSInteger nextTag = self.currentTextField.tag + 1;
    GMRegisterInputCell *cell = (GMRegisterInputCell*)[self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:nextTag inSection:0]];
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
    
    if (![self checkValidHouseNo]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidStreetAddress]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidClosestLandmark]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidCity]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidState]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidPincode]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    return resultedBool;
}

- (BOOL)checkValidHouseNo {
    
    BOOL resultedBool = YES;
    int  rowNumber = 0;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.userModal.firstName)){
        cell =(GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidStreetAddress {
    
    BOOL resultedBool = YES;
    int  rowNumber = 1;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.userModal.lastName)) {
        cell =(GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidClosestLandmark {
    
    BOOL resultedBool = YES;
    int  rowNumber = 2;
    GMRegisterInputCell* cell ;
    if (![GMSharedClass validateMobileNumberWithString:self.userModal.mobile]) {
        cell =(GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidCity {
    
    BOOL resultedBool = YES;
    int  rowNumber = 3;
    GMRegisterInputCell* cell ;
    if (![GMSharedClass validateEmail:self.userModal.email]) {
        cell =(GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidState {
    
    BOOL resultedBool = YES;
    int  rowNumber = 4;
    GMRegisterInputCell* cell ;
    if(NSSTRING_HAS_DATA(self.userModal.password) && [self.userModal.password length] >= 6) {
        
        cell = (GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
        return YES;
    }
    else {
        
        cell = (GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }
    return resultedBool;
}

- (BOOL)checkValidPincode {
    
    BOOL resultedBool = YES;
    int  rowNumber = 5;
    GMRegisterInputCell* cell ;
    if(NSSTRING_HAS_DATA(self.userModal.password) && [self.userModal.password length] >= 6) {
        
        cell = (GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
        return YES;
    }
    else {
        
        cell = (GMRegisterInputCell*) [self.shippingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }
    return resultedBool;
}

#pragma mark - Picker Configurations

- (UIView*)configureValuePicker {
    
    if (self.valuePickerVC == nil) {
        self.valuePickerVC = [[PBPickerVC alloc] initWithNibName:@"PBPickerVC" bundle:nil];
        self.valuePickerVC.pickerDoneCancelDelegate = self;
    }
    
    self.valuePickerVC.arrayValuesToDisplay = [self statesToDisplay];
    //    if(NSSTRING_HAS_DATA(self.userSignUpModal.profession))
    //        [self.valuePickerVC.pickerView selectRow:[self.occupationArray indexOfObject:self.userSignUpModal.profession] inComponent:0 animated:NO];
    return self.valuePickerVC.view;
}

- (NSMutableArray*)statesToDisplay {
    
    NSMutableArray* displayValues = [NSMutableArray array];
    for (GMLocalityModal* localityModal in self.localityArray) {
        [displayValues addObject:localityModal.localityName];
    }
    return [NSMutableArray arrayWithObject:displayValues];
}

#pragma mark - PickerView Delegates

- (void)pickerValueChanged:(NSString *)changeValue {
    
    self.currentTextField.text = changeValue;
}

- (void)donePressedValuePicker:(NSArray *)selectedIndeces{
    
    if (!selectedIndeces.count)
        return;
    int selectedIndex = [[selectedIndeces objectAtIndex:0] intValue];
    GMLocalityModal *localityModal = [self.localityArray objectAtIndex:selectedIndex];
    [self.userModal setPassword:localityModal.localityName];
    self.currentTextField.text = self.userModal.password;
    [self focusToNextInputField];
}

- (void)cancelPressedValuePicker:(id)sender{
    
    self.currentTextField.text = self.userModal.password;
    [self.currentTextField resignFirstResponder];
}

#pragma mark - IBAction Methods

- (IBAction)saveButtonTapped:(id)sender {
    
    if([self performValidations]) {
        
        
    }
}

- (IBAction)defaultShippingAddressButtonTapped:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.isDefaultShippingAddress = !self.isDefaultShippingAddress;
}

@end
