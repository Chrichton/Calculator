//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Heiko Goes on 27.06.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
- (double) performOperation:(NSString *)operation;
- (BOOL) isValidNumber:(NSString *)number;
- (void) clear;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfTheProgram:(id)program;

@end
