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
@property (strong, nonatomic)   UITapGestureRecognizer *singleTap;

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
    
    NSArray *leftBarButtonItems = [NSArray arrayWithObjects:
                                   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVC)],
                                   [[UIBarButtonItem alloc] initWithTitle:@"sv" style:UIBarButtonItemStylePlain target:self action:@selector(splitVCVertically)],
                                   [[UIBarButtonItem alloc] initWithTitle:@"sh" style:UIBarButtonItemStylePlain target:self action:@selector(splitVCHorizontally)],
                                   nil];
    
    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
    
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
}


- (void)selectionDidChange:(UISegmentedControl *)sender {
    self.layoutVC.currentType = [self.layoutVC.layoutTypes objectAtIndex:[sender selectedSegmentIndex]];
}


- (void)addVC {
    [self.layoutVC addVC];
}

- (void)splitVCVertically {
    [self.layoutVC splitVCVertically];
}

- (void)splitVCHorizontally {
    [self.layoutVC splitVCHorizontally];
}


- (void)handleTaps:(UITapGestureRecognizer *)sender {

    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint touchPoint = [sender locationInView:self.layoutVC.view];
        NSLog(@"Touch point: %@", NSStringFromCGPoint(touchPoint));
        
        UIView *contentView = [self.layoutVC.view hitTest:touchPoint withEvent:nil];
        NSUInteger viewIndex = [self.layoutVC.view.subviews indexOfObject:contentView];
        
        self.layoutVC.selectedVC = [self.layoutVC.childViewControllers objectAtIndex:viewIndex];
        
        CGPoint center = contentView.center;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView animateWithDuration:0.2
                         animations:^(){
                             contentView.center = CGPointMake(center.x, center.y-15);
                         }
                         completion:^(BOOL finished) {
                                contentView.center = center;
                         }];
        
        //NSLog(@"View index: %d", index);
    }
    
}



@end
