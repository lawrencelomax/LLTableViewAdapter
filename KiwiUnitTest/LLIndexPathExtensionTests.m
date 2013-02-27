#import "Kiwi.h"

#import "NSIndexPath+LLArrayControllerExtensions.h"

SPEC_BEGIN(LLIndexPathExtensionTests)

describe(@"LLIndexPathExtensionTests", ^{
   
    __block NSIndexPath * oneThroughTen;
    
    beforeEach(^{
        
        NSUInteger indicesCount = 10;
        int indeces[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
        oneThroughTen = [NSIndexPath indexPathWithIndexes:((NSUInteger *)indeces) length:indicesCount];
        
    });
    
    it(@"ll_popLastIndex should behave the same as indexPathByRemovingLastIndex", ^{
        
        [[[oneThroughTen indexPathByRemovingLastIndex] should] equal:[oneThroughTen ll_popLastIndex]];
        
    });
    
});


SPEC_END
