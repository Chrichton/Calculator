//
//  GraphicsXYView.m
//  Calculator
//
//  Created by Heiko Goes on 12.07.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import "GraphicsXYView.h"
#import "AxesDrawer.h"

@implementation GraphicsXYView
@synthesize scalefactor = _scalefactor, origin = _origin, datasource = _datasource;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:rect originAtPoint:CGPointZero scale:self.scalefactor];
    
    // forach x-Point on screen ; convert to coordinate -> double y value = [self.datasource getValueForX: x];
    // draw
}

-(double) scalefactor {
    if (_scalefactor == 0)
        _scalefactor = 1;

    return _scalefactor;
}

@end
