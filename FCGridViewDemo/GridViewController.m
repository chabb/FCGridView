//
//  ViewController.m
//  GridViewController
//
//  Created by François Chabbey on 04.04.15.
//  Copyright (c) 2015 François Chabbey. All rights reserved.
//

#import "GridViewController.h"
#import "UIColor+RandomColor.h"

@interface GridViewController ()

@end

@implementation GridViewController
{
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FCGridView *gv = [[FCGridView alloc] init];
    self.gridView = gv;
    gv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:gv];
    // ADD CONSTRAINTS
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:gv attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:gv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:gv attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:gv attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    gv.dataSource = self;
    gv.delegate = self;
    [gv reloadData];
    
    
}
// Basic implementation, override if needed
-(NSInteger)numberOfSectionsInGridView:(FCGridView *)gridView {
    return 2;
}
-(float)percentForSection:(NSInteger)section {
    return 0.5;
}
-(float)percentForElementAtIndexPath:(NSIndexPath *)indexPath {
   
    return 0.5;
}
- (NSInteger)gridView:(FCGridView *)gridView numberOfElementInSection:(NSInteger)section {
    return 2;
}
-(CGFloat)gutterSize {
    return 5.0;
}

- (UIView *)gridView:(FCGridView *)gridView viewForElementAtIndexPath:(NSIndexPath *)indexPath {
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor randomColor];
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
