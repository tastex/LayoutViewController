//
//  RootViewController.m
//  LayoutViewController
//
//  Created by tastex on 23.07.17.
//  Copyright © 2017 Vladimir Bolotov. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()
@property (strong, nonatomic) LayoutViewController *layoutVC;
@property (strong, nonatomic) NSMutableArray *layoutViewControllers;
@property (strong, nonatomic) UISegmentedControl *segmentControl;


@end

@implementation RootViewController

- (LayoutViewController *)layoutVC {
    return [self.viewControllers firstObject];
}

- (NSMutableArray *)layoutViewControllers {
    if (!_layoutViewControllers) _layoutViewControllers = [[NSMutableArray alloc] initWithObjects:self.layoutVC, nil];
    return _layoutViewControllers;
}

- (void)viewDidLoad {
    NSLog(@"RootViewController — View did load");
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems: self.layoutVC.layoutTypes];
    [self.segmentControl addTarget:self action:@selector(selectionDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setSelectedSegmentIndex:[self.layoutVC.layoutTypes indexOfObject:self.layoutVC.currentType]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.segmentControl]];
    
    NSArray *leftBarButtonItems = [NSArray arrayWithObjects:
                                   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVC)],
                                   [[UIBarButtonItem alloc] initWithTitle:@"sv" style:UIBarButtonItemStylePlain target:self action:@selector(splitVCVertically)],
                                   [[UIBarButtonItem alloc] initWithTitle:@"sh" style:UIBarButtonItemStylePlain target:self action:@selector(splitVCHorizontally)],
                                   nil];
    
    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *twoFingersSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
    twoFingersSingleTap.numberOfTapsRequired = 1;
    twoFingersSingleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:twoFingersSingleTap];
    
    UISwipeGestureRecognizer *twoFingersSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    twoFingersSwipeLeft.numberOfTouchesRequired = 2;
    twoFingersSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:twoFingersSwipeLeft];
    
    UISwipeGestureRecognizer *twoFingersSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    twoFingersSwipeRight.numberOfTouchesRequired = 2;
    twoFingersSwipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:twoFingersSwipeRight];
    
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
        if (sender.numberOfTouches == 2) {
            NSLog(@"Two finger tap");
            
            LayoutViewController *newLayoutVC = [[LayoutViewController alloc] initWithType:@"=H"];
            [self.layoutViewControllers insertObject:newLayoutVC atIndex:[self.layoutViewControllers indexOfObject:self.layoutVC] + 1];
            [self.segmentControl setSelectedSegmentIndex:[self.layoutVC.layoutTypes indexOfObject:newLayoutVC.currentType]];
            [self setViewControllers:[[NSArray alloc] initWithObjects:newLayoutVC, nil] direction:UIPageViewControllerNavigationDirectionForward  animated:YES completion:nil];
            
        }else if (sender.numberOfTouches == 1) {
            
            CGPoint touchPoint = [sender locationInView:self.layoutVC.view];
            NSLog(@"Touch point: %@", NSStringFromCGPoint(touchPoint));
            
            UIView *contentView = [self.layoutVC.view hitTest:touchPoint withEvent:nil];
            
            if ([self.layoutVC.view.subviews containsObject:contentView] == NO) return;
            
            NSUInteger viewIndex = [self.layoutVC.view.subviews indexOfObject:contentView];
            
            self.layoutVC.selectedVC = [self.layoutVC.viewControllers objectAtIndex:viewIndex];
            
            [self animateSelectedView:contentView];
            
            NSLog(@"Selected view index: %lu", (unsigned long)viewIndex);
        }

    }
    
}

- (void)animateSelectedView:(UIView *)view {
    CGPoint center = view.center;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView animateWithDuration:0.1
                     animations:^(){
                         view.center = CGPointMake(center.x, center.y-15);
                     }
                     completion:^(BOOL finished) {
                         [UIView beginAnimations:nil context:nil];
                         [UIView setAnimationDuration:0.1];
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                         view.center = center;
                         [UIView commitAnimations];
                     }];
}


- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    
   if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
            NSLog(@"Swiped left");
            
            if ([self.layoutViewControllers lastObject] != self.layoutVC) {
                LayoutViewController *visibleLayoutVC = [self.layoutViewControllers objectAtIndex:[self.layoutViewControllers indexOfObject:self.layoutVC] + 1];
                [self.segmentControl setSelectedSegmentIndex:[self.layoutVC.layoutTypes indexOfObject:visibleLayoutVC.currentType]];
                [self setViewControllers:[[NSArray alloc] initWithObjects:visibleLayoutVC, nil] direction:UIPageViewControllerNavigationDirectionForward  animated:YES completion:nil];
            }
        }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
            NSLog(@"Swiped right");
            
            if ([self.layoutViewControllers firstObject] != self.layoutVC) {
                LayoutViewController *visibleLayoutVC = [self.layoutViewControllers objectAtIndex:[self.layoutViewControllers indexOfObject:self.layoutVC] - 1];
                [self.segmentControl setSelectedSegmentIndex:[self.layoutVC.layoutTypes indexOfObject:visibleLayoutVC.currentType]];
                [self setViewControllers:[[NSArray alloc] initWithObjects:visibleLayoutVC, nil] direction:UIPageViewControllerNavigationDirectionReverse  animated:YES completion:nil];
            }
        }
    }
}


@end
