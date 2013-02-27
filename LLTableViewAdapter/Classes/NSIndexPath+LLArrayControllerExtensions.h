//
//  NSIndexPath+LLArrayControllerExtensions.h
//  LLTableViewAdapter
//
//  Created by Lawrence Lomax on 20/12/2012.
//  Copyright (c) 2012 Lawrence Lomax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (LLArrayControllerExtensions)

- (NSIndexPath *) ll_popFirstIndex;
- (NSIndexPath *) ll_popLastIndex;

- (NSIndexPath *) ll_pushIndexLast:(NSUInteger)index;

- (NSIndexPath *) ll_replaceFirstIndex:(NSUInteger)index;
- (NSIndexPath *) ll_replaceLastIndex:(NSUInteger)index;
- (NSIndexPath *) ll_replaceIndex:(NSUInteger)index atPosition:(NSUInteger)position;

- (NSUInteger) ll_firstIndex;
- (NSUInteger) ll_lastIndex;

@end
