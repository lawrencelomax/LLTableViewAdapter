//
//  LLArrayController.h
//  LLTableViewAdapter
//
//  Created by Lawrence Lomax on 22/11/2012.
//  Copyright (c) 2012 Lawrence Lomax. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSIndexPath+LLArrayControllerExtensions.h"

extern NSString * const kLLArrayControllerChildren;

@interface LLArrayController : NSObject<NSCopying>

#pragma mark - Properties

// Array
@property (nonatomic, readwrite) NSArray * items;

// Selected Item (Single Selection)
@property (nonatomic, copy) NSIndexPath * selectedItemIndexPath;
@property (nonatomic, readwrite) id selectedItem;
@property (nonatomic, readwrite) NSUInteger selectedItemIndex;

// Selected Items (Multiple Selection)
@property (nonatomic, copy) NSArray * selectedItemIndexPaths;
@property (nonatomic, readwrite) NSArray * selectedItems;
@property (nonatomic, readwrite) NSIndexSet * selectedItemIndexSet;

// Other Properties
@property (nonatomic, copy) id dictionaryTraversalKey;

#pragma mark Static Initializers

//+ (instancetype) arrayControllerWithArray:(NSArray *)array;

#pragma mark - Index Based Accessors

#pragma mark Single Index Array Like

- (NSUInteger) count;
- (id) objectAtIndex:(NSUInteger)index;
- (NSArray *) objectsAtIndex:(NSUInteger)index;

#pragma mark Multiple Index Accessors

- (NSArray *) objectsAtIndeces:(NSUInteger *)indeces length:(NSUInteger)length;

#pragma mark Index Path

- (id) objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *) objectsAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *) objectsInIndexSet:(NSIndexSet *)indexSet;
- (NSArray *) objectsAtIndexPaths:(NSArray *)indexPaths;

#pragma mark Subscripting Support

- (id) objectAtIndexedSubscript:(NSUInteger)idx;
- (id) objectForKeyedSubscript:(id)key;

#pragma mark - Counts

- (NSUInteger) countAtIndex:(NSUInteger)index;
- (NSUInteger) countAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Helper Methods

#pragma mark Traversal

+ (void) traverseArray:(NSArray *)array toIndexPath:(NSIndexPath *)indexPath down:(BOOL)down;
+ (id) obtainValueUpwardsFromIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *)array;

#pragma mark Data Extraction from Arrays

+ (NSArray *) objectsAtIndexPaths:(NSArray *)indexPaths fromArray:(NSArray *)array childDictionaryKey:(id)childDictionaryKey;
+ (NSArray *) objectsAtIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *)array childDictionaryKey:(id)childDictionaryKey;
+ (id) objectAtIndexPath:(NSIndexPath *)indexPath fromArray:(NSArray *) array childDictionaryKey:(id)childDictionaryKey;

@end
