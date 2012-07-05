//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Heiko Goes on 27.06.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end


@implementation CalculatorBrain
@synthesize programStack = _programStack;

+ (NSString *)descriptionOfTheProgram:(id)program {
    return nil;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass: [NSMutableArray class]])
        stack = [program mutableCopy];
    
    return [self popOperandOffStack: stack];
}

+ (double) popOperandOffStack: (NSMutableArray *) stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) 
        [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
        result = [topOfStack doubleValue];
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"])
            result = [self popOperandOffStack: stack] + [self popOperandOffStack: stack];
        else if ([operation isEqualToString:@"*"])
            result = [self popOperandOffStack: stack] * [self popOperandOffStack: stack];  
        else if ([operation isEqualToString:@"-"])
            result = [self popOperandOffStack: stack] - [self popOperandOffStack: stack];  
        else if ([operation isEqualToString:@"/"])
            result = [self popOperandOffStack: stack] / [self popOperandOffStack: stack];  
        else if ([operation isEqualToString:@"sin"])
            result = sin(result);
        else  if ([operation isEqualToString:@"cos"])
            result = cos(result);
        else  if ([operation isEqualToString:@"sqrt"])
            result = sqrt(result);
        else  if ([operation isEqualToString:@"Pi"]) 
            result = M_PI;
        else  if ([operation isEqualToString:@"CHS"]) 
            result = [self popOperandOffStack: stack] * (-1);
    }
        
    return result;
}

- (void) clear {
    _programStack = nil;
}

- (void) pushOperand:(double)operand {
    [self.programStack addObject: [NSNumber numberWithDouble:operand]];
}

- (double) performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (BOOL) isValidNumber:(NSString *)number
{
    if (!number)
        return NO;
    
    if (number.length > 1 && [[number substringToIndex:2] isEqualToString:@"00"])
        return NO; 
                  
    if (number.length > 2 && [[number substringToIndex:3] isEqualToString:@"-00"])
        return NO;     
        
    NSRange range = [number rangeOfString:@"."];
    if (range.length == 1) {
        range = [[number substringFromIndex:range.location +1] rangeOfString:@"."]; // No Lenght-Check neccessary, because string null terminated
        if (range.length == 1)
            return NO;
    }
        
    return YES;
}

- (id) program {
    return [self.programStack copy];
}

- (NSMutableArray *)operandStack {
    if (!_programStack)
        _programStack = [[NSMutableArray alloc] init];
    
    return _programStack;
}

@end
