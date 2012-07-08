//
//  CalculatorTests.m
//  CalculatorTests
//
//  Created by Heiko Goes on 27.06.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import "CalculatorTests.h"
#import "CalculatorBrain.h"

@implementation CalculatorTests

static CalculatorBrain *brain;

- (void)setUp {
    [super setUp];
    
    brain = [[CalculatorBrain alloc] init];
    NSLog(@"Test setUp : fresh brain (yum)");
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testPopOnNewBrain {
    double d = [brain performOperation:@"+"];
    STAssertEqualsWithAccuracy(d, 0.0, 0.000001, @"pop on empty stack should be zero");
}

- (void)testPopOneOperand {
    [brain pushOperand:99.99];
    double d = [brain performOperation:@"+"];
    STAssertEqualsWithAccuracy(d, 99.99, 0.000001, @"pop after push should return pushed operand");
}

- (void)testPerformValueAfterOperation {
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    double d = [brain performOperation:@"+"];
    STAssertEqualsWithAccuracy(d, 4.6, 0.000001, @"perform should return the correct value");
}

- (void)testPopValueAfterOperation {
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    [brain performOperation:@"+"];
    double d = [brain performOperation:@"+"];
    STAssertEqualsWithAccuracy(d, 4.6, 0.000001, @"pop after perform should return correct value");
}

- (void)testIsValidNumber {    
    STAssertTrue([brain isValidNumber:@"1."], @"'1.' is valid number == 1");

    
    STAssertTrue([brain isValidNumber:@"0"], @"Zero is valid number");
    STAssertTrue([brain isValidNumber:@"1"], @"natural number is valid number");
    STAssertTrue([brain isValidNumber:@"1.2"], @"decimalNumer is valid number");
    STAssertTrue([brain isValidNumber:@".2"], @"decimalNumer starting with '.' is valid number");
    STAssertTrue([brain isValidNumber:@"."], @"'.' is valid number == 0");
    STAssertTrue([brain isValidNumber:@"1."], @"'1.' is valid number == 1");
    
    STAssertTrue([brain isValidNumber:@"-0"], @"'-0' is valid number == 0");
    STAssertTrue([brain isValidNumber:@"-1"], @"negative number is valid number");
    STAssertTrue([brain isValidNumber:@"-"], @"'-' is valid number == 0");

    STAssertFalse([brain isValidNumber:@"1.56."], @"more than one '.' invalid");    
    STAssertFalse([brain isValidNumber:@"00"], @"'00' invalid"); 
    STAssertFalse([brain isValidNumber:@"-00"], @"'-00' invalid"); 
}

- (void) testRunProgram {
    NSMutableArray *program = [[NSMutableArray alloc] init];
    [program addObject:[NSNumber numberWithInt:3]];
    [program addObject:[NSNumber numberWithInt:4]];
    [program addObject:@"+"];
    double d = [CalculatorBrain runProgram: [program copy]];
    STAssertEqualsWithAccuracy(d, 7.0, 0.000001, @"3+4=7"); 
}

- (void) testRunProgramWithVariable {
    NSMutableArray *program = [[NSMutableArray alloc] init];
    [program addObject:@"x"];
    [program addObject:[NSNumber numberWithInt:4]];
    [program addObject:@"+"];
    double d = [CalculatorBrain runProgram: [program copy]];
    STAssertEqualsWithAccuracy(d, 4.0, 0.000001, @"0+4=4"); 
}

- (void) testRunProgram_usingVariableValues {
    NSMutableArray *program = [[NSMutableArray alloc] init];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithInt:3] forKey:@"x"];
    
    [program addObject:@"x"];
    [program addObject:[NSNumber numberWithInt:4]];
    [program addObject:@"+"];
    double d = [CalculatorBrain runProgram: [program copy] usingVariableValues:dictionary];
    STAssertEqualsWithAccuracy(d, 7.0, 0.000001, @"3+4=7"); 
}

- (void) testRunProgram_usingNoVariableValues {
    NSMutableArray *program = [[NSMutableArray alloc] init];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [program addObject:@"x"];
    [program addObject:[NSNumber numberWithInt:4]];
    [program addObject:@"+"];
    double d = [CalculatorBrain runProgram: [program copy] usingVariableValues:dictionary];
    STAssertEqualsWithAccuracy(d, 4.0, 0.000001, @"0+4=4"); 
}

- (void) testVariablesUsedInProgram {
    NSMutableArray *program = [[NSMutableArray alloc] init];
        
    [program addObject:@"x"];
    [program addObject:[NSNumber numberWithInt:4]];
    [program addObject:@"+"];
    
    NSSet *variables = [CalculatorBrain variablesUsedInProgram:program];
    STAssertEquals(1, [variables count], @"");
    STAssertEquals(@"x", [variables anyObject], @"one variable 'x'");
}

- (void) testNoVariablesUsedInProgram {
    NSMutableArray *program = [[NSMutableArray alloc] init];
    
    [program addObject:[NSNumber numberWithInt:4]];
    [program addObject:@"+"];
    
    NSSet *variables = [CalculatorBrain variablesUsedInProgram:program];
    STAssertNil(variables, @"no variables");
}

@end
