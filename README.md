# LLTableViewAdapter
A library for simplifying and removing a lot of the cruft needed to drive a UITableView. It does need some work and plenty of unit tests.

## Installation
The preferred method is via [Cocoapods](http://cocoapods.org). If you aren't using it already, check it out, it's awesome. Add this to your ``Podfile``

``pod 'LLTableViewAdapter', :git => 'https://github.com/lawrencelomax/LLTableViewAdapter.git'``

I plan on adding the spec to the repo as soon as the app is ready for production usage

The Library has one dependency, ``libextobjc/EXTKeyPathCoding``. I may remove this dependency at one stage. Otherwise, ARC is required so you can deploy down to iOS 5.0

## Usage

### Getting Started
An adapter transforms an array and dictionary based hierarchy into a working TableView with minimal effort. You define a table as an array of dictionaries.

    @[
        @{ kLLTableViewAdapterName : @"Section 1" , @"kLLArrayControllerChildren" : @[
              @{kLLTableViewAdapterName : @"Row 1"},
              @{kLLTableViewAdapterName : @"Row 2"}
        ] },
        @{ kLLTableViewAdapterName : @"Section 2" , @"kLLArrayControllerChildren" : @[
            @{kLLTableViewAdapterName : @"Row 1"},
            @{kLLTableViewAdapterName : @"Row 2"}
        ] }
    ]
        
Here are the other constants that you can use in a cell/section dictionary

``kLLTableViewAdapterName`` - The string that will be placed into the ``textLabel``, leave blank if you wish ``kLLTableViewAdapterConfigurator`` to do this  
  
``kLLTableViewAdapterAction`` - A block representing the action that will be performed when ``didSelectRow`` is called. The property ``defaultAction`` will be performed on all cells if it is set  
  
``kLLTableViewAdapterDelete`` - A block representing the action that will be performed when ``willCommitEditingStyle`` for a deletion action. The property ``defaultDeleter`` will be performed on all cells if set. Cells will only show the deletion action if a default deleter or per-cell deleter  
  
``kLLTableViewAdapterView`` - A block that returns a UIView/UITableViewCell or a UIView/UITableViewCell. For a TableViewCell the block is of type ``LLTableViewAdapterCellFactory``, for a section header the block is of type ``LLTableViewAdapterHeaderFactory``. If the type is a UIView/UITableViewCell, make sure that the view returned is not used in other cells otherwise views may pop around during scrolling.  
  
``kLLTableViewAdapterConfigurator`` - A block that representing configuration of a cell/section header. This will be called every time ``cellForRow`` is called, regardless of whether a cell is reused. This is semantically different for a cell factory, which is all about instantiating a Table View Cell. Use this to set data on a cell such as text labels, images and so on, not to add subviews (unless you remove them for existing views beforehand). Can be set for all cells using ``defaultCellConfigurator``  
  
``kLLTableViewAdapterCellIdentifier`` -  A block that returns a NSString for the cell identifier of the current row, or a NSString of the cell identifier. This will perform all of the deque and reuse automatically. The Factory is called everytime a new cell needs to be instantiated and configuration every time ``cellForRow`` is called. Returning nil or having no value will stop reuse for this indexPath. Can be set globally with a string using ``defaultCellIdentifier``, or for a block using ``defaultCellIdentifierGetter``
  
``kLLTableViewAdapterHeight``  - A block that returns a CGFloat for the cell/section height for the current section/row, or a NSNumber wrapped float representing the height of this row. Can be set globally for a CGFloat using ``defaultSectionHeaderHeight/defaultCellHeight`` or with a block using ``defaulSectionHeaderHeightGetter/defaultCellHeightGetter``.  
  

### Array Controller
A lot of the boiler-plate for a TableView is spent extracting cell data by IndexPath from other data structures. ``LLArrayController`` is used to do this. It can also be subclassed if you wish to extract out specific data from a Dictionary for a given index path.

It also manages selection (multiple and single) which is handy for TableViews. By setting the NSArray of data in an LLArrayController, the tableView will be automatically updated. 

By implementing copying, its easier to make a hierarchy by pushing and popping UITableViewControllers onto a stack whilst using this adapter. Subscripting is supported, using an ``NSUInteger`` will return the immediate child data structure. Subscripting using objects is supported, but only for ``NSIndexPath``, you can use this to get objects at a specific IndexPath using this.

### Memory Management
One convenience that this library provides is that blocks can be used for many of the common TableView events that the delegate and data source receive. All block methods pass through the adapter, so you can access the ViewController, TableView and Data Structure. If you have custom View Controller methods that you wish to use, you can cast the ViewController property of the adapter, or capture the ViewController in the block. Be extra careful to make sure that every time you capture context with a block to only refer to the ViewController indirectly with a weak reference.

The adapter will not be retained by the TableView, so you will need to store the Adapter in an instance variable to keep it alive. This is typically an ivar in the ViewController.

Also, don't forget to copy your blocks when you place them into a dictionary. The blocks for defining default behaviour for all cells will be copied, but dictionaries may not do by default. ARC handles a lot of this now, but a ``block_copy()`` moving the block onto the heap has virtually no overhead after the first copy. 

## Suitability
This library is not intended for use with large data sets, since when you create the data structure for the Adapter, it will likely require that all of the data is initialised and that this data is created up-front. 

It is however very good for navigational tableviews; each cell in the array can have an associated action block that will be invoked every time the cell is pressed. By encapsulating action behaviour in a block, it avoids some of the ``if-else-if-else`` statements for choosing an appropriate action for tableview cells.

## TODOs
- More Unit Tests
- Properly support stripping/injection of adapter data for easier i/o
- Support setSelectedItem/s in a recursive way
- Multiple selection support
- Additional TableView actions and callbacks (Cell Appearing, Moving etc.)
- Cell input (UITextField, Switches)
- Additional callbacks for newer iOS features, without requiring runtime checks
- Intelligent updates for changes to array.
- Dont require a section, if no depth to array, just show cells
- Subscripting support for ordered dictionary.
- Safer, adaptive and more robust recursive algorithms


## Thanks & Contributing
If you have anything to contribute, send a pull request and I'll take a look. I do plan on adding this to the CocoaPods Spec repo as soon as its ready for production usage.

## [Licence](http://github.com/lawrencelomax/LLTableViewAdapter/blob/master/LICENSE)
