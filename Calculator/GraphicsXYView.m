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

static NSString *scalefactorKey = @"GraphicsXYView.ScalefactorKey";
static NSString *originKey = @"GraphicsXYView.OriginKey";

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
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scalefactor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextBeginPath(context);
    
    for (int i = 0; i < rect.size.width * self.contentScaleFactor; i++) {
        double x = (i / self.contentScaleFactor - self.origin.x) / self.scalefactor;
        double y = -[self.datasource getValueForX:x] * self.scalefactor + self.origin.y;
        
        if(!isinf(y) && !isnan(y)) {
            if (i == 0) 
                CGContextMoveToPoint(context, i / self.contentScaleFactor, y);
            else    
                CGContextAddLineToPoint(context, i / self.contentScaleFactor, y);
        }
    }
                             
    CGContextStrokePath(context);
}

- (double) scalefactor {
    _scalefactor = [[NSUserDefaults standardUserDefaults] doubleForKey:scalefactorKey];
    if (_scalefactor == 0)
        _scalefactor = 1;

    return _scalefactor;
}

- (void) setScalefactor:(double)scalefactor {
    [[NSUserDefaults standardUserDefaults] setDouble:scalefactor forKey:scalefactorKey];

    _scalefactor = scalefactor;
    [self setNeedsDisplay];
}

- (CGPoint) origin {
    NSString *originString = [[NSUserDefaults standardUserDefaults] stringForKey:originKey];
    if (originString)
        _origin = CGPointFromString(originString);
    else 
        _origin = CGPointMake(150, 200);
                              
    return _origin;
}

- (void) setOrigin:(CGPoint)origin {    
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromCGPoint(origin) forKey:originKey];
    
    _origin = origin;
    [self setNeedsDisplay];
}

- (void) setDatasource:(id<GraphicsDatasource>)datasource {    
    _datasource = datasource;
    [self setNeedsDisplay];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scalefactor *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void) pan:(UIPanGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        CGPoint origin = self.origin;
        origin.x += translation.x;
        origin.y += translation.y;
        self.origin = origin;
        [gesture setTranslation:CGPointZero inView:self];
    }
}

@end
