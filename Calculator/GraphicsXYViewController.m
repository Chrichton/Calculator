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
    self.graphicsView.origin = CGPointMake(100, 190);
    self.graphicsView.datasource = self;

    [self.graphicsView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphicsView action:@selector(pinch:)]];
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
    return xValue;
}

@end
