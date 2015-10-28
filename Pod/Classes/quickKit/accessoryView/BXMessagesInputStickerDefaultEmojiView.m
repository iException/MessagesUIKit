//
//  BXMessagesInputStickerDefaultEmojiView.m
//  Pods
//
//  Created by Xiang Li on 10/28/15.
//
//

#import "BXMessagesInputStickerDefaultEmojiView.h"
#import "BXCollectionViewPageableFlowLayout.h"
#import "BXMessagesInputEmojiCell.h"
#import "NSBundle+MessagesUIKit.h"

@interface BXMessagesInputStickerDefaultEmojiView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *emojiArray;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation BXMessagesInputStickerDefaultEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        self.flexibleWidth = YES;
//        self.flexibleHeight = NO;
//        self.height = 215;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadEmojis];
        
        [self initCollectionView];
//        [self initButtons];
        [self initPageControl];
    }
    
    return self;
}

#pragma mark - collection view
- (void)initCollectionView
{
    [self addSubview:self.collectionView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self.collectionView registerClass:[BXMessagesInputEmojiCell class]
            forCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputEmojiCell class])];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        BXCollectionViewPageableFlowLayout *layout = [[BXCollectionViewPageableFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 40);
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
    return self.emojiArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BXMessagesInputEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputEmojiCell class])
                                                                               forIndexPath:indexPath];
    
    cell.emojiLabel.text = [self.emojiArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputStickerDefaultEmojiView:selectedEmoji:)]) {
        [self.delegate bxMessagesInputStickerDefaultEmojiView:self selectedEmoji:[self.emojiArray objectAtIndex:indexPath.row]];
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

//#pragma mark - buttons
//- (void)initButtons
//{
//    [self addSubview:self.deleteButton];
//    
//    self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-1]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
//    
//    [self addSubview:self.sendButton];
//    
//    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sendButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.deleteButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:-1]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sendButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:1]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sendButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.deleteButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sendButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.deleteButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];
//}
//
//- (UIButton *)sendButton
//{
//    if (!_sendButton) {
//        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _sendButton.backgroundColor = [UIColor colorWithRed:0xf9/255.0 green:0xf9/255.0 blue:0xf9/255.0 alpha:1.0];
//        [_sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//        [_sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
//        
//        _sendButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _sendButton.layer.borderWidth = 1.0f;
//    }
//    
//    return _sendButton;
//}
//
//- (void)sendButtonPressed:(UIButton *)button
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputEmojiView:sendButtonPressed:)]) {
//        [self.delegate bxMessagesInputEmojiView:self sendButtonPressed:button];
//    }
//}
//
//- (UIButton *)deleteButton
//{
//    if (!_deleteButton) {
//        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _deleteButton.backgroundColor = [UIColor colorWithRed:0xf9/255.0 green:0xf9/255.0 blue:0xf9/255.0 alpha:1.0];
//        [_deleteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [_deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        [_deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
//        
//        _deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _deleteButton.layer.borderWidth = 1.0f;
//    }
//    
//    return _deleteButton;
//}
//
//- (void)deleteButtonPressed:(UIButton *)button
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputEmojiView:deleteButtonPressed:)]) {
//        [self.delegate bxMessagesInputEmojiView:self deleteButtonPressed:button];
//    }
//}

#pragma mark - load emojis
- (void)loadEmojis
{
    self.emojiArray = [NSArray arrayWithContentsOfFile:[[NSBundle buk_bundle] pathForResource:@"emoji" ofType:@"plist"]];
}

#pragma mark -
- (void)dealloc
{
    [self removePageControlKVOObservers];
}

@end
