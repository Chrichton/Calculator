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
static NSOrderedSet *_binaryOperators;
static NSOrderedSet *_unaryOperators;
static NSOrderedSet *_noOperandOperators;

+ (NSOrderedSet *) operators {
    if (!_operators)
        _operators = [[NSOrderedSet alloc] initWithObjects:@"+", @"*", @"-", @"/", @"sin", @"cos", @"sqrt", @"Pi", @"CHS", nil];
  
    return _operators;
}

+ (NSOrderedSet *) binaryOperators {
    if (!_binaryOperators)
        _binaryOperators = [[NSOrderedSet alloc] initWithObjects:@"+", @"*", @"-", @"/", nil];
    
    return _binaryOperators;
}

+ (NSOrderedSet *) unaryOperators {
    if (!_unaryOperators)
        _unaryOperators = [[NSOrderedSet alloc] initWithObjects:@"sin", @"cos", @"sqrt", @"CHS", nil];
    
    return _unaryOperators;
}

+ (NSOrderedSet *) noOperandOperators {
    if (!_noOperandOperators)
        _noOperandOperators = [[NSOrderedSet alloc] initWithObjects:@"Pi", nil];
    
    return _noOperandOperators;
}

+ (BOOL) isVariable:(id) name {
    return [name isKindOfClass:[NSString class]] && [self.operators indexOfObject:name] == NSNotFound;
}

+ (id) popStack: (NSMutableArray *) stack {
    id topOfStack = [stack lastObject];
    if (topOfStack)
        [stack removeLastObject];
    
    return topOfStack;
}

+ (NSMutableArray *) stackFromProgram: (id) program {
    NSMutableArray *stack;
    if ([program isKindOfClass: [NSArray class]])
        stack = [program mutableCopy];
    return stack;
}

+ (NSString *) descriptionOfStack:(NSMutableArray *)stack{
    id topOfStack = [self popStack:stack];
    
    if ([[self binaryOperators] indexOfObject:topOfStack] != NSNotFound) {
        NSString *left = [self descriptionOfStack:stack];
        NSString *right = [self descriptionOfStack:stack];
        return [NSString stringWithFormat:@"(%@ %@ %@)", left, topOfStack, right];       
    }
    else if ([[self unaryOperators] indexOfObject:topOfStack] != NSNotFound) {
        NSString *right = [self descriptionOfStack:stack];
        return [NSString stringWithFormat:@"%@(%@)", topOfStack, right];       
    } else if ([[self noOperandOperators] indexOfObject:topOfStack] != NSNotFound) 
        return topOfStack;     
    else if ([self isVariable:topOfStack])
        return topOfStack;
    else // Number
        return [topOfStack stringValue];
}

+ (NSString *)descriptionOfTheProgram:(id)program {
    NSMutableArray *stack = [self stackFromProgram:program];
    NSString *result;
    
    while ([stack lastObject]) {
        NSString *resultPart = [self descriptionOfStack:stack];
        if ([[resultPart substringToIndex:1] isEqualToString:@"("]) {
            NSRange range;
            range.location = 1;
            range.length = [resultPart length] - 2;
            resultPart = [resultPart substringWithRange:range];
        }   
        
        if (!result)
            result = resultPart;
        else 
            result = [result stringByAppendingFormat:@" , %@", resultPart];
    }  
    
    return result;    
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableArray *stack = [self stackFromProgram:program];
    NSPredicate *predicate = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
        return [self isVariable:obj]; 
    }];
                                
    [stack filterUsingPredicate:predicate];
    return [stack count] == 0 ? nil : [[NSSet alloc] initWithArray: stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack = [self stackFromProgram:program];
    for (int i = 0; i < [stack count]; i++) {
        id element = [stack objectAtIndex:i];
        if ([self isVariable:element]) {
            NSNumber *value = [variableValues objectForKey: element];
            if (!value)
                value = [NSNumber numberWithInt:0];
            [stack replaceObjectAtIndex:i withObject:value];
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariableValues:nil];
}

+ (double) popOperandOffStack: (NSMutableArray *) stack {
    double result = 0;
    id topOfStack = [self popStack:stack];

    if ([topOfStack isKindOfClass:[NSNumber class]])
        result = [topOfStack doubleValue];
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"])
            result = [self popOperandOffStack: stack] + [self popOperandOffStack: stack];
        else if ([operation isEqualToString:@"*"])
            result = [self popOperandOffStack: stack] * [self popOperandOffStack: stack];  
        else if ([operation isEqualToString:@"-"]) {
            double rhs = [self popOperandOffStack: stack];
            result = [self popOperandOffStack: stack] - rhs;  
        }
        else if ([operation isEqualToString:@"/"]) {
            double rhs = [self popOperandOffStack: stack];
            result = [self popOperandOffStack: stack] / rhs;  
        }
        else if ([operation isEqualToString:@"sin"])
            result = sin([self popOperandOffStack: stack]);
        else  if ([operation isEqualToString:@"cos"])
            result = cos([self popOperandOffStack: stack]);
        else  if ([operation isEqualToString:@"sqrt"])
            result = sqrt([self popOperandOffStack: stack]);
        else  if ([operation isEqualToString:@"Pi"]) 
            result = M_PI;
        else  if ([operation isEqualToString:@"CHS"]) 
            result = [self popOperandOffStack: stack] * (-1);
    }
    
    return result;
}

- (void) removeLastEntry {
    [CalculatorBrain popStack: self.programStack]; 
}


- (void) clear {
    _programStack = nil;
}

- (void) pushOperand:(double)operand {
    [self.programStack addObject: [NSNumber numberWithDouble:operand]];
}

- (void) pushOperationOrVariable:(NSString *)operation {
    [self.programStack addObject:operation];
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
