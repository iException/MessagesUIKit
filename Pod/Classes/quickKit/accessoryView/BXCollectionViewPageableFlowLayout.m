//
//  BXCollectionViewPagableFlowLayout.m
//  Baixing
//
//  Created by hyice on 15/3/20.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXCollectionViewPageableFlowLayout.h"

@interface BXCollectionViewPageableFlowLayout()

@property (assign, nonatomic) NSInteger numberOfItemsPerRow;
@property (assign, nonatomic) NSInteger numberOfLinesPerPage;
@property (assign, nonatomic) NSInteger itemsPerPage;
@property (assign, nonatomic) NSInteger itemsCount;

@property (assign, nonatomic) CGFloat itemActualHorizontalPadding;
@property (assign, nonatomic) CGFloat itemActualVeticalPadding;

@end

@implementation BXCollectionViewPageableFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    CGFloat useableWidth = CGRectGetWidth(self.collectionView.frame) - self.pageContentInsets.left - self.pageContentInsets.right;
    CGFloat useableHeight = CGRectGetHeight(self.collectionView.frame) - self.pageContentInsets.top - self.pageContentInsets.bottom;
    
    self.numberOfItemsPerRow = floor((useableWidth + self.itemMinimalHorizontalPadding) / (self.itemSize.width + self.itemMinimalHorizontalPadding));
    self.numberOfLinesPerPage = floor((useableHeight + self.itemMinimalVerticalPadding) / (self.itemSize.height + self.itemMinimalVerticalPadding));
    self.itemsPerPage = self.numberOfLinesPerPage * self.numberOfItemsPerRow;
    self.itemsCount = [self.collectionView numberOfItemsInSection:0];
    
    if (self.numberOfItemsPerRow > 1) {
        self.itemActualHorizontalPadding = (useableWidth - self.numberOfItemsPerRow * self.itemSize.width) / (self.numberOfItemsPerRow - 1);
    }
    if (self.numberOfLinesPerPage > 1) {
        self.itemActualVeticalPadding = (useableHeight - self.numberOfLinesPerPage * self.itemSize.height) / (self.numberOfLinesPerPage - 1);
    }
}

- (CGSize)collectionViewContentSize
{
    NSInteger numberOfPages = ceil(self.itemsCount * 1.0 / self.itemsPerPage);
    
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame) * numberOfPages,
                      CGRectGetHeight(self.collectionView.frame));
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    
    NSInteger pageIndex = indexPath.row / self.itemsPerPage;
    NSInteger row = (indexPath.row % self.itemsPerPage) / self.numberOfItemsPerRow;
    NSInteger index = (indexPath.row % self.itemsPerPage) % self.numberOfItemsPerRow;
    
    CGFloat x = CGRectGetWidth(self.collectionView.frame) * pageIndex + self.itemSize.width * (index + 0.5) + self.itemActualHorizontalPadding * index + self.pageContentInsets.left;
    CGFloat y = self.itemSize.height * (row + 0.5) + self.itemActualVeticalPadding* row + self.pageContentInsets.top;
    
    attributes.center = CGPointMake(x, y);
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.itemsCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

@end
