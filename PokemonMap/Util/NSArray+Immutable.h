//
//  NSArray+Immutable.h
//  Trigger
//
//  Created by Ray Shih on 5/22/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Immutable)

- (NSArray *)removedObjectsInArray:(NSArray *)array;

- (NSArray *)insertedWithObject:(id)obj
                        atIndex:(NSInteger)index;


@end
