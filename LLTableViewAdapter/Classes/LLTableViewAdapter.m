//
//  LLTableViewAdapter.m
//  LLTableViewAdapter
//
//  Created by Lawrence Lomax on 13/11/2012.
//  Copyright (c) 2012 Lawrence Lomax. All rights reserved.
//

#import "LLTableViewAdapter.h"
#import "EXTKeyPathCoding.h"

#pragma mark Defines

#ifndef OBJECT_IS_BLOCK
#define OBJECT_IS_BLOCK(object) ( [object isKindOfClass:NSClassFromString(@"NSBlock")] )
#endif

#ifndef LLTableViewAdapterDefaultCellHeight
#define LLTableViewAdapterDefaultCellHeight 44.0f
#endif

#ifndef LLTableViewAdapterDefaultSectionHeaderHeight
#define LLTableViewAdapterDefaultSectionHeaderHeight 33.0f
#endif


#pragma mark - Constants

NSString * const kLLTableViewAdapterName = @"kLLTableViewAdapterName";

NSString * const kLLTableViewAdapterChildComposites = @"kLLTableViewAdapterChildComposites";

NSString * const kLLTableViewAdapterAction = @"kLLTableViewAdapterAction";
NSString * const kLLTableViewAdapterDelete = @"kLLTableViewAdapterDelete";

NSString * const kLLTableViewAdapterConfigurator = @"kLLTableViewAdapterConfigurator";
NSString * const kLLTableViewAdapterCellIdentifier = @"kLLTableViewAdapterCellIdentifier";

NSString * const kLLTableViewAdapterView = @"kLLTableViewAdapterView";
NSString * const kLLTableViewAdapterHeight = @"kLLTableViewAdapterHeight";

#pragma mark - Adapter Implementation

@implementation LLTableViewAdapter
{
    
}

#pragma mark Object Lifecycle

- (id)init
{
    if(self = [super init])
    {
        _managesControllerSelection = NO;
        _defaultCellHeight = LLTableViewAdapterDefaultCellHeight;
        _defaultSectionHeaderHeight = LLTableViewAdapterDefaultSectionHeaderHeight;
        
        [self registerObservers];
    }
    return self;
}

- (void) dealloc
{
    [self unregisterObservers];
}

#pragma mark Key Value Observation

- (void) registerObservers
{
    [self addObserver:self forKeyPath:@keypath(self.tableView) options:0 context:NULL];
    [self addObserver:self forKeyPath:@keypath(self.arrayController) options:0 context:NULL];
    [self registerArrayControllerObservers];
}

- (void) unregisterObservers
{
    [self removeObserver:self forKeyPath:@keypath(self.tableView)];
    [self removeObserver:self forKeyPath:@keypath(self.arrayController)];
    [self unregisterArrayControllerObservers];
}

- (void) registerArrayControllerObservers
{
    if(self.arrayController)
    {
        [self addObserver:self forKeyPath:@keypath(self, arrayController.items) options:0 context:NULL];
    }
}

- (void) unregisterArrayControllerObservers
{
    if(self.arrayController)
    {
        [self removeObserver:self forKeyPath:@keypath(self, arrayController.items)];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.tableView reloadData];
}

#pragma mark Static Initializers

+ (id) adapterWithArray:(NSArray *)array tableView:(UITableView *)tableView viewController:(UIViewController *)viewController
{
    return [self adapterWithArray:array tableView:tableView viewController:viewController ofClass:self];
}

+ (id) adapterWithArray:(NSArray *)array tableView:(UITableView *)tableView viewController:(UIViewController *)viewController ofClass:(Class)class
{
    return [self adapterWithController:[self factoryArrayController:array forAdapter:nil] tableView:tableView viewController:viewController ofClass:class];
}

+ (id) adapterWithController:(LLArrayController *)controller tableView:(UITableView *)tableView viewController:(UIViewController *)viewController
{
    return [self adapterWithController:controller tableView:tableView viewController:viewController ofClass:self];
}

+ (id) adapterWithController:(LLArrayController *)controller tableView:(UITableView *)tableView viewController:(UIViewController *)viewController ofClass:(Class)class
{
    // Factory the adapter
    LLTableViewAdapter * adapter = [[class alloc] init];
    adapter.arrayController = controller;
    adapter.tableView = tableView;
    adapter.viewController = viewController;
    
    return adapter;
}

