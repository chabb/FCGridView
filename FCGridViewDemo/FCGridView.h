//
//  UIGridView.h
//  GridViewController
//
//  Created by François Chabbey on 04.04.15.
//  Copyright (c) 2015 François Chabbey. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 FCGridView is NOT THREAD-SAFE, all insertions/deletions calls must be made from the same thread
 
 Note that when you remove/insert elements or sections, it is your code responsibility to provide good percentage, FCGridView will not make any assumptions about what you want to achieve.
 
 If you just change the percentage of the views, you can call reloadData
*/

@class FCGridView;
@protocol GridViewDelegate <NSObject>
@required
// Note that a gutter will be used between the superview and the section, and between section and element
-(CGFloat )gutterSize;
/**
 An assertion will be raised if the total of percent is > 1.0
*/
-(float) percentForSection:(NSInteger)section;
-(float) percentForElementAtIndexPath:(NSIndexPath *)indexPath;
@optional
@end

@protocol GridViewDataSource <NSObject>
@required
- (NSInteger)numberOfSectionsInGridView:(FCGridView *)gridView;
- (NSInteger)gridView:(FCGridView *)gridView numberOfElementInSection:(NSInteger)section;
@optional
/**
 Default implementation returns a dummy view
 */
- (UIView *) gridView:(FCGridView *)gridView viewForElementAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface FCGridView : UIView
/**
 Datasource is used to define the number of section, and elements in sections. Data source provides also the view for each element
*/
@property (nonatomic,weak) id dataSource;
/**
 Delegate is used to define the appearance of the different elements
*/
@property (nonatomic,weak) id delegate;


/**
 Timing of animations, default to 1.0
*/
@property (nonatomic,assign) NSTimeInterval animationSpeed;
/**
 Delay of animation, default to 0.0;
 */
@property (nonatomic,assign) NSTimeInterval animationDelay;
/**
 Option of animation, defaut to easein
 */
@property (nonatomic,assign) UIViewAnimationOptions animationOptions;



/**
 Delete an entire section, and remove it from the superview
 Deletion is animated. YOU MUST ENSURE THAT DATASOURCE AND DELEGATE METHODDS PROVIDE
 CORRECT VALUES, OR THE OVERALL LAYOUT WILL BREAK.

 */
-(void)deleteSection:(NSInteger)section animated:(BOOL)animated;
/**
 Delete an element from a section, and remove it from the section.
 Deletion is animated. YOU MUST ENSURE THAT DATASOURCE AND DELEGATE METHODDS PROVIDE
 CORRECT VALUES, OR THE OVERALL LAYOUT WILL BREAK.
*/
-(void)deleteElementAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
/**
 Add an element to a section.
 Insertion is animate. YOU MUST ENSURE THAT DATASOURCE AND DELEGATE METHODDS PROVIDE
 CORRECT VALUES, OR THE OVERALL LAYOUT WILL BREAK.
*/
-(void)insertElementAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

/** update the layout
CALL THIS METHOD ONLY IF THE GRID HAS THE SAME NUMBER OF ROW AND CELLS PER ROW
*/
-(void)updateLayoutAnimated:(BOOL)animated;
/**
 Returns the element view for a given indexpath. An assertion is raised if indexpath is incorrect
*/
-(UIView *)viewForIndexPath:(NSIndexPath *)indexPath;
/**
 Returns the section view for a given section. An assertion is raised if the section does not exist
*/
-(UIView *)sectionAtIndex:(NSInteger)section;


-(void)reloadData;


@end
