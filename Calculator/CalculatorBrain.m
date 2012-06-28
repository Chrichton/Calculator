//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Heiko Goes on 27.06.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end


@implementation CalculatorBrain
@synthesize operandStack = _operandStack;

- (void) pushOperand:(double)operand {
    [self.operandStack addObject: [NSNumber numberWithDouble:operand]];
}

- (double) popOperand {
    NSNumber *operandobject = [self.operandStack lastObject];
    if (operandobject)
        [self.operandStack removeLastObject];
    
    return [operandobject doubleValue];
}

- (double) performOperation:(NSString *)operation {
    double result = 0;
    
    if ([operation isEqualToString:@"+"])
        result = [self popOperand] + [self popOperand];
    else if ([operation isEqualToString:@"*"])
        result = [self popOperand] * [self popOperand];  
    else if ([operation isEqualToString:@"-"])
        result = [self popOperand] - [self popOperand];  
    else if ([operation isEqualToString:@"/"])
        result = [self popOperand] / [self popOperand];  
    
    [self pushOperand:result];
    
    return result;
}

- (double) evalFunction:(NSString *)function {
    double result = [self popOperand];
    
    if ([function isEqualToString:@"sin"])
        result = sin(result);
    else  if ([function isEqualToString:@"cos"])
        result = cos(result);
    else  if ([function isEqualToString:@"sqrt"])
        result = sqrt(result);

    [self pushOperand:result];
    return result;
}

- (double) pushConstant:(NSString *)constant {
    double result = 0;
    
    if ([constant isEqualToString:@"Pi"]) {
        result = 3.1415;
        [self pushOperand:result];        
    }
    
    return result;
}

- (NSMutableArray *)operandStack {
    if (!_operandStack)
        _operandStack = [[NSMutableArray alloc] init];
    
    return _operandStack;
}

@end
