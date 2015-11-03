//
//  BXMessagesInputStickerView.m
//  Pods
//
//  Created by Xiang Li on 10/27/15.
//
//

#import "BXMessagesInputStickerView.h"
//#import "BXCollectionViewPageableFlowLayout.h"
#import "BXMessagesInputStickersGalleryViewLayout.h"
#import "BXMessagesInputStickersGalleryViewCell.h"
#import "BXMessagesInputStickerCell.h"
#import "BXMessagesInputStickerDefaultEmojiView.h"
#import "BXMessagesInputCustomizedStickerView.h"

static NSInteger const stickersCount           = 2;
static CGFloat const stickerViewHeight         = 215;
static CGFloat const toolBarHeight             = 40;

@interface BXMessagesInputStickerView() <UICollectionViewDataSource,UICollectionViewDelegate,BXMessagesInputStickerDefaultEmojiViewDelegate, BXMessagesInputCustomizedStickerViewDelegate, BXMessagesInputCustomizedStickerViewDataSource>

// main view where emojis and other stickers are presented in order
@property (nonatomic, strong) UIView *stickerMainView;
// to improve performance,each time the user choose a different set of emoji or stickers pack,
// that view is cached in this array
@property (nonatomic, strong) NSMutableArray *cachedMainViewCandidates;

// tool bar where addStickerButton,stickersGallery and sendButton are placed
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *addStickersButton;
@property (nonatomic, strong) UICollectionView *stickersGalleryView;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation BXMessagesInputStickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.flexibleWidth = YES;
    self.flexibleHeight = NO;
    self.height = stickerViewHeight;
    
    self.backgroundColor = [UIColor whiteColor];
    
    // get emoji & sticker gallery
    [self prepareEmojiAndStickerPacks];
    // init UI Elements
    [self initStickerMainView];
    [self initToolBar];
}

// get local emoji & sticker packs info
- (void)prepareEmojiAndStickerPacks
{
    [self loadStickerRecources];
}

// default do nothing
- (void)loadStickerRecources
{
}

- (void)initStickerMainView
{
    [self addSubview:self.stickerMainView];
    
    // arrange stickerMainView
    self.stickerMainView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_stickerMainView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickerMainView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[_stickerMainView]-%f-|",toolBarHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickerMainView)]];
    
    // init cachedMainViewCandidates
    self.cachedMainViewCandidates = [NSMutableArray arrayWithCapacity:self.stickersInfo.count + 1];
    // add the default emoji view anyway
    BXMessagesInputStickerDefaultEmojiView *emojiView = [[BXMessagesInputStickerDefaultEmojiView alloc] init];
    emojiView.delegate = self;
    [self.cachedMainViewCandidates setObject:emojiView atIndexedSubscript:0];
    // add a customized sticker view
    BXMessagesInputCustomizedStickerView *stickerView = [[BXMessagesInputCustomizedStickerView alloc] initWithDelegate:self index:0];
    [self.cachedMainViewCandidates setObject:stickerView atIndexedSubscript:1];
    // default show the first view (emojis view)
    [self collectionView:self.stickersGalleryView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)initToolBar
{
    [self.toolBar addSubview:self.stickersGalleryView];
    [self.toolBar addSubview:self.sendButton];
    [self addSubview:self.toolBar];
    
    if (self.hasExtention) {
        [self.toolBar addSubview:self.addStickersButton];
        // arrange addStickersButton
        self.addStickersButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_addStickersButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addStickersButton)]];
        [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_addStickersButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addStickersButton)]];
    }

    // arrange stickersGalleryView
    self.stickersGalleryView.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.hasExtention) {
        [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_addStickersButton]-0-[_stickersGalleryView]-0-[_sendButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickersGalleryView,_addStickersButton,_sendButton)]];
    } else {
        [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_stickersGalleryView]-0-[_sendButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickersGalleryView,_sendButton)]];
    }
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_stickersGalleryView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickersGalleryView)]];
    
    // arrange sendButton
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sendButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_sendButton(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sendButton)]];
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sendButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sendButton)]];
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_sendButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sendButton)]];
    
    // arrange toolBar
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolBar)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_toolBar]-0-|",stickerViewHeight - toolBarHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolBar)]];
}

#pragma mark - UI Element Initializers
- (UIView *)stickerMainView
{
    if (!_stickerMainView) {
        _stickerMainView = [[UIView alloc] init];
        _stickerMainView.backgroundColor = [UIColor whiteColor];
    }
    return _stickerMainView;
}

- (UIView *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
    }
    return _toolBar;
}

- (UIButton *)addStickersButton
{
    if (!_addStickersButton) {
        _addStickersButton = [[UIButton alloc] init];
        [_addStickersButton setTitle:@"+" forState:UIControlStateNormal];
        _addStickersButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _addStickersButton.backgroundColor = [UIColor grayColor];
    }
    return _addStickersButton;
}

