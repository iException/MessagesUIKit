//
//  BXMessagesInputCustomizedStickerView.m
//  Pods
//
//  Created by Xiang Li on 10/29/15.
//
//

#import "BXMessagesInputCustomizedStickerView.h"
#import "BXMessagesInputStickerCell.h"
#import "BXCollectionViewPageableFlowLayout.h"

@interface BXMessagesInputCustomizedStickerView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *stickerArray;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation BXMessagesInputCustomizedStickerView

- (instancetype)initWithDelegate:(id)delegate index:(NSUInteger)indexValue
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.index = indexValue;
        [self initialize];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//        [self initialize];
//        //        self.flexibleWidth = YES;
//        //        self.flexibleHeight = NO;
//        //        self.height = 215;
//    }
//    
//    return self;
//}

- (void)initialize
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self initCollectionView];
    [self initPageControl];
}

#pragma mark - collection view
- (void)initCollectionView
{
    [self addSubview:self.collectionView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self.collectionView registerClass:[BXMessagesInputStickerCell class]
            forCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputStickerCell class])];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        BXCollectionViewPageableFlowLayout *layout = [[BXCollectionViewPageableFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(50, 50);
        layout.itemMinimalVerticalPadding = 0;
        layout.itemMinimalHorizontalPadding = 0;
        layout.pageContentInsets = UIEdgeInsetsMake(15, 20, 30, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfStickersOfPackAtIndex:)]) {
        return [self.delegate numberOfStickersOfPackAtIndex:self.index];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BXMessagesInputStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputStickerCell class])
                                                                               forIndexPath:indexPath];
    
//    cell.stickerImageView.image = [self.stickerArray objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageOfStickersWithPackIndex:stickerIndex:)]) {
        cell.stickerImageView.image = [self.delegate imageOfStickersWithPackIndex:self.index stickerIndex:indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputCustomizedStickerView:selectedSticker:)]) {
        NSDictionary *stickerInfo = @{
                                      @"packId":@(self.index),
                                      @"stickerId":@(indexPath.row)
                                      };
        [self.delegate bxMessagesInputCustomizedStickerView:self selectedSticker:stickerInfo];
//        [self.delegate bxMessagesInputCustomizedStickerView:self selectedSticker:[self.stickerArray objectAtIndex:indexPath.row]];
    }
}

#pragma mark - init page control
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    }
    
    return _pageControl;
}

- (void)initPageControl
{
    [self addSubview:self.pageControl];
    
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_pageControl]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    
    [self addPageControlKVOObservers];
}

- (void)addPageControlKVOObservers
{
    [self.collectionView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionNew context:nil];
    [self.collectionView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removePageControlKVOObservers
{
    @try {
        [self.collectionView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
        [self.collectionView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
    @catch (NSException *exception) {
        NSLog(@"BXMessagesKit: remove page control kvo error!");
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        self.pageControl.numberOfPages = self.collectionView.contentSize.width / self.collectionView.bounds.size.width;
        self.pageControl.currentPage = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
        
        self.pageControl.hidden = self.pageControl.numberOfPages<= 1;
        
    }else if([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        self.pageControl.currentPage = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    }
}

#pragma mark - load stickers
- (void)loadStickers
{
//    NSMutableArray *stickers = NSMutableArray.new;
//    int count = 20;
//    UIImage *image = [UIImage imageNamed:@"test_icon"];
//    for (int i=0; i<count; i++) {
//        [stickers addObject:image];
//    }
//    self.stickerArray = [NSArray arrayWithArray:stickers];
////    self.emojiArray = [NSArray arrayWithContentsOfFile:[[NSBundle buk_bundle] pathForResource:@"emoji" ofType:@"plist"]];
}

#pragma mark -
- (void)dealloc
{
    [self removePageControlKVOObservers];
}

@end
