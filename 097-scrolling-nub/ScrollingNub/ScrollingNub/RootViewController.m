//
//  RootViewController.m
//  ScrollingNub
//
//  Created by ben on 11/25/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *scrollingNub;
@property (nonatomic, assign) BOOL scrubbing;


@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"DropBag";
    }
    return self;
}

- (void)loadView {
    // view
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.autoresizesSubviews = YES;
    
    // tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.scrollingNub = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    self.scrollingNub.backgroundColor = [UIColor greenColor];
    self.scrollingNub.layer.cornerRadius = 12;
    self.scrollingNub.alpha = 0;
    [self.view addSubview:self.scrollingNub];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onNubScrub:)];
    [self.scrollingNub addGestureRecognizer:pan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];
}

- (void)onNubScrub:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.scrollingNub.backgroundColor = [UIColor blueColor];
        self.scrubbing = YES;
    } else if (pan.state != UIGestureRecognizerStateChanged) {
        self.scrollingNub.backgroundColor = [UIColor greenColor];
        self.scrubbing = NO;
        [self hideNubAfterDelay];
    }
    
    CGFloat translation = [pan translationInView:self.view].y;
    
    CGFloat minY = self.tableView.contentInset.top + 10;
    CGFloat maxY = self.view.bounds.size.height - self.scrollingNub.bounds.size.height - 10;
    
    CGRect rect = self.scrollingNub.frame;
    rect.origin.y += translation;
    rect.origin.y = MAX(rect.origin.y, minY);
    rect.origin.y = MIN(rect.origin.y, maxY);
    self.scrollingNub.frame = rect;
    
    // y = p * (maxY - minY) + minY
    // y - minY
    // ---------     = p
    // (maxY - minY)
    CGFloat percent = (rect.origin.y - minY ) / (maxY - minY );
    percent = MIN(percent, 1);
    percent = MAX(percent, 0);
    
    CGFloat minOffset = - self.tableView.contentInset.top;
    CGFloat maxOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    CGFloat scrollOffset = percent * (maxOffset - minOffset) + minOffset;
    
    CGPoint offset = CGPointMake(0, scrollOffset);
    [self.tableView setContentOffset:offset];
    
    [pan setTranslation:CGPointZero inView:self.view];
}

- (CGFloat)percentageThroughContent {
    CGFloat bottomY = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    if (bottomY == 0) {
        return 0;
    }
    
    return self.tableView.contentOffset.y / bottomY;
}

- (CGFloat)nubY {
    CGFloat minY = self.tableView.contentInset.top + 10;
    CGFloat maxY = self.view.bounds.size.height - self.scrollingNub.bounds.size.height - 10;
    
    return [self percentageThroughContent] * (maxY - minY ) + minY;
}

- (void)repositionNub {
    CGRect rect = self.scrollingNub.frame;
    rect.origin.x = self.view.bounds.size.width - self.scrollingNub.frame.size.width - 10;
    rect.origin.y = [self nubY];
    self.scrollingNub.frame = rect;
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %d", indexPath.row];
    return cell;
}

- (void)animateNumbAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollingNub.alpha = alpha;
    }];
}

- (void)hideNubAfterDelay {
    double delayInSeconds = 0.75;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (!self.scrubbing && ![self.tableView isDecelerating]) {
            [self animateNumbAlpha:0];
        }
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrubbing) {
        return;
    }
    
    if (self.scrollingNub.alpha == 0) {
        [self animateNumbAlpha:1];
    }

    [self repositionNub];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self hideNubAfterDelay];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self hideNubAfterDelay];
}



@end
