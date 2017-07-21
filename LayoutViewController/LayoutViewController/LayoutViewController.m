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

@end

@implementation LayoutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVC:)];
}


- (void)addVC:(id)sender {
    
    [self addChildViewController:[[ContentViewController alloc] init]];
    
    [self.view addSubview:self.childViewControllers.lastObject.view];
    
    [self updateContent];
}

- (void)updateContent {
    int amountOfVC = (int) [self.childViewControllers count];
    
    if (amountOfVC == 0) {
        return;
    }
    
    //TODO - получать размер фрейма для различного представления вида
    CGFloat width = self.view.frame.size.width/amountOfVC;
    CGFloat height = self.view.frame.size.height;
    CGFloat x = self.view.frame.origin.x-width;
    CGFloat y = self.view.frame.origin.y;
    
    for (UIView *subView in self.view.subviews) {
        
       x=x+width;
        
       subView.frame = CGRectMake(x, y, width, height);
       
   }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
