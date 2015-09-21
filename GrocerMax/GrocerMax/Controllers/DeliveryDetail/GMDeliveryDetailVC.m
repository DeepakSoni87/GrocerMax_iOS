//
//  GMDeliveryDetailVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMDeliveryDetailVC.h"
#import "GMDeliveryDetailCell.h"
#import "GMTimeSloteModal.h"
#import "GMTimeSlotBaseModal.h"
#import "GMDeliveryDateTimeSlotModal.h"

static NSString *kIdentifierDeliveryDetailCell = @"deliveryDetailIdentifierCell";

@interface GMDeliveryDetailVC ()
{
    NSInteger selectedDateIndex;
}
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UIButton *preSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextSelectBtn;


@property (weak, nonatomic) IBOutlet UILabel *selectedDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UITableView *timeSloteTableView;

@property (nonatomic, strong) GMTimeSloteModal *selectedTimeSlotModal;

@end

@implementation GMDeliveryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    selectedDateIndex = 0;
    [self.timeSloteTableView setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    self.dateTimeSloteModalArray = [[NSMutableArray alloc]init];;
    [self getDateAndTimeSlot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMDeliveryDetailCell" bundle:[NSBundle mainBundle]];
    [self.timeSloteTableView registerNib:nib forCellReuseIdentifier:kIdentifierDeliveryDetailCell];
    
}

#pragma mark - GETTER/SETTER Methods

- (void)setDateLbl:(UILabel *)dateLbl {
    
    _dateLbl = dateLbl;
    [_dateLbl.layer setCornerRadius:10.0];
    [_dateLbl setClipsToBounds:YES];
}

- (void)setTimeLbl:(UILabel *)timeLbl {
    
    _timeLbl = timeLbl;
    [_timeLbl.layer setCornerRadius:10.0];
    [_timeLbl setClipsToBounds:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Action Methods
- (IBAction)actionProceed:(id)sender {
}
- (IBAction)actionPriviouesDate:(id)sender {
    
    if(selectedDateIndex!=0 && self.dateTimeSloteModalArray.count>0)
    {
        GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:selectedDateIndex-1];
        
        self.dateLbl.text = deliveryDateTimeSlotModal.deliveryDate;
        self.selectedDateLbl.text = deliveryDateTimeSlotModal.deliveryDate;
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isSelected == YES"];
        NSArray *arry = [deliveryDateTimeSlotModal.timeSlotModalArray filteredArrayUsingPredicate:pred];
        if(arry.count>0)
        {
            GMTimeSloteModal *timeSloteModal =[arry objectAtIndex:0];
            self.selectedTimeSlotModal = timeSloteModal;
        }
        
        selectedDateIndex = selectedDateIndex-1;
        [self.timeSloteTableView reloadData];
    }
}
- (IBAction)actionNextDate:(id)sender {
    if(selectedDateIndex < 6 && self.dateTimeSloteModalArray.count>0)
    {
        GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:selectedDateIndex+1];
        self.dateLbl.text = deliveryDateTimeSlotModal.deliveryDate;
        self.selectedDateLbl.text = deliveryDateTimeSlotModal.deliveryDate;
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isSelected == YES"];
        NSArray *arry = [deliveryDateTimeSlotModal.timeSlotModalArray filteredArrayUsingPredicate:pred];
        if(arry.count>0)
        {
           GMTimeSloteModal *timeSloteModal =[arry objectAtIndex:0];
            self.selectedTimeSlotModal = timeSloteModal;
        }
        selectedDateIndex = selectedDateIndex+1;
        
        [self.timeSloteTableView reloadData];
    }
}

-(void)timeSlotButtonTapped:(GMButton *)sender {
    
    GMTimeSloteModal *timeSloteModal = sender.timeSlotModal;
    if(timeSloteModal.isSloatFull || sender.selected)
        return;
    
    if(self.selectedTimeSlotModal)
       [self.selectedTimeSlotModal setIsSelected:NO];
    
    [timeSloteModal setIsSelected:YES];
    self.selectedTimeSlotModal = timeSloteModal;
    self.timeLbl.text = timeSloteModal.firstTimeSlote;
    [self.timeSloteTableView reloadData];
    
    return;
}
//Use to fill the timeslot modal into array from base modal array
- (void)setDataInArray:( NSArray*)array {
    NSString *date = @"";
    BOOL isselected = FALSE;
    GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal;
    for(int i= 0; i<array.count;i++) {
        GMDeliveryTimeSlotModal *deliveryTimeSlotModal = [array objectAtIndex:i];
        if(![date isEqualToString:deliveryTimeSlotModal.deliveryDate]) {
            deliveryDateTimeSlotModal = [[GMDeliveryDateTimeSlotModal alloc]init];
            isselected = FALSE;
            deliveryDateTimeSlotModal.deliveryDate = deliveryTimeSlotModal.deliveryDate;
            deliveryDateTimeSlotModal.timeSlotModalArray = [[NSMutableArray alloc]init];
            date = deliveryTimeSlotModal.deliveryDate;
            
            GMTimeSloteModal *timeSloteModal = [[GMTimeSloteModal alloc]init];
            timeSloteModal.firstTimeSlote = deliveryTimeSlotModal.timeSlot;
            if([deliveryTimeSlotModal.isAvailable intValue] == 0) {
                timeSloteModal.isSloatFull = YES;
                timeSloteModal.isSelected = FALSE;
            }
            else {
                timeSloteModal.isSloatFull = NO;
                if(!isselected) {
                    timeSloteModal.isSelected = TRUE;
                    isselected = TRUE;
                }
                else {
                    timeSloteModal.isSelected = FALSE;
                }
            }
            [deliveryDateTimeSlotModal.timeSlotModalArray addObject:timeSloteModal];
            [self.dateTimeSloteModalArray addObject:deliveryDateTimeSlotModal];
        }
        else {
            GMTimeSloteModal *timeSloteModal = [[GMTimeSloteModal alloc]init];
            timeSloteModal.firstTimeSlote = deliveryTimeSlotModal.timeSlot;
            if([deliveryTimeSlotModal.isAvailable intValue] == 0) {
                timeSloteModal.isSloatFull = YES;
                timeSloteModal.isSelected = FALSE;
            }
            else {
                timeSloteModal.isSloatFull = NO;
                if(!isselected) {
                    timeSloteModal.isSelected = TRUE;
                    isselected = TRUE;
                }
                else {
                    timeSloteModal.isSelected = FALSE;
                }
            }
            [deliveryDateTimeSlotModal.timeSlotModalArray addObject:timeSloteModal];
        }
    }
    if(self.dateTimeSloteModalArray.count>0) {
        GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:0];
        selectedDateIndex = 0;
        self.dateLbl.text = deliveryDateTimeSlotModal.deliveryDate;
        self.selectedDateLbl.text = deliveryDateTimeSlotModal.deliveryDate;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isSelected == YES"];
        NSArray *arry = [deliveryDateTimeSlotModal.timeSlotModalArray filteredArrayUsingPredicate:pred];
        if(arry.count>0) {
            GMTimeSloteModal *timeSloteModal =[arry objectAtIndex:0];
            self.selectedTimeSlotModal = timeSloteModal;
            self.timeLbl.text = timeSloteModal.firstTimeSlote;
        }
    }
}

