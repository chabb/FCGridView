//
//  UIGridView.m
//  GridViewController
//
//  Created by François Chabbey on 04.04.15.
//  Copyright (c) 2015 François Chabbey. All rights reserved.
//

#import "FCGridView.h"

#define __DEBUG__

@implementation FCGridView
{
    NSInteger _cachedSections;
    NSInteger _cachedGutterSpace;
    NSInteger _cachedTotalGutterSpace;
    NSArray* sectionsPercent;
    NSMutableArray* elementsPercent;
    NSMutableDictionary *views; // dictionnary made of NSPointerArray with [NSValue ..valueWithNonRetainedObject..]
    NSPointerArray* sectionsViews;
    
    // State variable to ensure proper layout
    __weak UIView *sectionToBeRemoved;
    __weak UIView *elementToBeRemoved;
    
    
    // TODO add a bool struct to cache all ..respondTo.. state
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) [self commonInit];
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame {
    self = [super  initWithFrame:frame ];
    if (self) [self commonInit];
    return self;
}

-(void)commonInit {
    self.animationSpeed = 1.0;
    self.animationDelay = 0.0;
    self.animationOptions = UIViewAnimationCurveEaseIn;
    
}

-(NSInteger)computeGutters {
    int outerGutter = 2;
    NSInteger innerGutter = _cachedSections-1;
    NSInteger totalGutter = innerGutter + outerGutter;
    NSInteger totalGutterSpace =  totalGutter*_cachedGutterSpace;
    return totalGutterSpace;
}
-(void)collectPercentForSections {
    sectionsPercent = [NSArray array];
    float total = 0;
    for(int i=0;i<_cachedSections;i++) {
        NSNumber *n = [NSNumber numberWithFloat:[self.delegate  percentForSection:i]];
        sectionsPercent = [sectionsPercent arrayByAddingObject:n];
        total = total + [n floatValue];
        NSAssert(total <= 1.1, @"Total percentage  of sections is > 1 %f",total);
    }
}
-(void)collectPercentForElementsInAllSection{
    elementsPercent = [NSMutableArray arrayWithCapacity:_cachedSections];
    for(int i=0;i<_cachedSections;i++) {
        NSInteger nElements = [self.dataSource gridView:self numberOfElementInSection:i];
        NSArray *percents = [NSArray array];
        float total = 0;
        for (int j=0;j<nElements;j++) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:j inSection:i];
            float percent = [self.delegate percentForElementAtIndexPath:ip];
            total = total + percent;
            NSAssert(total <= 1.1, @"Total percentage of element is > 1 %f",total);
            percents = [percents arrayByAddingObject:[NSNumber numberWithFloat:percent]];
        }
        elementsPercent[i] = percents;
    }
}
-(void)addViews {
    sectionsViews = [NSPointerArray weakObjectsPointerArray];
    views = [[NSMutableDictionary alloc] init];
    bool hasCustomViews = [self.dataSource respondsToSelector:@selector(gridView:viewForElementAtIndexPath:)];
    
    for (int i=0;i<_cachedSections;i++)
    {
        UIView *view = [[UIView alloc] init];
        NSUInteger numberOfElements = ((NSArray *)elementsPercent[i]).count;
        NSPointerArray *array = [NSPointerArray weakObjectsPointerArray];
       
        for (int j=0;j<numberOfElements;j++ )
        {
            UIView *_view;
            if (hasCustomViews) {
                _view = [self.dataSource gridView:self viewForElementAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            } else {
                _view = [[UIView alloc] init];
            }
            [view addSubview:_view];
            [array addPointer:(__bridge void *)(_view)];
        }
        [self addSubview:view];
        [sectionsViews addPointer:(__bridge void *)(view)];
        [views setObject:array forKey:[NSValue valueWithNonretainedObject:view]];
    }
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    UIView *superView = self.superview;
    float totalWidth  = superView.frame.size.width;
    float totalHeight = superView.frame.size.height;
    float startX = 0 + _cachedGutterSpace;
    float startY = startX;
    float availableWidth = totalWidth-(_cachedGutterSpace*2);
    float availabeHeight = totalHeight-_cachedTotalGutterSpace;
    int indexSection = 0;
    int indexElement = 0;
    
    // 1. iterate over sections
    for (UIView* section in sectionsViews) {
        NSPointerArray *arrayOfElements= [views objectForKey:[NSValue valueWithNonretainedObject:section]];

        // layout section
        CGFloat height = availabeHeight* ((NSNumber * )sectionsPercent[indexSection]).floatValue;
        section.frame = CGRectMake(startX, startY, availableWidth, height);
        CGFloat elementStartX = _cachedGutterSpace;
        CGFloat elementStartY = _cachedGutterSpace;
        CGFloat elementAvailableWidth = availableWidth-(_cachedGutterSpace*2)-((arrayOfElements.count-1)*_cachedGutterSpace);
       
       
        CGFloat elementHeight = height-(_cachedGutterSpace*2);
        if(sectionToBeRemoved==section) elementHeight = 0;
        for (UIView* element in arrayOfElements) {
#ifdef __DEBUG__
            NSLog(@"Asking for width... element %i of section %i",indexElement,indexSection);
#endif
            CGFloat width = elementAvailableWidth*((NSNumber *) elementsPercent[indexSection][indexElement]).floatValue ;
            
            element.frame = CGRectMake(elementStartX, elementStartY, width, elementHeight);
            //NSLog(@"FRAME :%@",NSStringFromCGRect(element.frame));
            indexElement++;
#ifdef __DEBUG__
            NSLog(@"Layout element%@ %@",elementToBeRemoved,element);
#endif
            if (elementToBeRemoved !=element)
                elementStartX = elementStartX + width+_cachedGutterSpace;
            else {
                elementStartX = elementStartX + width;
                elementAvailableWidth = elementAvailableWidth + _cachedGutterSpace*2; // as element is still here, we must give back the space occupied by the gutter
            }
        }
        if (sectionToBeRemoved != section)
            startY = startY + height + _cachedGutterSpace;
        else
            startY = startY + height;
        
        indexSection++;
        indexElement = 0;
    }
}
-(void)_reloadData {
    _cachedGutterSpace = [self.delegate gutterSize];
    _cachedSections = [self.dataSource numberOfSectionsInGridView:self];
    _cachedTotalGutterSpace = [self computeGutters];
 
    [self collectPercentForSections];
    [self collectPercentForElementsInAllSection];
}


-(void)reloadData {
    [self _reloadData];
    [self addViews];
    [self setNeedsLayout];
}

-(void)deleteElementAtIndexPath:(NSIndexPath *)indexPath {
    [self collectPercentForElementsInAllSection];
    NSInteger section =indexPath.section;
    NSInteger cell = indexPath.row;
    NSMutableArray *_sectionsPercent = [NSMutableArray arrayWithArray:elementsPercent[section]];
    NSArray *originalSectionPercentArray = [NSArray arrayWithArray:_sectionsPercent];
    [_sectionsPercent insertObject:[NSNumber numberWithFloat:0.0]  atIndex:cell];
    elementsPercent[section] = _sectionsPercent;
    UIView *sectionView = [sectionsViews pointerAtIndex:section];
    NSPointerArray *elementsView  = [views objectForKey:[NSValue valueWithNonretainedObject:sectionView]];
    elementToBeRemoved = [elementsView pointerAtIndex:cell];

    [self performAnimations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        elementsPercent[section] = originalSectionPercentArray;
        [elementsView  removePointerAtIndex:cell];
        //[elementToBeRemoved removeFromSuperview];
    }];
    
}
-(void)insertElementAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section =indexPath.section;
    NSInteger cell = indexPath.row;
    //check if indexPath is alright;
    NSAssert(section < _cachedSections,@"Section %li  must be less than number of section %li",section,_cachedSections);
    
    // This is useless
    //NSMutableArray *_sectionsPercent = [NSMutableArray arrayWithArray:elementsPercent[section]];
    //NSArray *originalSectionPercentArray = [NSArray arrayWithArray:_sectionsPercent];
    //[_sectionsPercent insertObject:[NSNumber numberWithFloat:0.0]  atIndex:cell];
    //elementsPercent[section] = _sectionsPercent;
    NSLog(@"Start inserting");
    UIView *sectionView = [sectionsViews pointerAtIndex:section];
    CGRect sectionFrame = sectionView.frame;
    UIView *newView = [self.dataSource gridView:self viewForElementAtIndexPath:indexPath];
    
    //find starting X
    // TODO All the calculation stuff can be extracted in a dedicated method
    CGFloat startX = 0;
    if (cell > 0)
    {
        UIView *viewBefore = [self viewForIndexPath:[NSIndexPath indexPathForRow:cell-1 inSection:section]];
        CGRect frame = viewBefore.frame;
        startX =  frame.size.width+frame.origin.x + _cachedGutterSpace;
    }
    //END of calcaulation
    
    CGRect newViewFrame = CGRectMake(startX, _cachedGutterSpace, 0, sectionFrame.size.height-2*_cachedGutterSpace);
    newView.frame = newViewFrame;
    NSLog(@"Updating views tree..");
    [sectionView insertSubview:newView atIndex:cell];
    NSLog(@"Done..");
    NSPointerArray *elementsView  = [views objectForKey:[NSValue valueWithNonretainedObject:sectionView]];
    [elementsView insertPointer:(__bridge void *)(newView) atIndex:cell];
    [self collectPercentForElementsInAllSection];
    
    [self performAnimations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        
    }];
}


