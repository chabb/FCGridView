//
//  SecondViewController.m
//  FCGridViewDemo
//
//  Created by François Chabbey on 07.04.15.
//  Copyright (c) 2015 François Chabbey. All rights reserved.
//

#import "SecondViewController.h"
#import "FCDummyTableView.h"
#import "UIColor+RandomColor.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

-(void)awakeFromNib {
    self.gridState = @[ @[@0.3,@0.7],@[@0.2,@0.6,@0.2]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // give some color
    [self.gridView sectionAtIndex:0].backgroundColor = [UIColor grayColor];
    [self.gridView sectionAtIndex:1].backgroundColor = [UIColor blackColor];
    self.gridView.backgroundColor = [UIColor lightGrayColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSInteger)numberOfSectionsInGridView:(FCGridView *)gridView {
    return self.gridState.count;
}
-(NSInteger)gridView:(FCGridView *)gridView numberOfElementInSection:(NSInteger)section {
    return  ((NSArray *)self.gridState[section]).count;
}
-(float)percentForSection:(NSInteger)section {
    return 1.0/self.gridState.count;
}
- (float)percentForElementAtIndexPath:(NSIndexPath *)indexPath {
    return  ((NSNumber *) ((NSArray *)self.gridState[indexPath.section])[indexPath.row]).floatValue;
}
- (UIView *)gridView:(FCGridView *)gridView viewForElementAtIndexPath:(NSIndexPath *)indexPath {
    if ( (indexPath.section == 0 && indexPath.row == 1) || (indexPath.section ==1 && indexPath.row ==1)  ) {
        return [[FCDummyTableView alloc] init];
    }else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor randomColor];
        return view;
    }
    
}
@end
