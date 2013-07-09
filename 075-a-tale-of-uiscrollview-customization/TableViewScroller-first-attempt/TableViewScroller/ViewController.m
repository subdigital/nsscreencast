//
//  ViewController.m
//  TableViewScroller
//
//  Created by ben on 7/6/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) CGRect originalTableFrame;
@property (nonatomic, assign) BOOL decelerating;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadScrollerImages];
    [self addTableHeader];
    self.originalTableFrame = self.tableView.frame;
}

- (void)addTableHeader {
    CGFloat y = self.filterView.frame.origin.y;
    CGFloat height = self.filterView.frame.size.height;
    
    self.tableView.tableHeaderView = self.filterView;
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = y;
    tableFrame.size.height += height;
    self.tableView.frame = tableFrame;
}

- (void)loadScrollerImages {
    const int NumPages = 3;
    self.scrollView.contentSize = CGSizeMake(NumPages * self.view.frame.size.width, 200);
    self.scrollView.pagingEnabled = YES;
    for (int i = 0; i < NumPages; i++) {
        NSString *imageName = [NSString stringWithFormat:@"scroller-image-%d.jpg", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        CGRect frame = imageView.frame;
        frame.origin.x = i * self.view.frame.size.width;
        imageView.frame = frame;
        [self.scrollView addSubview:imageView];
    }
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"will end dragging, target: %@", NSStringFromCGPoint((*targetContentOffset)));
    self.decelerating = YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.decelerating = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    BOOL scrollingUp = offset.y > 0;
    BOOL adjustUp = (scrollingUp && self.tableView.frame.origin.y > 0);
    BOOL adjustDown = (!scrollingUp && self.tableView.frame.origin.y < self.scrollView.frame.size.height);
    CGFloat adjustment = fabsf(offset.y);
    
    if (self.decelerating) {
        // dampen the effect?
        adjustment = adjustment / 3.0f;
    }
    
    if (adjustUp) {
        // move table view up by offset & increase height
        CGRect frame = self.tableView.frame;
        frame.origin.y -= adjustment;
        frame.origin.y = MAX(0, frame.origin.y);
        frame.size.height += adjustment;
        frame.size.height = MIN(self.view.bounds.size.height, frame.size.height);
        self.tableView.frame = frame;
        
        // reset content offset
        self.tableView.contentOffset = CGPointZero;
    } else if (adjustDown) {
        // move table view down by offset & decrease height
        CGRect frame = self.tableView.frame;
        frame.origin.y += adjustment;
        frame.origin.y = MIN(self.originalTableFrame.origin.y, frame.origin.y);
        frame.size.height -= adjustment;
        frame.size.height = MAX(self.originalTableFrame.size.height, frame.size.height);
        self.tableView.frame = frame;
        
        // reset content offset
        self.tableView.contentOffset = CGPointZero;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arc4random() % 10 + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section %d", section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell %d:%d", indexPath.section, indexPath.row];
    return cell;
}

@end