- (UICollectionView *)stickersGalleryView
{
    if (!_stickersGalleryView) {
        BXMessagesInputStickersGalleryViewLayout *layout = [[BXMessagesInputStickersGalleryViewLayout alloc] init];
        layout.numberOfItems = stickersCount;
        layout.itemSize = CGSizeMake(45, toolBarHeight);
        
        _stickersGalleryView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _stickersGalleryView.backgroundColor = [UIColor clearColor];
        _stickersGalleryView.scrollsToTop = NO;
        _stickersGalleryView.showsHorizontalScrollIndicator = YES;
        _stickersGalleryView.dataSource = self;
        _stickersGalleryView.delegate = self;
        [_stickersGalleryView registerClass:[BXMessagesInputStickersGalleryViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputStickersGalleryViewCell class])];
    }
    return _stickersGalleryView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.backgroundColor = [UIColor redColor];
        
        [_sendButton addTarget:self action:@selector(sendButtonTriggered) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (void)sendButtonTriggered
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputStickerView:selectedEmoji:)]) {
        [self.delegate bxMessagesInputStickerView:self sendButtonPressed:self.sendButton];
    }
}

#pragma mark - UICollectionViewDelegate & DataSource (for stickerGalleryView)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.stickersInfo.count + 1;    // first slot for emojis, others for stickers
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    BXMessagesInputStickersGalleryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BXMessagesInputStickersGalleryViewCell class]) forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[BXMessagesInputStickersGalleryViewCell alloc] init];
    }
    cell.previewImageView.image = row ? [self getStickerPreviewImageAtIndex:row - 1] : [UIImage imageNamed:@"test_icon.png"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // clean up stickerMainView first
    for (UIView *subViews in self.stickerMainView.subviews) {
        [subViews removeFromSuperview];
    }
    
    // show the new pack view
    NSInteger row = indexPath.row;
    if (row >= self.cachedMainViewCandidates.count) {
        return;
    }
    UIView *packView = [self.cachedMainViewCandidates objectAtIndex:row];
    [self.stickerMainView addSubview:packView];
    packView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[packView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(packView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[packView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(packView)]];
}

#pragma mark - BXMessagesInputCustomizedStickerViewDataSource
- (NSInteger)numberOfStickersOfPackAtIndex:(NSInteger)index
{
    return [self getStickerPackCountAtIndex:index];
}

- (UIImage *)imageOfStickersWithPackIndex:(NSInteger)packIndex stickerIndex:(NSInteger)stickerIndex
{
    return [self getStickerImagesAtIndex:packIndex][stickerIndex];
}

- (NSString *)nameOfStickersWithPackIndex:(NSInteger)packIndex stickerIndex:(NSInteger)stickerIndex
{
    return [NSString stringWithFormat:@"表情%ld",stickerIndex + 1];
}

#pragma mark - stickerInfo reader
- (NSUInteger)getStickerPackCountAtIndex:(NSUInteger)index
{
    NSDictionary *packInfo = [self.stickersInfo objectAtIndex:index];
    NSAssert(packInfo, @"packInfo is nil");
    NSNumber *count = [packInfo objectForKey:kStickerCount];
    NSAssert(count, @"pack count is nil");
    return [count integerValue];
}

- (UIImage *)getStickerPreviewImageAtIndex:(NSUInteger)index
{
    NSDictionary *packInfo = [self.stickersInfo objectAtIndex:index];
    NSAssert(packInfo, @"packInfo is nil");
    UIImage *previewImage = [packInfo objectForKey:kStickerPreviewImage];
    NSAssert(previewImage, @"pack previewImage is nil");
    return previewImage;
}

- (NSArray *)getStickerImagesAtIndex:(NSUInteger)index
{
    NSDictionary *packInfo = [self.stickersInfo objectAtIndex:index];
    NSAssert(packInfo, @"packInfo is nil");
    NSArray *images = [packInfo objectForKey:kStickerImages];
    NSAssert(images, @"pack images is nil");
    return images;
}

#pragma mark - BXMessagesInputStickerDefaultEmojiView delegate
- (void)bxMessagesInputStickerDefaultEmojiView:(BXMessagesInputStickerDefaultEmojiView *)emojiView selectedEmoji:(NSString *)emoji
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputStickerView:selectedEmoji:)]) {
        [self.delegate bxMessagesInputStickerView:self selectedEmoji:emoji];
    }
}

#pragma mark - BXMessagesInputCustomizedStickerView delegate
- (void)bxMessagesInputCustomizedStickerView:(BXMessagesInputCustomizedStickerView *)stickerView selectedSticker:(NSDictionary *)stickerInfo
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxMessagesInputStickerView:selectedSticker:)]) {
        [self.delegate bxMessagesInputStickerView:self selectedSticker:stickerInfo];
    }
}

@end