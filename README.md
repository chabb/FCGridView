# FCGridView

**FCGridView is a UIView subclass that allows you to construct grid layout easily.**



##Overview

FCGridView mimicks UITableView : you provides all the needed datas via data source and delegate methods. You typically use xib to provide custom view or instantiate your view in code. FCGridView tries to don't get in your way and lets you use any kind of view. 

FCGridView allows you to construct custom layout very easily and tries to be as fast and efficient as possible (only weak references are used, some stuff are cached, and so on). It has zero dependencies and can be integrated very easily in your project.

All views are accessible and customizable; the implementation try to be as robust as possible., but an assertion will be raised is something go wrong (again, like in UITableView). Typically, if the sum of percent exceed 1.0, an assertion will be raised. Due to the nature of float, a small tolerance margin of 0.1 is used, to avoid unwanted crash.

As all layout happens in layoutSubviews, rotation are handled automatically. Further release will include specific values for gutter and views repartition in landscape mode.



## Requirments

* iOS >= 7.0


##Documentation 

Take a look at the header file for detailed documentation.

**A cell is represented via the NSIndexPath. There is a small mismatch, as indexpath section corresponds to a row, and row correspond to a cell position in a row**


##Example

An example application is included. 

##How to use it

* Instantiate an FCGridView
* Configure it
	* Animation speeds and easing curve are configurable
* Write datasource and delegate methods (see below)
* Assign delegate and datasource
* Call `[gridView reloadData]`
* Call insertion and deletion methods as you add or remove views

**Before calling insertion/deletion methods, you must ensure that your datasource methods will return correct values. E.g, if you insert a new section, and that before the insertion, the number of section was 3, you must ensure that your datasource method `-(NSInteger)numberOfSectionsInGridView:(FCGridView *)gridView` returns 3 before you call the insertion method. Failing to do that will raise an assertion or break the layout.**

**The updateLayout method can only be called when the grid struction has not changed (e.g the grid has the same number of rows, and same number of cells per row)**


Here is a minimal implementation:


```

@implementation SomeViewController
{
   
}
-(void)viewDidLoad {
	FCGridView *gv = [[FCGridView alloc] init];
	[self addSubview:gv];
	gv.dataSource = self;
	gv.delegate = self;
	[gv reloadData];
}
-(NSInteger)numberOfSectionsInGridView:(FCGridView *)gridView {
	return 2;
}
-(float)percentForSection:(NSInteger)section {
	return 0.5;
}
-(float)percentForElementAtIndexPath:(NSIndexPath *)indexPath {
  	return 0.5;
}
-(NSInteger)gridView:(FCGridView *)gridView numberOfElementInSection:(NSInteger)section {
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
````




Additions and swift versions are welcome.

##Examples

A sample project is included. 

* Tab one demonstrates deletion of subviews
* Tab two demonstrates how to integrate custom views.
* Tab three demonstration insertion of subviews

##TODO 

Add a specific gutter for elements inside section.
Add gutter for specific orientation
Write a category for NSIndexPath in order to make things clearer
Add an updateLayout method that works everytime


## Tests

Must be written

## Authors

GridView was created by François Chabbey

## License

Copyright (c) 2015, François Chabbey. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

3. Neither the name of The Iconfactory nor the names of its contributors may
be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE ICONFACTORY BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
