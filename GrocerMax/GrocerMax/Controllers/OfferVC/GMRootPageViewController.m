//
//  GMRootPageViewController.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRootPageViewController.h"
#import "GMOffersVC.h"


CGFloat originY = 0.0; //for all btn
CGFloat btnHeight = 40.0; //same as scrollview


@interface GMRootPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *btnsArray;
@property (strong , nonatomic) UIView *selectedStripView;
@property (nonatomic) NSInteger currentPageIndex;

@end

@implementation GMRootPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self setUpTopBar];
            [self configureView];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - SetUp View

-(void)configureView{
    
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;

    NSArray *viewControllers = @[[self viewControllerAtIndex:0]];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [[self.pageViewController view] setFrame:CGRectMake(0, 64 + btnHeight, kScreenWidth, kScreenHeight - 64 - btnHeight)];
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

-(void)setUpTopBar{
    
    self.pageData = @[@"0sfsf",@"1as",@"2s",@"3sdf sfsf",@"4sdf  ee e e sfsf",@"5",@"6sdfsfsf",@"7dfsfsf",@"8sdf ascd d   asdsfsf",@"9dfsfsf",@"10sdfsfsf"];

    self.btnsArray = [NSMutableArray new];
    self.selectedStripView = [UIView new];
    self.selectedStripView.backgroundColor = [UIColor whiteColor];
    self.currentPageIndex = 0;
    
    CGFloat originX = 0;
    
    for(int i = 0 ;i<self.pageData.count;i++)
    {
        CGFloat width = [self getBoundingWidthOfText:self.pageData[i]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX, originY, width, btnHeight);
        [button setTitle:self.pageData[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:FONT_BOLD(16)];
        [button addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.backgroundColor = [UIColor redColor];
        [self.topScrollView addSubview:button];
        
        [self.btnsArray addObject:button];
        
        originX += width;
    }
    
    if (originX < kScreenWidth) {
        
        CGFloat extraPaddingInEachBtn = (kScreenWidth - originX)/self.pageData.count;
        
        originX = 0;
        
        for (UIButton *btn in self.btnsArray) {
            CGRect oldFrm = btn.frame;
            oldFrm.origin.x = originX;
            oldFrm.size.width += extraPaddingInEachBtn;
            btn.frame = oldFrm;
            
            originX += oldFrm.size.width;
        }
    }
    
    [self.topScrollView setContentSize:CGSizeMake(originX, btnHeight-1)];
    [self selectedSection:0];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(GMOffersVC *)viewController];
    
    if (index != NSNotFound) {
        [self selectedSection:index];
    }
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(GMOffersVC *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    [self selectedSection:index];
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - methods

- (GMOffersVC *)viewControllerAtIndex:(NSUInteger)index {
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    GMOffersVC *offerVC = [[GMOffersVC alloc] initWithNibName:@"GMOffersVC" bundle:nil];
    offerVC.dataObject = self.pageData[index];
    return offerVC;
}

- (NSUInteger)indexOfViewController:(GMOffersVC *)viewController {
    
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark -

-(CGFloat)getBoundingWidthOfText:(NSString*)str{
    
    NSDictionary *attributes = @{NSFontAttributeName: FONT_BOLD(16)};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return (rect.size.width + 20);// padding 20
}

-(void)segmentButtonAction:(UIButton *)button {
    
    [self selectedSection:button.tag];
    __weak typeof(self) weakSelf = self;

    NSInteger tempIndex = self.currentPageIndex;
    
    
    if (button.tag > tempIndex) {
        
        // scroll through all the Views between the two points
        for (int i = (int)tempIndex+1; i<=button.tag; i++) {
            [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                if (finished) {
                    weakSelf.currentPageIndex = i;
                }
            }];
        }
    }else{
        
        for (int i = (int)tempIndex-1; i >= button.tag; i--) {
            [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                if (finished) {
                    weakSelf.currentPageIndex = i;
                }
            }];
        }
    }
}

-(void)selectedSection:(NSInteger)index{
    
    UIButton *btn = self.btnsArray[index];
    
    CGRect frm = btn.bounds;
    frm.origin.y = frm.size.height - 5;
    frm.size.height = 5;
    self.selectedStripView.frame = frm;
    
    [btn addSubview:self.selectedStripView];
    
    [self.topScrollView scrollRectToVisible:btn.frame animated:YES];
}

@end
