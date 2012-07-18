//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Heiko Goes on 27.06.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphicsXYViewController.h"

@interface CalculatorViewController ()
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) NSDictionary *testVariableValues;
@property (nonatomic) BOOL lineMode;
@end

@implementation CalculatorViewController
@synthesize history = _history;
@synthesize display = _display, brain = _brain, userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber, 
    testVariableValues = _testVariableValues, lineMode = _lineMode;

- (CalculatorBrain *)brain {
    if (!_brain)
        _brain = [[CalculatorBrain alloc] init];
    
    return _brain;
}

- (void) runProgram {
    double result = [CalculatorBrain runProgram:[self.brain program] usingVariableValues:self.testVariableValues];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.history.text = [CalculatorBrain descriptionOfTheProgram:[self.brain program]];    
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSString *newNumber = [self.display.text stringByAppendingString:digit];
        if ([self.brain isValidNumber:newNumber]) {  
            self.display.text = newNumber; 
            self.history.text = [CalculatorBrain descriptionOfTheProgram:[self.brain program]];
        }
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.history.text = [CalculatorBrain descriptionOfTheProgram:[self.brain program]];
    }
}

- (IBAction)operationOrVariablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    
    [self.brain pushOperationOrVariable:sender.currentTitle]; 
    [self runProgram];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]]; 
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.history.text = [CalculatorBrain descriptionOfTheProgram:[self.brain program]];
}

- (IBAction)clearPressed:(id)sender {
    [self.brain clear]; 
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.history.text = [CalculatorBrain descriptionOfTheProgram:[self.brain program]];
}

- (IBAction)changeSignPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([[self.display.text substringToIndex:1] isEqualToString:@"-"]) 
            self.display.text = [self.display.text substringFromIndex:1];
        else
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        
        self.history.text = [CalculatorBrain descriptionOfTheProgram:[self.brain program]];
    } else
        [self operationOrVariablePressed:sender];
}

- (IBAction)undoPressed:(id)sender {
    if (self.display.text.length < 2) {
        self.userIsInTheMiddleOfEnteringANumber = NO;
        [self.brain removeLastEntry];
        [self runProgram];
    }
    else 
        self.display.text = [self.display.text substringToIndex:self.display.text.length -1];
}

- (IBAction)graphPressed:(id)sender {
    if (self.splitViewController) {
        GraphicsXYViewController *graphicsContoller = self.splitViewController.viewControllers.lastObject;
        graphicsContoller.program = self.brain.program;
        graphicsContoller.graphicsView.lineMode = self.lineMode;
    }
}

- (IBAction)lineModeChanged:(UISwitch *)sender {
    self.lineMode = sender.on;
    if (self.splitViewController) {
        GraphicsXYViewController *graphicsContoller = self.splitViewController.viewControllers.lastObject;
        graphicsContoller.graphicsView.lineMode = self.lineMode;
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"graphics"]) {
        GraphicsXYViewController *controller = [segue destinationViewController];
        controller.program = self.brain.program;
        controller.graphicsView.lineMode = self.lineMode;
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return self.splitViewController != nil;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.splitViewController.presentsWithGesture = NO;
    self.lineMode = YES;
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}

@end
