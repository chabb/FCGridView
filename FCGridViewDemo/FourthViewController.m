//
//  FourthViewController.m
//  FCGridViewDemo
//
//  Created by François Chabbey on 08.04.15.
//  Copyright (c) 2015 François Chabbey. All rights reserved.
//

#import "FourthViewController.h"
#import "FCGridView.h"
#import "UIColor+RandomColor.h"

@implementation FourthViewController

-(void)awakeFromNib {
    self.gridState = [ @[@[@0.2,@0.2,@0.5],@[@0.5,@0.5],@[@0.3,@0.1,@0.6],@[@0.3,@0.4,@0.3],@[@0.1,@0.9]] mutableCopy];
    self.gridView.animationSpeed = 0.15;
    self.gridView.animationOptions = UIViewAnimationOptionCurveEaseInOut;
   
}
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.gridView sectionAtIndex:0].backgroundColor = [UIColor blackColor];
    [self.gridView sectionAtIndex:1].backgroundColor = [UIColor darkGrayColor];
    [self.gridView sectionAtIndex:2].backgroundColor = [UIColor grayColor];
    [self.gridView sectionAtIndex:3].backgroundColor = [UIColor lightGrayColor];
    [self.gridView sectionAtIndex:4].backgroundColor = [UIColor whiteColor];
    self.gridView.backgroundColor = [UIColor darkTextColor];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.gridState = [ @[@[@0.7,@0.25,@0.05],@[@0.1,@0.9],@[@0.3333,@0.3333,@0.3333],@[@0.1,@0.85,@0.05],@[@0.5,@0.5]] mutableCopy];
        [self.gridView updateLayoutAnimated:NO];
    });
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
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor randomColor]];
    return view;
}
- (CGFloat)gutterSize {
    return 12.5;
}


@end
