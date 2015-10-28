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
    
//    CGFloat useableWidth = CGRectGetWidth(self.collectionView.frame) - self.pageContentInsets.left - self.pageContentInsets.right;
//    CGFloat useableHeight = CGRectGetHeight(self.collectionView.frame) - self.pageContentInsets.top - self.pageContentInsets.bottom;
//    
//    self.numberOfItemsPerRow = floor((useableWidth + self.itemMinimalHorizontalPadding) / (self.itemSize.width + self.itemMinimalHorizontalPadding));
//    self.numberOfLinesPerPage = floor((useableHeight + self.itemMinimalVerticalPadding) / (self.itemSize.height + self.itemMinimalVerticalPadding));
//    self.itemsPerPage = self.numberOfLinesPerPage * self.numberOfItemsPerRow;
//    self.itemsCount = [self.collectionView numberOfItemsInSection:0];
//    
//    if (self.numberOfItemsPerRow > 1) {
//        self.itemActualHorizontalPadding = (useableWidth - self.numberOfItemsPerRow * self.itemSize.width) / (self.numberOfItemsPerRow - 1);
//    }
//    if (self.numberOfLinesPerPage > 1) {
//        self.itemActualVeticalPadding = (useableHeight - self.numberOfLinesPerPage * self.itemSize.height) / (self.numberOfLinesPerPage - 1);
//    }
}

- (CGSize)collectionViewContentSize
{
//    NSInteger numberOfPages = ceil(self.itemsCount * 1.0 / self.itemsPerPage);
//    
//    return CGSizeMake(CGRectGetWidth(self.collectionView.frame) * numberOfPages,
//                      CGRectGetHeight(self.collectionView.frame));
    
    return CGSizeMake(self.itemSize.width * self.numberOfItems, self.itemSize.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    
//    NSInteger pageIndex = indexPath.row / self.itemsPerPage;
//    NSInteger row = (indexPath.row % self.itemsPerPage) / self.numberOfItemsPerRow;
//    NSInteger index = (indexPath.row % self.itemsPerPage) % self.numberOfItemsPerRow;
//    
//    CGFloat x = CGRectGetWidth(self.collectionView.frame) * pageIndex + self.itemSize.width * (index + 0.5) + self.itemActualHorizontalPadding * index + self.pageContentInsets.left;
//    CGFloat y = self.itemSize.height * (row + 0.5) + self.itemActualVeticalPadding* row + self.pageContentInsets.top;
//    
//    attributes.center = CGPointMake(x, y);
    
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
