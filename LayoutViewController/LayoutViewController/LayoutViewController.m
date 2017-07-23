//
//  LayoutViewController.m
//  LayoutViewController
//
//  Created by tastex on 19.07.17.
//  Copyright © 2017 Vladimir Bolotov. All rights reserved.
//

#import "LayoutViewController.h"


@interface LayoutViewController ()
@property int amountOfVC;

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
    if (self.amountOfVC >= [LayoutViewController maxAmountOfVC]) return;
    
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    [self.viewControllers addObject:contentVC];
    
    self.amountOfVC = (int) [self.viewControllers count];
    
    [self updateChildViewControllers];
}

- (void)deleteVC:(id)vc {
    NSLog(@"delete from parent VC");
    
    [self.viewControllers removeObject:vc];
    [vc removeFromParentViewController];
    
    self.amountOfVC = (int) [self.viewControllers count];
    [self updateContent];
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
        [self updateContent];
    }
}



- (void)updateContent {

    for (UIViewController *childVC in self.childViewControllers) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        childVC.view.frame = [self getViewFrameForViewController: childVC];
        [childVC viewWillAppear:NO];
        
        [UIView commitAnimations];
    }
    
}


- (CGRect)getViewFrameForViewController:(UIViewController *)vc {
    int amountOfVC = self.amountOfVC;
    
    if (amountOfVC == 0) {
        return CGRectNull;
    }
    
    CGRect frame = self.view.frame;
    
    int indexOfVC = (int) [self.childViewControllers indexOfObject:vc];

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

+ (int)maxAmountOfVC { return 10;}

@end
