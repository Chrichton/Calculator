//
//  GraphicsXYViewController.m
//  Calculator
//
//  Created by Heiko Goes on 12.07.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import "GraphicsXYViewController.h"
#import "GraphicsXYView.h"

@interface GraphicsXYViewController ()
@property (nonatomic) NSDictionary *data;
@end

@implementation GraphicsXYViewController
@synthesize graphicsView = _graphicsView;
@synthesize data = _data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Formel";
    self.graphicsView.scalefactor = 35;
    self.graphicsView.origin = CGPointMake(150, 200);
    self.graphicsView.datasource = self;

    [self.graphicsView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphicsView action:@selector(pinch:)]];
    [self.graphicsView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphicsView action:@selector(pan:)]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTap:)];
    tapRecognizer.numberOfTapsRequired = 3;
    [self.graphicsView addGestureRecognizer:tapRecognizer];
}

- (void)viewDidUnload
{
    [self setGraphicsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (double) getValueForX:(double)xValue {
    return sin(xValue);
}

- (void) tripleTap:(UITapGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint tappedPoint = [gesture locationInView:self.graphicsView];
        
        self.graphicsView.origin = tappedPoint;
    }
}

@end
