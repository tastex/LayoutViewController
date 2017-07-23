//
//  LayoutViewController.h
//  LayoutViewController
//
//  Created by tastex on 19.07.17.
//  Copyright © 2017 Vladimir Bolotov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface LayoutViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *viewControllers; 
@property (strong, nonatomic) NSString *currentType;
@property (strong, nonatomic) NSArray *layoutTypes;

- (instancetype)initWithType:(NSString *)type;


- (void)addVC;
- (void)deleteVC:(id)vc;

+ (int)maxAmountOfVC;

@end

