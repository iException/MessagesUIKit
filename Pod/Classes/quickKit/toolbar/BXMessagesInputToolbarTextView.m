//
//  BXMessagesInputToolbarTextView.m
//  Baixing
//
//  Created by hyice on 15/3/17.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputToolbarTextView.h"
#import "NSBundle+MessagesUIKit.h"
#import "UIImage+MessagesUIKit.h"

static const CGFloat kBXMessagesInputToolbarTextViewMinHeight = 44;

@interface BXMessagesInputToolbarTextView()

@property (strong, nonatomic) UIImageView *background;

@property (strong, nonatomic) UITextView *textView;

@property (weak, nonatomic) NSLayoutConstraint *textViewLeftConstraint;
@property (weak, nonatomic) NSLayoutConstraint *textViewRightConstraint;
@property (weak, nonatomic) NSLayoutConstraint *textViewTopConstraint;
@property (weak, nonatomic) NSLayoutConstraint *textViewBottomConstraint;

@end

@implementation BXMessagesInputToolbarTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.flexibleWidth = YES;
        self.flexibleHeight = NO;
        
        self.height = kBXMessagesInputToolbarTextViewMinHeight;
        
        _textViewInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.maxVisibleNumberOfLines = 5;
        
        [self initBackground];
        [self initTextView];
        
        self.backgroundImage = [UIImage buk_imageNamed:@"buk-toolbar-whitebg"];
        self.textViewInsets = UIEdgeInsetsMake(9, 3, 9, 3);

    }
    
    return self;
}

#pragma mark - background
- (void)initBackground
{
    [self addSubview:self.background];
    
    self.background.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_background]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_background)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_background]-6-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_background)]];
}

- (UIImageView *)background
{
    if (!_background) {
        _background = [[UIImageView alloc] init];
    }
    
    return _background;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    [self.background setImage:[backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2.0
                                                                   topCapHeight:backgroundImage.size.height/2.0]];
}

#pragma mark - text view
- (void)initTextView
{
    [self addSubview:self.textView];
    
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.textViewInsets.top];
    [self addConstraint:self.textViewTopConstraint];
    
    self.textViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.textViewInsets.bottom];
    [self addConstraint:self.textViewBottomConstraint];
    
    self.textViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.textViewInsets.left];
    [self addConstraint:self.textViewLeftConstraint];
    
    self.textViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.textViewInsets.right];
    [self addConstraint:self.textViewRightConstraint];
    
    [self addTextViewKVOObersers];
    [self addTextViewEventObservers];
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.scrollsToTop = NO;
    }
    
    return _textView;
}

- (void)setTextViewInsets:(UIEdgeInsets)textViewInsets
{
    _textViewInsets = textViewInsets;
    
    self.textViewLeftConstraint.constant = textViewInsets.left;
    self.textViewRightConstraint.constant = -textViewInsets.right;
    self.textViewTopConstraint.constant = textViewInsets.top;
    self.textViewBottomConstraint.constant = -textViewInsets.bottom;
}

#pragma mark - auto height change kvo
- (void)addTextViewKVOObersers
{
    @try {
        [self.textView addObserver:self
                        forKeyPath:NSStringFromSelector(@selector(contentSize))
                           options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                           context:nil];
        [self.textView addObserver:self forKeyPath:NSStringFromSelector(@selector(text)) options:NSKeyValueObservingOptionInitial context:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"BXMessageKit: Add KVO to textView's contentSize error!");
    }
}

- (void)removeTextViewKVOObservers
{
    @try {
        [self.textView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
        [self.textView removeObserver:self forKeyPath:NSStringFromSelector(@selector(text))];
    }
    @catch (NSException *exception) {
        NSLog(@"BXMessageKit: Remove KVO from textView's contentSize error!");
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.textView
        && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        
        CGSize size = [self.textView.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.textView.frame),
                                                                          CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:self.textView.font}
                                                       context:nil].size;
        
        NSInteger numberOfLines = MAX(size.height / self.textView.font.lineHeight,
                                             self.textView.contentSize.height * 1.0 / self.textView.font.lineHeight);
        numberOfLines = MIN(self.maxVisibleNumberOfLines, numberOfLines);
        
        CGFloat needHeight = self.textView.font.lineHeight * numberOfLines + self.textViewInsets.top + self.textViewInsets.bottom;
        self.height = MAX(needHeight, kBXMessagesInputToolbarTextViewMinHeight);

        CGFloat offset = self.textView.contentSize.height - CGRectGetHeight(self.textView.bounds);
        if (offset < 0) {
            offset = (kBXMessagesInputToolbarTextViewMinHeight - needHeight) / 2.0;
        }
        self.textView.contentOffset = CGPointMake(0.0f, offset);
    }else if (object == self.textView && [keyPath isEqualToString:NSStringFromSelector(@selector(text))]) {

        CGFloat offset = self.textView.contentSize.height - CGRectGetHeight(self.textView.bounds);
        self.textView.contentOffset = CGPointMake(0.0f, offset < 0? offset/2.0 : offset);
    }
}

#pragma mark - vertical center alignment
- (void)addTextViewEventObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)removeTextViewEventObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textViewDidBeginEditingNotification:(NSNotification *)notification
{
    CGFloat offset = self.textView.contentSize.height - CGRectGetHeight(self.textView.bounds);
    self.textView.contentOffset = CGPointMake(0.0f, offset < 0? offset/2.0 : offset);
}

- (void)textViewTextDidChangeNotification:(NSNotification *)notification
{
    if (self.textView.text.length > 1000) {
        self.textView.text = [self.textView.text substringToIndex:1000];
    }
}
#pragma mark -
- (void)dealloc
{
    [self removeTextViewKVOObservers];
    [self removeTextViewEventObservers];
}
@end