-(void)deleteSection:(NSInteger)section {
    NSAssert(section<sectionsViews.count,@"Section to delete is greater than number of sections");
    _cachedSections = _cachedSections -1;
    _cachedTotalGutterSpace = [self computeGutters];
    [self collectPercentForSections];
    NSMutableArray *_sectionsPercent = [NSMutableArray arrayWithArray:sectionsPercent];
    [_sectionsPercent insertObject:[NSNumber numberWithFloat:0.0] atIndex:section];
    sectionsPercent = _sectionsPercent;
#ifdef __DEBUG__
    NSLog(@"COUNT %lu",(unsigned long)sectionsPercent.count);
#endif
    sectionToBeRemoved = [sectionsViews pointerAtIndex:section];
    
    [self performAnimations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //pack dico
        NSValue *key = [NSValue valueWithNonretainedObject:sectionToBeRemoved];
        [views removeObjectForKey:key];
        //
        [sectionToBeRemoved removeFromSuperview];
        //pack sections
        [sectionsViews removePointerAtIndex:section]; // fout la merde
        
        // Try to make a copy for later usage instead of calling these methods
        [self collectPercentForSections];
        [self collectPercentForElementsInAllSection];
        [self layoutSubviews];
    }];
}

-(void)updateLayout {
    [self collectPercentForElementsInAllSection];
    [self performAnimations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:nil];
}



-(UIView *)viewForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSAssert(section<_cachedSections,@"Section %li is higher that number of sections %li",(long)section,(long)_cachedSections );
    NSInteger cell = indexPath.row;
    UIView *sectionView = [sectionsViews pointerAtIndex:section];
    NSPointerArray *array = [views objectForKey: [NSValue valueWithNonretainedObject:sectionView]];
                      
    NSAssert(section<_cachedSections,@"Element %li is higher that number of element %lu",(long)cell,(unsigned long)array.count );
    return [array pointerAtIndex:cell];
}
-(UIView *)sectionAtIndex:(NSInteger)section {
    NSAssert(section<_cachedSections,@"Section %li is higher that number of sections %li",(long)section,(long)_cachedSections );
    return [sectionsViews pointerAtIndex:section];
    
}
-(void)performAnimations:(void (^)(void) )animations completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:self.animationSpeed delay:self.animationDelay options:self.animationOptions animations:animations completion:completion];
    
}


@end
