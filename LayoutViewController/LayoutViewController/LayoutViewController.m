//
//  LayoutViewController.m
//  LayoutViewController
//
//  Created by tastex on 19.07.17.
//  Copyright © 2017 Vladimir Bolotov. All rights reserved.
//

#import "LayoutViewController.h"


@interface LayoutViewController ()


@end

@implementation LayoutViewController


- (instancetype) initWithType:(NSString *)type {
    NSLog(@"init layoutVC with type: %@", type);
    self = [super init];
    self.currentType = type;
    return self;
}

- (NSMutableArray  *)viewControllers {
    if (!_viewControllers) _viewControllers = [[NSMutableArray alloc] init];
    return _viewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addVC {
    if ((int) [self.viewControllers count] >= [LayoutViewController maxAmountOfVC]) return;
    
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    [self.viewControllers addObject:contentVC];
    
    
    [self updateChildViewControllers];
}

- (void)deleteVC:(id)vc {
    NSLog(@"delete from parent VC");
    
    if (vc == self.selectedVC) self.selectedVC = nil;
    
    [self.viewControllers removeObject:vc];
    [vc removeFromParentViewController];
    
    [self updateContent];
}


- (void)splitVCVertically {
    if (self.selectedVC == nil) return;
    
    CGRect frame = self.selectedVC.view.frame;
    CGFloat height = frame.size.height/2;
    
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y+height, frame.size.width, height);
    ContentViewController *contentVC = [self insertViewControllerAboveSelectedWithViewFrame: CGRectMake(newFrame.origin.x, newFrame.origin.y + height, newFrame.size.width, 0.0)];
    
    
    [UIView beginAnimations:nil context:nil];
    [self.selectedVC.view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height)];
    [self.selectedVC viewWillAppear:NO];
    
    [contentVC.view setFrame:newFrame];
    [contentVC viewWillAppear:NO];
    
    [UIView commitAnimations];
    
}

- (void)splitVCHorizontally {
    if (self.selectedVC == nil) return;
    
    CGRect frame = self.selectedVC.view.frame;
    CGFloat width = frame.size.width/2;
    
    CGRect newFrame = CGRectMake(frame.origin.x+width, frame.origin.y, width, frame.size.height);
    ContentViewController *contentVC = [self insertViewControllerAboveSelectedWithViewFrame: CGRectMake(newFrame.origin.x + width, newFrame.origin.y, 0.0, newFrame.size.height)];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [self.selectedVC.view setFrame:CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height)];
    [self.selectedVC viewWillAppear:NO];
    
    [contentVC.view setFrame:newFrame];
    [contentVC viewWillAppear:NO];
    
    [UIView commitAnimations];
    
}

- (ContentViewController *)insertViewControllerAboveSelectedWithViewFrame:(CGRect)frame {
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    contentVC.view.frame = frame;
    NSUInteger newVCIndex = [self.viewControllers indexOfObject:self.selectedVC] + 1;
    
    [self addChildViewController:contentVC];
    [self.viewControllers insertObject:contentVC atIndex:newVCIndex];
    [self.view insertSubview:contentVC.view aboveSubview:self.selectedVC.view];
    
    NSLog(@"New VC index: %lu, New view index: %lu", (unsigned long)newVCIndex, (unsigned long)[self.view.subviews indexOfObject:contentVC.view]);
    
    return contentVC;
}


- (void)updateChildViewControllers {
    for (UIViewController *vc in self.viewControllers) {
        if ([self.childViewControllers containsObject:vc] == NO) {
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
        }
    }
    [self updateContent];
}

- (void)setCurrentType:(NSString *)currentType {
    if (_currentType != currentType) {
        _currentType = currentType;
        [self updateContentLayout];
    }
}



- (void)updateContent{
    
    for (UIViewController *childVC in self.viewControllers) {
        
        CGRect frame = [self getViewFrameForViewController: childVC];
        
        if ([self.viewControllers lastObject] == childVC & [self.viewControllers firstObject] != childVC) {
            
            if (CGPointEqualToPoint(childVC.view.frame.origin, CGPointZero)) {
                CGRect lastFrame = frame;
                if ([self.currentType rangeOfString:@"H"].location != NSNotFound) {
                    lastFrame.origin.x = lastFrame.origin.x + frame.size.width;
                }else{
                    lastFrame.origin.y = lastFrame.origin.y + frame.size.height;
                }
                [childVC.view setFrame:lastFrame];
            }
            
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [childVC.view setFrame:frame];
        [childVC viewWillAppear:NO];
        
        [UIView commitAnimations];
    }
}

- (void)updateContentLayout {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    for (UIViewController *childVC in self.viewControllers) {
        
        CGRect newFrame = [self getViewFrameForViewController: childVC];
        CGRect frame = [self increaseRect:newFrame withMultiplier:-0.3];
        
        
        [childVC.view setFrame:frame];
        [childVC viewWillAppear:NO];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        [childVC.view setFrame:newFrame];
        [childVC viewWillAppear:NO];
        
        [UIView commitAnimations];
        
    }
    [UIView commitAnimations];

}


- (CGRect)increaseRect:(CGRect)rect withMultiplier:(CGFloat)multiplier
{
    NSLog(@"frame0: %@", NSStringFromCGRect(rect));
    CGFloat startWidth = CGRectGetWidth(rect);
    CGFloat startHeight = CGRectGetHeight(rect);
    CGFloat adjustmentWidth = (startWidth * multiplier) / 2.0;
    CGFloat adjustmentHeight = (startHeight * multiplier) / 2.0;
    rect = CGRectInset(rect, -adjustmentWidth, -adjustmentHeight);
    NSLog(@"frame1: %@", NSStringFromCGRect(rect));
    return rect;
}


- (CGRect)getViewFrameForViewController:(UIViewController *)vc {
    int amountOfVC = (int) [self.viewControllers count];
    
    if (amountOfVC == 0) {
        return CGRectNull;
    }
    
    CGRect frame = self.view.frame;
    
    int indexOfVC = (int) [self.viewControllers indexOfObject:vc];
    
    if ([self.currentType rangeOfString:@"+H"].location != NSNotFound ) {
        
        frame.size.height = amountOfVC > 1 ? frame.size.height/2 : frame.size.height;
        
        if (indexOfVC == 0) return frame;
        
        frame.origin.y = frame.size.height;
        indexOfVC = indexOfVC-1;
        amountOfVC = amountOfVC-1;
    }else if ([self.currentType rangeOfString:@"+V"].location != NSNotFound ) {
        
        frame.size.width = amountOfVC > 1 ? frame.size.width/2 : frame.size.width;
        
        if (indexOfVC == 0) return frame;
        
        frame.origin.x = frame.size.width;
        indexOfVC = indexOfVC-1;
        amountOfVC = amountOfVC-1;
    }
    
    
    
    CGFloat width = frame.size.width/amountOfVC;
    CGFloat height = frame.size.height;
    CGFloat x = frame.origin.x + width*indexOfVC;
    CGFloat y = frame.origin.y;
    
    
    if ([self.currentType rangeOfString:@"V"].location != NSNotFound ) {
        width = frame.size.width;
        height = frame.size.height/amountOfVC;
        x = frame.origin.x;
        y = frame.origin.y + height*indexOfVC;
    }
    
    return CGRectMake(x, y, width, height);
}



- (NSArray *)layoutTypes {
    if (!_layoutTypes) _layoutTypes = [[NSArray alloc] initWithObjects:@"=H", @"=V", @"1+H", @"1+V", nil];
    return _layoutTypes;
}

+ (int)maxAmountOfVC { return 25;}

@end
