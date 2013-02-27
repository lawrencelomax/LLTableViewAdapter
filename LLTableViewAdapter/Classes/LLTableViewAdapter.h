//
//  LLTableViewAdapter.h
//  LLTableViewAdapter
//
//  Created by Lawrence Lomax on 13/11/2012.
//  Copyright (c) 2012 Lawrence Lomax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#import "LLArrayController.h"

#pragma mark - Constants

extern NSString * const kLLTableViewAdapterName;

extern NSString * const kLLTableViewAdapterChildComposites;

extern NSString * const kLLTableViewAdapterAction;
extern NSString * const kLLTableViewAdapterDelete;

extern NSString * const kLLTableViewAdapterConfigurator;
extern NSString * const kLLTableViewAdapterCellIdentifier;

extern NSString * const kLLTableViewAdapterView;
extern NSString * const kLLTableViewAdapterHeight;

#pragma mark - Block Based Feeding

@class LLTableViewAdapter;

/**
 A block type for a function that will return the height for a section in the TableView

 @param adapter The Adapter
 @param section The Section Index
 */
typedef CGFloat (^LLTableViewAdapterSectionHeightGetter)(LLTableViewAdapter * adapter, NSInteger section);


/**
 A block type for a function that will return the cell height for a cell in the TableView
 
 @param adapter The Adapter
 @param indexPath The Section Index Path of the Cell
 */
typedef CGFloat (^LLTableViewAdapterCellHeightGetter)(LLTableViewAdapter * adapter, NSIndexPath * indexPath);


/**
 A block type for a function that will return the Cell Identifier for a cell in the TableView
 
 @param adapter The Adapter
 @param indexPath The Section Index Path of the Cell
 @return The Cell Identifier
 */
typedef NSString * (^LLTableViewAdapterCellIdentifierGetter)(LLTableViewAdapter * adapter, NSIndexPath * indexPath);

/**
 A block type for a function that will return a new instance of a Table View Cell
 
 @param adapter The Adapter
 @param indexPath The Section Index Path of the Cell
 @param cellIdentifier The cell identifier for this cell
 */
typedef UITableViewCell * (^LLTableViewAdapterCellFactory)(LLTableViewAdapter * adapter, NSIndexPath * indexPath, NSString * cellIdentifier);

/**
 A block type for a function that will return a new instance of a Table View Cell
 
 @param adapter The Adapter
 @param indexPath The Section Index Path of the Cell
 @return The Table View Cell instance
 */
typedef void (^LLTableViewAdapterCellConfigurator)(LLTableViewAdapter * adapter, NSIndexPath * indexPath, UITableViewCell * cell);

/**
 A block type for a function that will return a new instance of a Table View Cell
 
 @param adapter The Adapter
 @param indexPath The Section Index Path of the Cell
 @return The Section header instance
 */
typedef UIView * (^LLTableViewAdapterHeaderFactory)(LLTableViewAdapter * adapter, NSUInteger section, CGFloat height);


/**
 A block type for a function that will be performed at a specific TableView event such as didSelectRow or commitEditingStyle
 
 @param adapter The Adapter
 @param indexPath The Section Index Path of the Cell
 @return The Cell instance
 */

typedef void (^LLTableViewAdapterAction)(LLTableViewAdapter * adapter, NSIndexPath * indexPath, UITableViewCell * cell);

@interface LLTableViewAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

#pragma mark Initializers

+ (instancetype) adapterWithArray:(NSArray *)array tableView:(UITableView *)tableView viewController:(UIViewController *)viewController;
+ (instancetype) adapterWithArray:(NSArray *)array tableView:(UITableView *)tableView viewController:(UIViewController *)viewController ofClass:(Class)class;

+ (instancetype) adapterWithController:(LLArrayController *)controller tableView:(UITableView *)tableView viewController:(UIViewController *)viewController;
+ (instancetype) adapterWithController:(LLArrayController *)controller tableView:(UITableView *)tableView viewController:(UIViewController *)viewController ofClass:(Class)class;

#pragma mark Helpers

+ (id) stripAdapterData:(id)data;

#pragma mark Properties

// Behaviour
@property (nonatomic, assign) BOOL managesControllerSelection;

// Section Headers
@property (nonatomic, assign) CGFloat defaultSectionHeaderHeight;
@property (nonatomic, copy) LLTableViewAdapterSectionHeightGetter defaultSectionHeaderHeightGetter;
@property (nonatomic, copy) LLTableViewAdapterHeaderFactory defaultSectionHeaderFactory;

// Cells
@property (nonatomic, assign) CGFloat defaultCellHeight;
@property (nonatomic, copy) LLTableViewAdapterCellHeightGetter defaultCellHeightGetter;
@property (nonatomic, copy) NSString * defaultCellIdentifier;
@property (nonatomic, copy) LLTableViewAdapterCellIdentifierGetter defaultCellIdentifierGetter;
@property (nonatomic, copy) LLTableViewAdapterCellFactory defaultCellFactory;
@property (nonatomic, copy) LLTableViewAdapterCellConfigurator defaultConfigurator;

// Actions
@property (nonatomic, copy) LLTableViewAdapterAction defaultAction;
@property (nonatomic, copy) LLTableViewAdapterAction defaultDeleter;

// Table View Driving
@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic, copy) LLArrayController * arrayController;
@property (nonatomic, readwrite) NSArray * array;

@end