#pragma mark Request Methods

- (void)getDateAndTimeSlot {
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
        [dataDic setObject:@"321" forKey:kEY_userid];
        [self showProgress];
        [[GMOperationalHandler handler] getAddressWithTimeSlot:dataDic withSuccessBlock:^(GMTimeSlotBaseModal *responceData) {
             self.timeSlotBaseModal = responceData;
            NSArray *array = self.timeSlotBaseModal.timeSlotArray;
            [self setDataInArray:array];
            [self.timeSloteTableView reloadData];
            [self removeProgress];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
            [self removeProgress];
            
        }];
}


#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.dateTimeSloteModalArray.count>selectedDateIndex)
    {
        GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:selectedDateIndex];
        
        return [deliveryDateTimeSlotModal.timeSlotModalArray count]%2==0? [deliveryDateTimeSlotModal.timeSlotModalArray count]/2 :[deliveryDateTimeSlotModal.timeSlotModalArray count]/2+1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMDeliveryDetailCell *deliveryDetailCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierDeliveryDetailCell];
    
    NSInteger index = indexPath.row*2;
    GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:selectedDateIndex];
    
    GMTimeSloteModal *timeSloteModal = [deliveryDateTimeSlotModal.timeSlotModalArray objectAtIndex:index];
    GMTimeSloteModal *secondTimeSloteModal ;
    if(deliveryDateTimeSlotModal.timeSlotModalArray.count>index+1)
    {
        secondTimeSloteModal = [deliveryDateTimeSlotModal.timeSlotModalArray objectAtIndex:index+1];
    }
    
    
    deliveryDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    deliveryDetailCell.tag = indexPath.row;
    
    [deliveryDetailCell.firstTimeBtn addTarget:self action:@selector(timeSlotButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [deliveryDetailCell.firstTimeBtn setExclusiveTouch:YES];
    
    
    [deliveryDetailCell.secondTimeBtn addTarget:self action:@selector(timeSlotButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [deliveryDetailCell.secondTimeBtn setExclusiveTouch:YES];
    
    [deliveryDetailCell configerViewWithData:timeSloteModal withSecondModal:secondTimeSloteModal];
    return deliveryDetailCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
