//
//  LayoutViewController.m
//  LayoutViewController
//
//  Created by tastex on 19.07.17.
//  Copyright © 2017 Vladimir Bolotov. All rights reserved.
//

#import "LayoutViewController.h"
#import "ContentViewController.h"

@interface LayoutViewController ()
@property (strong, nonatomic) NSArray *layoutTypes;
@property (strong, nonatomic) NSString *currentType;
@end

@implementation LayoutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.layoutTypes = [[NSArray alloc] initWithObjects:@"=H", @"=V", @"1+H", @"1+V", nil];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:self.layoutTypes];
    [segmentControl addTarget:self action:@selector(segementedControlTapped:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = 0;
    [self segementedControlTapped: segmentControl];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentControl];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVC:)];
}


- (void)addVC:(id)sender {
    
    [self addChildViewController:[[ContentViewController alloc] init]];
    
    [self.view addSubview:self.childViewControllers.lastObject.view];
    
    [self updateContent];
}

- (void)segementedControlTapped:(UISegmentedControl *)sender {
    self.currentType = [self.layoutTypes objectAtIndex:[sender selectedSegmentIndex]];
    
    [self updateContent];
}

- (void)updateContent {
    
    for (UIViewController *childVC in self.childViewControllers) {
        
        childVC.view.frame = [self getViewFrameForViewController: childVC];
        
    }
    
}


- (CGRect)getViewFrameForViewController:(UIViewController *)vc {
    int amountOfVC = (int) [self.childViewControllers count];
    
    if (amountOfVC == 0) {
        return CGRectNull;
    }
    
    int indexOfVC = (int) [self.childViewControllers indexOfObject:vc];
    
    CGFloat width = self.view.frame.size.width/amountOfVC;
    CGFloat height = self.view.frame.size.height;
    CGFloat x = self.view.frame.origin.x + width*indexOfVC;
    CGFloat y = self.view.frame.origin.y;
    
    
    if ([self.currentType rangeOfString:@"V"].location != NSNotFound ) {
        width = self.view.frame.size.width;
        height = self.view.frame.size.height/amountOfVC;
        x = self.view.frame.origin.x;
        y = self.view.frame.origin.y + height*indexOfVC;
    }
    
    return CGRectMake(x, y, width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
