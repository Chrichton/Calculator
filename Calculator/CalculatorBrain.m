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

- (id) program {
    return self;
}

- (void) clear {
    _programStack = nil;
}

- (void) pushOperand:(double)operand {
    [self.programStack addObject: [NSNumber numberWithDouble:operand]];
}

//- (double) popOperand {
//    NSNumber *operandobject = [self.programStack lastObject];
//    if (operandobject)
//        [self.programStack removeLastObject];
//    
//    return [operandobject doubleValue];
//}

- (double) performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
    
    double result = 0;
    
    if ([operation isEqualToString:@"+"])
        result = [self popOperand] + [self popOperand];
    else if ([operation isEqualToString:@"*"])
        result = [self popOperand] * [self popOperand];  
    else if ([operation isEqualToString:@"-"])
        result = [self popOperand] - [self popOperand];  
    else if ([operation isEqualToString:@"/"])
        result = [self popOperand] / [self popOperand];  
    else if ([operation isEqualToString:@"sin"])
        result = sin(result);
    else  if ([operation isEqualToString:@"cos"])
        result = cos(result);
    else  if ([operation isEqualToString:@"sqrt"])
        result = sqrt(result);
    else  if ([operation isEqualToString:@"Pi"]) 
        result = M_PI;
    else  if ([operation isEqualToString:@"CHS"]) 
        result = [self popOperand] * (-1);
    [self pushOperand:result];
    
    return result;
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

- (NSMutableArray *)operandStack {
    if (!_programStack)
        _programStack = [[NSMutableArray alloc] init];
    
    return _programStack;
}

@end
