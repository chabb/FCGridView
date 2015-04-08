//
//  FCDummyTableView.m
//  FCGridViewDemo
//
//  Created by François Chabbey on 07.04.15.
//  Copyright (c) 2015 François Chabbey. All rights reserved.
//

#import "FCDummyTableView.h"

@implementation FCDummyTableView


-(instancetype)init {
    self = [super init];
    self.delegate = self;
    self.dataSource = self;
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
};
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"DUMMY TABLE VIEW";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DUMMYTVC"];
    cell.textLabel.text = [NSString stringWithFormat:@"CELL %li/%li",indexPath.section,indexPath.row];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
