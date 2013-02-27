#import "Kiwi.h"

#import "LLArrayController.h"
#import "NSIndexPath+LLArrayControllerExtensions.h"

SPEC_BEGIN(LLArrayControllerSpec)

describe(@"Hello", ^{
    
    __block NSArray * array1;
    __block LLArrayController * arrayController;
    
    beforeEach(^{
        array1 = @[
            @{ kLLArrayControllerChildren : @"Name1" , @"other_value" : @"value1" },
            @{ kLLArrayControllerChildren : @"Name2" , @"other_value" : @"value2" },
            @{ kLLArrayControllerChildren : @"Name3" , @"other_value" : @"value3" },
            @{ kLLArrayControllerChildren : @"Name4" , @"other_value" : @"value4" },
            @{ kLLArrayControllerChildren : @"Name5" , @"other_value" : @"value5" }
        ];
        
        arrayController = [[LLArrayController alloc] init];
        arrayController.items = array1;
    });
    
    
    it(@"Should allow selection via -setSelectedItem:", ^{
        NSUInteger index = 2;
        arrayController.selectedItem = array1[index];
        
        [[theValue(arrayController.selectedItemIndex) should] equal:theValue(index)];
    });
    
});

/*

NSArray * 

LLArrayController * 

// Test Selected Item

// Test Item Selection #2
index = 3;
arrayController.selectedItem = [dictionaryArray[index] copy];
STAssertTrue(arrayController.selectedItemIndex == index, @"Selected item %@ does not result in correct item index %d", dictionaryArray[index], index );

// Test Item Selection #3
index = 4;
arrayController.selectedItem = [dictionaryArray[index] mutableCopy];
STAssertTrue(arrayController.selectedItemIndex == index, @"Selected item %@ does not result in correct item index %d", dictionaryArray[index], index );

//Test Item Extraction
}

- (void) testIndexPathCategory
{
}


- (void) testRemoving
{
    NSArray * array = @[
    @{@"name" : @"first" , kLLArrayControllerChildren : @[
    @{@"name" : @"first_first"}
    ]},
    @{@"name" : @"second" , kLLArrayControllerChildren : @[
    @{@"name" : @"second_first"}
    ]},
    ];
    
    LLArrayController * arrayController = [[LLArrayController alloc] init];
    arrayController.items = array;
    arrayController.selectedItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    STAssertTrue([arrayController.selectedItemIndexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]], @"setSelectedItemIndexPath: did not set");
    
    arrayController.selectedItemIndexPath = nil;
    STAssertTrue(arrayController.selectedItemIndex == NSNotFound, @"After removing selection selectedItemIndex is not equal to NSNotFound");
*/

SPEC_END