//
//  MailMessageCell.m
//  SwipeToRevealCell
//
//  Created by ben on 2/10/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "MailMessageCell.h"

const CGFloat kRevealWidth = 160.0;
static NSString *RevealCellDidOpenNotification = @"RevealCellDidOpenNotification";

@interface MailMessageCell () {
    BOOL _isOpen;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *innerContentView;

@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation MailMessageCell

- (void)awakeFromNib {
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.moreButton.backgroundColor = [UIColor colorWithWhite:0.76 alpha:1.0];
    self.moreButton.frame = CGRectMake(0, 0, kRevealWidth / 2.0, self.contentView.frame.size.height);
    [self.moreButton setTitle:@"More..." forState:UIControlStateNormal];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.deleteButton.backgroundColor = [UIColor redColor];
    self.deleteButton.frame = CGRectMake(self.moreButton.frame.size.width, 0, kRevealWidth / 2.0, self.contentView.frame.size.height);
    [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    
    self.buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRevealWidth, self.deleteButton.frame.size.height)];
    [self.buttonContainerView addSubview:self.moreButton];
    [self.buttonContainerView addSubview:self.deleteButton];
    
    [self.scrollView insertSubview:self.buttonContainerView
                       belowSubview:self.innerContentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onOpen:)
                                                 name:RevealCellDidOpenNotification
                                               object:nil];
}

- (void)onOpen:(NSNotification *)notification {
    if (notification.object != self) {
        if (_isOpen) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [UIView animateWithDuration:0.25
                                animations:^{
                                    self.scrollView.contentOffset = CGPointZero;
                                }];
            });
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width + kRevealWidth, self.scrollView.frame.size.height);
    
    [self repositionButtons];
}

- (void)repositionButtons {
    CGRect frame = self.buttonContainerView.frame;
    frame.origin.x = self.contentView.frame.size.width - kRevealWidth + self.scrollView.contentOffset.x;
    self.buttonContainerView.frame = frame;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self repositionButtons];
    
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    if (scrollView.contentOffset.x >= kRevealWidth) {
        _isOpen = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:RevealCellDidOpenNotification
                                                            object:self];
    } else {
        _isOpen = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.x > 0) {
        (*targetContentOffset).x = kRevealWidth;
    } else {
        (*targetContentOffset).x = 0;
    }
}

@end
