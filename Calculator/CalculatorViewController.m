//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Heiko Goes on 27.06.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;

@end

@implementation CalculatorViewController
@synthesize history = _history;
@synthesize display = _display, brain = _brain, userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;


- (CalculatorBrain *)brain {
    if (!_brain)
        _brain = [[CalculatorBrain alloc] init];
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSString *newNumber = [self.display.text stringByAppendingString:digit];
        if ([self.brain isValidNumber:newNumber]) {  
            self.display.text = newNumber; 
            self.history.text = [self.history.text stringByAppendingString:digit];
        }
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.history.text = [self.history.text stringByAppendingString:digit];
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    
    double result =[self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.history.text = [self.history.text stringByAppendingFormat:@"%@ = %@ ", sender.currentTitle, resultString];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]]; 
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.history.text = [self.history.text stringByAppendingString:@" "];
}

- (IBAction)clearPressed:(id)sender {
    [self.brain clear]; 
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.history.text = @"";
}

- (IBAction)backspacePressed:(id)sender {
    if (self.display.text.length < 2) 
        [self clearPressed:sender];
    else 
        self.display.text = [self.display.text substringToIndex:self.display.text.length -1];
}

- (IBAction)changeSignPressed:(id)sender {
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
