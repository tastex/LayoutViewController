//
//  RootViewController.m
//  LayoutViewController
//
//  Created by tastex on 23.07.17.
//  Copyright © 2017 Vladimir Bolotov. All rights reserved.
//

#import "RootViewController.h"
#import "LayoutViewController.h"

@interface RootViewController ()
@property (strong, nonatomic) LayoutViewController *layoutVC;
@end

@implementation RootViewController

- (LayoutViewController *)layoutVC {
    if (!_layoutVC) _layoutVC = [[LayoutViewController alloc] initWithType:@"=H"];
    return _layoutVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:self.layoutVC];
    [self.view addSubview:self.layoutVC.view];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:self.layoutVC.layoutTypes];
    [segmentControl addTarget:self action:@selector(selectionDidChange:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentControl];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVC)];
    
}


- (void)selectionDidChange:(UISegmentedControl *)sender {
    self.layoutVC.currentType = [self.layoutVC.layoutTypes objectAtIndex:[sender selectedSegmentIndex]];
}


- (void)addVC{
    [self.layoutVC addVC];
}



@end
