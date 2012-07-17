//
//  GraphicsXYViewController.m
//  Calculator
//
//  Created by Heiko Goes on 12.07.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import "GraphicsXYViewController.h"
#import "GraphicsXYView.h"
#import "CalculatorBrain.h"

@interface GraphicsXYViewController ()
@property (nonatomic, readonly) UIBarButtonItem *splitViewBarButtonItem;  
@end

@implementation GraphicsXYViewController
@synthesize toolbar = _toolbar, splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize graphicsView = _graphicsView, program = _program;

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
    self.title = [CalculatorBrain descriptionOfTheProgram:self.program];
    self.splitViewController.delegate = self;
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
    [self setToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) tripleTap:(UITapGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint tappedPoint = [gesture locationInView:self.graphicsView];
        
        self.graphicsView.origin = tappedPoint;
    }
}

- (double) getValueForX:(double)xValue {
    NSDictionary *variableValues = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:xValue], @"x", nil];
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
}

- (void) setProgram:(id)program {
    _program = program;
    [self.graphicsView setNeedsDisplay]; 
}

#pragma mark - Split view
/*
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Calculator", @"Calculator");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
*/
@end
