//
//  BXMessagesInputStickersGalleryViewLayout.m
//  Pods
//
//  Created by Xiang Li on 10/27/15.
//
//

#import "BXMessagesInputStickersGalleryViewLayout.h"

@implementation BXMessagesInputStickersGalleryViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.itemSize.width * self.numberOfItems, self.itemSize.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;

    attributes.center = CGPointMake((0.5+indexPath.row)*self.itemSize.width, self.itemSize.height/2);
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.numberOfItems; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

@end
