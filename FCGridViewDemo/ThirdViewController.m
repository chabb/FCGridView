//
//  ThirdViewController.m
//  FCGridViewDemo
//
//  Created by François Chabbey on 08.04.15.
//  Copyright (c) 2015 François Chabbey. All rights reserved.
//


#import "ThirdViewController.h"
#import "UIColor+RandomColor.h"

@implementation ThirdViewController

{
    int step;
}
-(void)awakeFromNib {
    self.gridState = [ @[@[@0.5,@0.5],@[@0.5,@0.5],@[@0.4,@0.6],@[@0.3,@0.7],@[@0.1,@0.9]] mutableCopy];
    self.gridView.animationSpeed = 0.2;
    self.gridView.animationOptions = UIViewAnimationOptionCurveEaseInOut;
}

-(void)viewDidLoad {
    [super viewDidLoad];
     [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}
-(void)timerFired:(id)sender {
    if (step > 14) return;
    step++;
    int row = arc4random_uniform( (int )self.gridState.count);
    NSMutableArray *cells = self.gridState[row];
    int cell = arc4random_uniform((unsigned int)cells.count);
    // remove that after
   
    
    cells = [self.gridState[row] mutableCopy];
    NSInteger dividor= cells.count;
    float value = 0.2 + ( (float)  arc4random_uniform(20)/100.0); // randomize a bit
    
    float adjustValue = value/dividor;
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSNumber * number in cells) {
        [newArray addObject:@(number.floatValue - adjustValue)];
    }
    [newArray insertObject:[NSNumber numberWithFloat:value] atIndex:cell];
    self.gridState[row] = newArray;
    // update values of old Elements
    
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:cell inSection:row];
    [self.gridView insertElementAtIndexPath:ip animated:YES];
}

-(NSInteger)numberOfSectionsInGridView:(FCGridView *)gridView {
    return self.gridState.count;
}
-(NSInteger)gridView:(FCGridView *)gridView numberOfElementInSection:(NSInteger)section {
    return ((NSArray *) self.gridState[section]).count;
            
}
-(float)percentForElementAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger  row = indexPath.section;
    NSInteger  cell = indexPath.row;
    return  ((NSNumber *)((NSArray *) self.gridState[row])[cell]).floatValue;
}
-(float)percentForSection:(NSInteger)section {
    return 1.0/self.gridState.count;
}


-(UIView *)gridView:(FCGridView *)gridView viewForElementAtIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor randomColor]];
    return view;
}


@end
