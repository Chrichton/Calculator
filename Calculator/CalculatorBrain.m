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
    + (NSOrderedSet *) operators;
@end


@implementation CalculatorBrain
@synthesize programStack = _programStack;

static NSOrderedSet *_operators;

+ (NSOrderedSet *) operators {
    if (!_operators)
        _operators = [[NSOrderedSet alloc] initWithObjects:@"+", @"*", @"-", @"/", @"sin", @"cos", @"sqrt", @"Pi", @"CHS", nil];
  
    return _operators;
}

+ (BOOL)isOperation:(NSString *)operation {
    return [self.operators indexOfObject:operation] != NSNotFound;  
}

+ (BOOL) isVariable:(NSString *) name {
    return [self.operators indexOfObject:name] == NSNotFound;
}

+ (id) popStack: (NSMutableArray *) stack {
    id topOfStack = [stack lastObject];
    if (topOfStack)
        [stack removeLastObject];
    
    return topOfStack;
}

+ (NSString *) descriptionOfStack:(NSMutableArray *)stack{
    id topOfStack = [self popStack:stack];
    
    if ([self isOperation:topOfStack]) {
        NSString *left = [self descriptionOfStack:stack];
        NSString *right = [self descriptionOfStack:stack];
        return [NSString stringWithFormat:@"(%@ %@ %@)", left, topOfStack, right];       
    }
    else {
        return [topOfStack stringValue];
    }
}

+ (NSString *)descriptionOfTheProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass: [NSArray class]])
        stack = [program mutableCopy];

    NSString *result = [self descriptionOfStack:stack];
    if ([[result substringToIndex:1] isEqualToString:@"("]) {
        NSRange range;
        range.location = 1;
        range.length = [result length] - 2;
        result = [result substringWithRange:range];
    }
        
    return result;    
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass: [NSArray class]])
        stack = [program mutableCopy];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
        return[obj isKindOfClass:[NSString class]] && [self isVariable:obj]; 
    }];
                                
    [stack filterUsingPredicate:predicate];
    return [stack count] == 0 ? nil : [[NSSet alloc] initWithArray: stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass: [NSArray class]])
        stack = [program mutableCopy];

    for (int i = 0; i < [stack count]; i++) {
        id element = [stack objectAtIndex:i];
        if ([element isKindOfClass:[NSString class]]) {
            if ([self isVariable:element]) {
                NSNumber *value = [variableValues objectForKey: element];
                if (!value)
                    value = [NSNumber numberWithInt:0];
                [stack replaceObjectAtIndex:i withObject:value];
            }
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariableValues:nil];
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
    if (range.location != NSNotFound) {
        range = [[number substringFromIndex:range.location +1] rangeOfString:@"."]; // No Lenght-Check neccessary, because string null terminated
        if (range.location != NSNotFound)
            return NO;
    }
        
    return YES;
}

- (id) program {
    return [self.programStack copy];
}

- (NSMutableArray *)programStack {
    if (!_programStack)
        _programStack = [[NSMutableArray alloc] init];
    
    return _programStack;
}

@end
