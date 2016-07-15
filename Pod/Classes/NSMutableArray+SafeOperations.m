//
//  NSMutableArray+SafeOperations.m
//  Pods
//
//  Created by Monzy Zhang on 15/07/2016.
//
//

#import "NSMutableArray+SafeOperations.h"

@implementation NSMutableArray (SafeOperations)

- (void)bx_addSafeObject:(id)object
{
    NSAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]], @"object is not an array or set");
    
    if (NO == [self isKindOfClass:[NSMutableArray class]] && NO == [self isKindOfClass:[NSMutableSet class]]) {
        return;
    }
    
    if (nil == object) {
        return;
    }
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [(NSMutableArray *)self addObject:object];
    }
    else if ([self isKindOfClass:[NSMutableSet class]]) {
        [(NSMutableSet *)self addObject:object];
    }
}

- (void)bx_addSafeObject:(id)object atIndex:(NSUInteger)index
{
    NSAssert([self isKindOfClass:[NSArray class]], @"object is not an array");
    if (![self isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    if (nil == object) {
        return;
    }
    
    if (index > self.count || index < 0) {
        return;
    }
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [self insertObject:object atIndex:index];
    }
}

/*** NSArray ***/
- (id)bx_safeObjectAtIndex:(NSUInteger)index
{
    NSAssert([self isKindOfClass:[NSArray class]], @"object is not an array");
    
    NSUInteger emptysize = 0;
    
    if (NO == [self isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (emptysize > index || index >= [(NSArray *)self count]) {
        return nil;
    }
    
    id object = [(NSArray *)self objectAtIndex:index];
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return object;
}

@end
