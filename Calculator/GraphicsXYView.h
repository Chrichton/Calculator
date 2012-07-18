//
//  GraphicsXYView.h
//  Calculator
//
//  Created by Heiko Goes on 12.07.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphicsXYView;

@protocol GraphicsDatasource <NSObject>

-(double) getValueForX: (double) xValue;

@end

@interface GraphicsXYView : UIView

@property (nonatomic, weak) id<GraphicsDatasource> datasource;
@property (nonatomic) double scalefactor;
@property (nonatomic) CGPoint origin;
@property (nonatomic) BOOL lineMode;

-(void) pinch:(UIPinchGestureRecognizer *)gesture;
-(void) pan:(UIPanGestureRecognizer *)gesture;

@end
