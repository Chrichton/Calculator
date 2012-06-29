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

- (void)setUp
{
    [super setUp];
    
    brain = [[CalculatorBrain alloc] init];
    NSLog(@"Test setUp : fresh brain (yum)");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testPopOnNewBrain
{
    double d = [brain performOperation:@"+"];
    STAssertEqualsWithAccuracy(d, 0.0, 0.000001, @"pop on empty stack should be zero");
}

- (void)testPopOneOperand
{
    [brain pushOperand:99.99];
    double d = [brain performOperation:@"+"];
    STAssertEqualsWithAccuracy(d, 99.99, 0.000001, @"pop after push should return pushed operand");
}

- (void)testPerformValueAfterOperation
{
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    double d = [brain performOperation:@"+"];
    STAssertEqualsWithAccuracy(d, 4.6, 0.000001, @"perform should return the correct value");
}

- (void)testPopValueAfterOperation
{
    [brain pushOperand:1.2];
    [brain pushOperand:3.4];
    [brain performOperation:@"+"];
    double d = [brain performOperation:@"+"];
    STAssertEqualsWithAccuracy(d, 4.6, 0.000001, @"pop after perform should return correct value");
}

@end
