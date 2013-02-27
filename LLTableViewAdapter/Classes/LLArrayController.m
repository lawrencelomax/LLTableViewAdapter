//
//  LLArrayController.m
//  LLTableViewAdapter
//
//  Created by Lawrence Lomax on 22/11/2012.
//  Copyright (c) 2012 Lawrence Lomax. All rights reserved.
//

#import "LLArrayController.h"
#import "NSIndexPath+LLArrayControllerExtensions.h"

NSString * const kLLArrayControllerChildren = @"kLLArrayControllerChildren";

@interface LLArrayController()

@end

@implementation LLArrayController
{
}

- (id) init
{
    if(self = [super init])
    {
        _dictionaryTraversalKey = kLLArrayControllerChildren;
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone
{
    LLArrayController * copy = [[[self class] alloc] init];
    copy.items = self.items;
    copy.selectedItemIndexPaths = self.selectedItemIndexPaths;
    copy.dictionaryTraversalKey = self.dictionaryTraversalKey;
    
    return copy;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Selected Collection %@, with IndexPath %@ and Data %@", self.selectedItem, self.selectedItemIndexPath, self.items];
}

#pragma mark - Index Based Accessors

#pragma mark Single Index

- (id) objectAtIndex:(NSUInteger)index
{
    return (_items) ? _items[ index ] : nil;
}

- (NSArray *) objectsAtIndex:(NSUInteger)index
{
    NSArray * objects = [self objectsAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
    return objects;
}

#pragma mark Multiple Index Accessors

- (NSArray *) objectsAtIndeces:(NSUInteger *)indeces length:(NSUInteger)length
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0; i < length; i++)
    {
        id object = self[ indeces[i] ];
        [array addObject:object];
    }
    return array;
}

#pragma mark Index Path

- (id) objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [LLArrayController objectAtIndexPath:indexPath fromArray:_items childDictionaryKey:_dictionaryTraversalKey];
}

- (NSArray *) objectsAtIndexPath:(NSIndexPath *)indexPath
{
    return [LLArrayController objectsAtIndexPath:indexPath fromArray:_items childDictionaryKey:_dictionaryTraversalKey];
}

- (NSArray *) objectsAtIndexPaths:(NSArray *)indexPaths
{
    return [LLArrayController objectsAtIndexPaths:indexPaths fromArray:_items childDictionaryKey:_dictionaryTraversalKey];
}

- (NSArray *) objectsInIndexSet:(NSIndexSet *)indexSet
{
    return [self objectsAtIndexPaths:[self transformToIndexPathArrayFromIndexSet:indexSet]];
}

- (NSUInteger) childrenAtIndex:(NSUInteger)idx
{
    NSDictionary * sectionData = [self objectAtIndex:idx];
    NSArray * children =  (sectionData[kLLArrayControllerChildren]) ? sectionData[kLLArrayControllerChildren] : nil;
    NSInteger count = (children) ? children.count : 0;
    return count;
}

#pragma mark - Array Like

- (id) objectAtIndexedSubscript:(NSUInteger)index
{
    return [self objectAtIndex:index];
}

- (id) objectForKeyedSubscript:(id)key
{
    if([key isKindOfClass:NSIndexPath.class])
    {
        return [self objectAtIndexPath:key];
    }
    else if([key isKindOfClass:NSNumber.class])
    {
        return self[ [key unsignedIntegerValue] ];
    }
    
    return  nil;
}

#pragma mark - Counts

- (NSUInteger) count
{
    return (_items) ? _items.count : 0;
}

- (NSUInteger) countAtIndex:(NSUInteger)index
{
    NSArray * objects = [self objectsAtIndex:index];
    return (objects) ? [objects count] : 0;
}


- (NSUInteger) countAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * objects = [self objectsAtIndexPath:indexPath];
    return (objects) ? [objects count] : 0;
}

#pragma mark - Accessors

#pragma mark Key Paths

+ (NSSet *) keyPathsForValuesAffectingSelectedItems
{
    return [NSSet setWithObject:@"selectedItemIndexPaths"];
}

+ (NSSet *) keyPathsForValuesAffectingSelectedItemIndeces
{
    return [NSSet setWithObject:@"selectedItemIndexPaths"];
}

+ (NSSet *) keyPathsForValuesAffectingSelectedItemIndex
{
    return [NSSet setWithObject:@"selectedItemIndexPath"];
}

+ (NSSet *) keyPathsForValuesAffectingSelectedItem
{
    return [NSSet setWithObject:@"selectedItemIndexPath"];
}

#pragma mark Selected Item Index Path

- (NSIndexPath *) selectedItemIndexPath
{
    NSArray * indexPaths = self.selectedItemIndexPaths;
    if(indexPaths.count)
    {
        return indexPaths[0];
    }
    
    return nil;
}

