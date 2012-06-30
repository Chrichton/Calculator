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
- (BOOL) userIsInTheMiddleOfEnteringANumber;

@end

@implementation CalculatorViewController
@synthesize history = _history;
@synthesize display = _display, brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain)
        _brain = [[CalculatorBrain alloc] init];
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSString *newNumber = [self.display.text stringByAppendingString:digit];
        if ([self.brain isValidNumber:newNumber])   
             self.display.text = newNumber;  
    }
    else {
        self.display.text = digit;
    }
    
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    
    double result =[self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]]; 
}

- (IBAction)clearPressed:(id)sender {
    self.display.text = @"0";
}

- (BOOL) userIsInTheMiddleOfEnteringANumber {
    return ![self.display.text isEqualToString:@"0"];
    
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