+ (LLArrayController *) factoryArrayController:(NSArray *)array forAdapter:(LLTableViewAdapter *)adapter
{
    Class arrayControllerClass = (adapter.arrayController) ? adapter.arrayController.class : LLArrayController.class;
    LLArrayController * arrayController = [[arrayControllerClass alloc] init];
    arrayController.items = array;
    return arrayController;
}

#pragma mark - Accessors

- (void) setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    
    // Setup Tableview
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void) setArrayController:(LLArrayController *)arrayController
{
    [self unregisterArrayControllerObservers];
    
    _arrayController = arrayController;
    
    [self registerArrayControllerObservers];
}

- (NSArray *) array
{
    return self.arrayController.items;
}

- (void) setArray:(NSArray *)array
{
    if(!_arrayController)
    {
        self.arrayController = [LLTableViewAdapter factoryArrayController:array forAdapter:self];
    }
    else
    {
        self.arrayController.items = array;
    }
}

#pragma mark - Data Transform

+ (id) stripAdapterData:(id)data
{
    //TODO: finish this
    NSAssert(false, @"Method %@ not yet implemented", NSStringFromSelector(_cmd));
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arrayController count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayController countAtIndex:section];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary * sectionData = _arrayController[ section ];
    
    CGFloat (^headerHeight)(id data) = ^CGFloat(id data){
        if([data isKindOfClass:UIView.class])
        {
            return CGRectGetHeight(((UIView *)data).bounds);
        }
        else if([data isKindOfClass:NSNumber.class])
        {
            return [data floatValue];
        }
        else if(OBJECT_IS_BLOCK(data))
        {
            LLTableViewAdapterSectionHeightGetter block = data;
            return block(self, section);
        }
        
        return LLTableViewAdapterDefaultSectionHeaderHeight;
    };
    
    // Height is given
    if(sectionData[kLLTableViewAdapterHeight])
    {
        return headerHeight(sectionData[kLLTableViewAdapterHeight]);
    }
    else if(sectionData[kLLTableViewAdapterView])
    {
        return headerHeight(sectionData[kLLTableViewAdapterView]);
    }
    else if(_defaultSectionHeaderHeightGetter)
    {
        return _defaultSectionHeaderHeightGetter(self, section);
    }
    
    return _defaultSectionHeaderHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cellData = [_arrayController objectAtIndexPath:indexPath];
    
    CGFloat (^cellHeight)(id data) = ^CGFloat(id data){
        if([data isKindOfClass:UITableViewCell.class])
        {
            return CGRectGetHeight(((UITableViewCell *)data).bounds);
        }
        else if([data isKindOfClass:NSNumber.class])
        {
            return [data floatValue];
        }
        else if(OBJECT_IS_BLOCK(data))
        {
            LLTableViewAdapterCellHeightGetter block = data;
            return block(self, indexPath);
        }
        
        return LLTableViewAdapterDefaultCellHeight;
    };
    
    // Height is given
    if(cellData[kLLTableViewAdapterHeight])
    {
        return cellHeight(cellData[kLLTableViewAdapterHeight]);
    }
    // Cell is already made, just use the cell height
    else if(cellData[kLLTableViewAdapterView])
    {
        return cellHeight(cellData[kLLTableViewAdapterView]);
    }
    // Use Getter
    else if(_defaultCellHeightGetter)
    {
        return _defaultCellHeightGetter(self, indexPath);
    }
    
    // Return Default
    return _defaultCellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary * sectionData = _arrayController[ section ];
    if([sectionData[kLLTableViewAdapterName] isKindOfClass:NSString.class])
    {
        return sectionData[kLLTableViewAdapterName];
    }
    
    return nil;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary * sectionData = _arrayController[ section ];
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    
    UIView * (^headerGetter)(id data) = ^UIView *(id data){
        if([data isKindOfClass:UIView.class])
        {
            return data;
        }
        else if(OBJECT_IS_BLOCK(data))
        {
            LLTableViewAdapterHeaderFactory block = data;
            return block(self, section, height);
        }
        
        return nil;
    };
    
    // Get from Dictionary
    if(sectionData[kLLTableViewAdapterView])
    {
        return headerGetter(sectionData[kLLTableViewAdapterView]);
    }
    // Use the default getter
    else if(_defaultSectionHeaderFactory)
    {
        return _defaultSectionHeaderFactory(self, section, height);
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cellData = [_arrayController objectAtIndexPath:indexPath];
    
    NSString * (^cellIdentifierGetter)(id data) = ^NSString *(id data){
        if([data isKindOfClass:NSString.class])
        {
            return data;
        }
        else
        {
            LLTableViewAdapterCellIdentifierGetter block = data;
            return block(self, indexPath);
        }
    };
    
    NSString * cellIdentifier = nil;
    if(cellData[kLLTableViewAdapterCellIdentifier])
    {
        cellIdentifier = cellIdentifierGetter(cellData[kLLTableViewAdapterCellIdentifier]);
    }
    else if(_defaultCellIdentifier)
    {
        cellIdentifier = cellIdentifierGetter(_defaultCellIdentifier);
    }
    
    // Cell outlet
    UITableViewCell * cell = nil;
    
    // if Cell already exists just get it
    if([cellData[kLLTableViewAdapterView] isKindOfClass:UITableViewCell.class])
    {
        cell = cellData[kLLTableViewAdapterView];
    }
    else
    {
        // Try getting one for reuse
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Factory the cell if cant be used
        if(!cell)
        {
            UITableViewCell * (^cellGetter)(id data) = ^UITableViewCell *(id data){
                if([data isKindOfClass:UITableViewCell.class])
                {
                    return data;
                }
                else if(OBJECT_IS_BLOCK(data))
                {
                    LLTableViewAdapterCellFactory block = data;
                    return block(self, indexPath, cellIdentifier);
                }
                
                return nil;
            };
            
            if(cellData[kLLTableViewAdapterView])
            {
                cell = cellGetter(cellData[kLLTableViewAdapterView]);
            }
            else if(_defaultCellFactory)
            {
                cell = _defaultCellFactory(self, indexPath, cellIdentifier);
            }
        }
    }
    
    // Factory a default cell if nothing is provided
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell
    if(cellData[kLLTableViewAdapterConfigurator])
    {
        LLTableViewAdapterCellConfigurator configurator = cellData[kLLTableViewAdapterConfigurator];
        configurator(self, indexPath, cell);
    }
    if(_defaultConfigurator)
    {
        _defaultConfigurator(self, indexPath, cell);
    }
    
    // Set the Text label
    if(cellData[kLLTableViewAdapterName])
    {
        cell.textLabel.text = cellData[kLLTableViewAdapterName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Extract Cell for Callback
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        NSDictionary * cellData = [_arrayController objectAtIndexPath:indexPath];
        
        if(cellData[kLLTableViewAdapterDelete])
        {
            if([cellData[kLLTableViewAdapterDelete] isKindOfClass:[NSNumber class]])
            {
                if([cellData[kLLTableViewAdapterDelete] boolValue] && _defaultDeleter)
                {
                    _defaultDeleter(self, indexPath, cell);
                }
            }
            else if(cellData[kLLTableViewAdapterDelete])
            {
                LLTableViewAdapterAction deleteAction = cellData[kLLTableViewAdapterDelete];
                deleteAction(self, indexPath, cell);
            }
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Extract Cell for Callback
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary * cellData = [_arrayController objectAtIndexPath:indexPath];
    
    // Manage Selection on Controller
    if(_managesControllerSelection)
    {
        _arrayController.selectedItemIndexPath = indexPath;
    }
    
    // Call the default action
    if(_defaultAction)
    {
        _defaultAction(self, indexPath, cell);
    }
    
    // Call the cell data specific action
    if(cellData[ kLLTableViewAdapterAction ])
    {
        LLTableViewAdapterAction cellAction = cellData[ kLLTableViewAdapterAction ];
        cellAction(self, indexPath, cell);
    }
    
    // Manage Selection on Controller
    if(_managesControllerSelection)
    {
        _arrayController.selectedItemIndexPath = nil;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cellData = [_arrayController objectAtIndexPath:indexPath];
    if(cellData[kLLTableViewAdapterDelete])
    {
        if([cellData[kLLTableViewAdapterDelete] isKindOfClass:[NSNumber class]] )
        {
            return [cellData[kLLTableViewAdapterDelete] boolValue] ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
        }
        else
        {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}

@end
