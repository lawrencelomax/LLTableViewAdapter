//
//  NSIndexPath+LLArrayControllerExtensions.m
//  LLTableViewAdapter
//
//  Created by Lawrence Lomax on 20/12/2012.
//  Copyright (c) 2012 Lawrence Lomax. All rights reserved.
//

#import "NSIndexPath+LLArrayControllerExtensions.h"

@implementation NSIndexPath (LLArrayControllerExtensions)

+ (void) load
{
    NSLog(@"load");
}

- (NSIndexPath *) ll_popLastIndex
{
    NSUInteger * intArray = malloc(sizeof(NSUInteger) * self.length);
    [self getIndexes:intArray];
    
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathWithIndexes:intArray length:self.length - 1];
    free(intArray);
    
    return nextIndexPath;
}


- (NSIndexPath *) ll_popFirstIndex
{
    NSUInteger * intArray = malloc(sizeof(NSUInteger) * self.length);
    [self getIndexes:intArray];
    
    NSUInteger * intStart = intArray;
    intStart++;
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathWithIndexes:intStart length:self.length - 1];
    free(intArray);
    
    return nextIndexPath;
}


- (NSIndexPath *) ll_pushIndexLast:(NSUInteger)index
{
    NSUInteger * intArray = malloc(sizeof(NSUInteger) * (self.length + 1));
    [self getIndexes:intArray];
    intArray[self.length] = index;
    
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathWithIndexes:intArray length:self.length + 1];
    free(intArray);
    
    return nextIndexPath;
}


- (NSIndexPath *) ll_replaceFirstIndex:(NSUInteger)index
{
    return [self ll_replaceIndex:index atPosition:(0)];
}


- (NSIndexPath *) ll_replaceLastIndex:(NSUInteger)index
{
    return [self ll_replaceIndex:index atPosition:(self.length - 1)];
}


- (NSIndexPath *) ll_replaceIndex:(NSUInteger)index atPosition:(NSUInteger)position
{
    NSUInteger * intArray = malloc(sizeof(NSUInteger) * (self.length));
    [self getIndexes:intArray];
    intArray[position] = index;
    
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathWithIndexes:intArray length:self.length];
    free(intArray);
    
    return nextIndexPath;
}


- (NSUInteger) ll_firstIndex
{
    return [self indexAtPosition:0];
}


- (NSUInteger) ll_lastIndex
{
    return [self indexAtPosition:([self length]-1)];
}


@end
