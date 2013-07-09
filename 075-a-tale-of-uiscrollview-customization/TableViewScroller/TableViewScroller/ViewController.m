//
//  ViewController.m
//  TableViewScroller
//
//  Created by ben on 7/6/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *outerScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadScrollerImages];
    [self addTableHeader];
    
    self.outerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.outerScrollView.delegate = self;
    self.outerScrollView.showsVerticalScrollIndicator = NO;
    
    // force the table to resize the content
    [self.tableView reloadData];
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.tableView.contentSize.height;
    self.tableView.frame = tableFrame;
    
    // add the views to the scroll view instead
    [self.outerScrollView addSubview:self.scrollView];
    [self.outerScrollView addSubview:self.tableView];
    
    // set the content size
    self.outerScrollView.contentSize = CGSizeMake(self.outerScrollView.frame.size.width,
                                                    self.scrollView.frame.size.height +
                                                    self.tableView.frame.size.height
                                                  );
    
    [self.view addSubview:self.outerScrollView];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.outerScrollView) {
        CGRect frame = self.scrollView.frame;
        frame.origin.y = scrollView.contentOffset.y;
        self.scrollView.frame = frame;
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
