//
//  ViewController.h
//  GridViewController
//
//  Created by François Chabbey on 04.04.15.
//  Copyright (c) 2015 François Chabbey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCGridView.h"


@interface GridViewController : UIViewController<GridViewDataSource,GridViewDelegate>
@property (nonatomic,strong) FCGridView* gridView;

@end

