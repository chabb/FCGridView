//
//  FirstViewController.m
//  FCGridViewDemo
//
//  Created by François Chabbey on 07.04.15.
//  Copyright (c) 2015 François Chabbey. All rights reserved.
//

#import "FirstViewController.h"

#define __ANIMATED__ YES


@interface FirstViewController ()

@end

@implementation FirstViewController


-(void)awakeFromNib {
    self.gridState = [ @[@[@0.3,@0.3,@0.4],@[@0.2,@0.2,@0.2,@0.2,@0.2],@[@0.7,@0.3],@[@0.2,@0.2,@0.2,@0.1,@0.3],@[@0.8,@0.15],@[@0.2,@0.02,@0.1,@0.1,@0.05,@0.4,@0.1]] mutableCopy];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor darkGrayColor];
    [self.gridView sectionAtIndex:0].backgroundColor = [UIColor grayColor];
    [self.gridView sectionAtIndex:1].backgroundColor = [UIColor lightGrayColor];
    [self.gridView sectionAtIndex:2].backgroundColor = [UIColor grayColor];
    [self.gridView sectionAtIndex:3].backgroundColor = [UIColor lightGrayColor];
    [self.gridView sectionAtIndex:4].backgroundColor = [UIColor blackColor];
    [self.gridView sectionAtIndex:5].backgroundColor = [UIColor whiteColor];
    self.gridView.animationSpeed = 0.25;
    self.gridView.animationOptions = UIViewAnimationCurveEaseInOut;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];

}

-(void)timerFired:(id)sender {
    // stop timer
    if (self.gridState.count == 1) { return ;}
    if (self.gridState.count==2) {
        NSInteger row = 1;
        NSMutableArray *cells = [self.gridState[row] mutableCopy];
        if (cells.count == 0) {
            [self.gridState removeObjectAtIndex:1];
            [self.gridView deleteSection:1 animated:__ANIMATED__];
            return;
        }
        NSInteger indexToRemove = arc4random() % cells.count;
        NSLog(@"will remove %li ON %li",(long)indexToRemove,cells.count);
        NSIndexPath *ip = [NSIndexPath indexPathForRow:indexToRemove inSection:row];
        [cells removeObjectAtIndex:indexToRemove];
        self.gridState[row] = cells;
        [self.gridView deleteElementAtIndexPath:ip animated:__ANIMATED__];
        return;
    }
    // update structure
    NSInteger index =   arc4random() % (self.gridState.count-1); // always keep last row
    NSLog(@"will remove %li",(long)index);
    [self.gridState removeObjectAtIndex:index];
    [self.gridView deleteSection:index animated:__ANIMATED__];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