- (void) setSelectedItemIndexPath:(NSIndexPath *)selectedItemIndexPath
{
    if(selectedItemIndexPath)
    {
        self.selectedItemIndexPaths = @[ selectedItemIndexPath ];
    }
    else
    {
        self.selectedItemIndexPaths = nil;
    }
}

#pragma mark Selected Item Index/es

- (NSIndexSet *) selectedItemIndexSet
{
    NSArray * indexPaths = self.selectedItemIndexPaths;
    NSIndexSet * indexSet = [self transformToIndexSetFromIndexPaths:indexPaths];
    return indexSet;
}

- (void) setSelectedItemIndeces:(NSIndexSet *)selectedItemIndexSet
{
    NSArray * selectedItemIndexPaths = [self transformToIndexPathArrayFromIndexSet:selectedItemIndexSet];
    self.selectedItemIndexPaths = selectedItemIndexPaths;
}

- (NSUInteger) selectedItemIndex
{
    if(self.selectedItemIndexPath)
    {
        return [self.selectedItemIndexPath indexAtPosition:0];
    }
    
    return NSNotFound;
}

- (void) setSelectedItemIndex:(NSUInteger)selectedItemIndex
{
    if(selectedItemIndex != NSNotFound)
    {
        self.selectedItemIndexPath = [NSIndexPath indexPathWithIndex:selectedItemIndex];
    }
    else
    {
        self.selectedItemIndexPath = nil;
    }
}


#pragma mark Selected Item

- (NSArray *) selectedItems
{
    return [self objectsAtIndexPaths:self.selectedItemIndexPaths];
}

- (void) setSelectedItems:(NSArray *)selectedItems
{
    // TODO: recursive search of selected items
    if(selectedItems)
    {
        NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
        
        [selectedItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSUInteger index = [_items indexOfObject:obj];
            [indexPaths addObject:[NSIndexPath indexPathWithIndex:index]];
        }];
        self.selectedItemIndexPaths = indexPaths;
    }
    else
    {
        self.selectedItemIndexPaths = nil;
    }
}

- (void) setSelectedItem:(id)selectedItem
{
    if(selectedItem)
    {
        self.selectedItems = @[ selectedItem ];
    }
    else
    {
        self.selectedItems = nil;
    }
}

- (id) selectedItem
{
    if(self.selectedItemIndexPath)
    {
        return [self objectAtIndexPath:self.selectedItemIndexPath];
    }
    
    return nil;
}

#pragma mark - Helper Methods

#pragma mark Traversal

+ (void) traverseArray:(NSArray *)array toIndexPath:(NSIndexPath *)indexPath down:(BOOL)down withBlock:(id)block
{
    
}

+ (id) obtainValueUpwardsFromIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *)array
{
    __block id value = nil;
    [self traverseArray:array toIndexPath:indexPath down:NO withBlock:nil];
    return value;
}

#pragma mark Data Extraction from Arrays

+ (NSArray *) objectsAtIndexPaths:(NSArray *)indexPaths fromArray:(NSArray *)array childDictionaryKey:(id)childDictionaryKey
{
    NSMutableArray * objects = [[NSMutableArray alloc] init];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * indexPaths, NSUInteger index, BOOL * stop) {
        [self objectAtIndexPath:indexPaths fromArray:array childDictionaryKey:childDictionaryKey];
    }];
    
    return objects;
}

+ (NSArray *) objectsAtIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *)array childDictionaryKey:(id)childDictionaryKey
{
    if(!indexPath || indexPath.length == 0)
    {
        return array;
    }
    
    NSUInteger index = [indexPath ll_firstIndex];
    id object = [array objectAtIndex:index];
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        object = object[childDictionaryKey];
    }
    
    indexPath = [indexPath ll_popFirstIndex];
    return [self objectsAtIndexPath:indexPath fromArray:object childDictionaryKey:childDictionaryKey];
}

+ (id) objectAtIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *) array childDictionaryKey:(id)childDictionaryKey;
{
    NSUInteger index = [indexPath ll_lastIndex];
    indexPath = [indexPath ll_popLastIndex];
    array = [self objectsAtIndexPath:indexPath fromArray:array childDictionaryKey:childDictionaryKey];
    
    return array[index];
}

#pragma mark Private Transformation

- (NSArray *) transformToIndexPathArrayFromIndexSet:(NSIndexSet *)indexSet
{
    NSMutableArray * objects = [[NSMutableArray alloc] init];
    if(indexSet)
    {
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            [objects addObject:[self objectAtIndex:index]];
        }];
    }
    return objects;
}


- (NSIndexSet *) transformToIndexSetFromIndexPaths:(NSArray *)indexPaths
{
    NSMutableIndexSet * indexSet = [[NSMutableIndexSet alloc] init];
    if(indexPaths)
    {
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * indexPath, NSUInteger index, BOOL *stop) {
            [indexSet addIndex:[indexPath indexAtPosition:0]];
        }];
    }
    return [indexSet copy];
}

@end
