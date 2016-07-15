//
//  NSMutableArray+SafeOperations.h
//  Pods
//
//  Created by Monzy Zhang on 15/07/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SafeOperations)

- (void)bx_addSafeObject:(id)object;

- (void)bx_addSafeObject:(id)object atIndex:(NSUInteger)index;

- (id)bx_safeObjectAtIndex:(NSUInteger)index;

@end
