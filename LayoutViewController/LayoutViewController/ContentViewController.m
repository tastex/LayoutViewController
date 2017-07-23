//
//  ContentViewController.m
//  LayoutViewController
//
//  Created by tastex on 19.07.17.
//  Copyright © 2017 Vladimir Bolotov. All rights reserved.
//

#import "ContentViewController.h"
#import "LayoutViewController.h"

@interface ContentViewController ()
@property (strong, nonatomic) UIButton *deleteButton;
@end

@implementation ContentViewController
static const CGSize DELITE_SIZE = { 40, 40 }; //×


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get random color
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    self.view.backgroundColor = color;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.deleteButton.frame = [self getDeleteButtonFrame];
}


- (UIButton *)deleteButton {
    if(!_deleteButton) {
    
        _deleteButton = [[UIButton alloc] initWithFrame:[self getDeleteButtonFrame]];
        [_deleteButton setTitle:@"╳" forState:UIControlStateNormal];
        
        [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deleteButton];
        
    }
    return _deleteButton;
}

- (CGRect)getDeleteButtonFrame {
    //get top right corner coordinates
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DELITE_SIZE;
    frame.origin.x = self.view.frame.size.width-frame.size.width;
    
    return frame;
}


- (void)deleteAction {
    LayoutViewController *parent = (LayoutViewController *) self.parentViewController;
    [self.view removeFromSuperview];
    [parent deleteVC:self];
}



@end
