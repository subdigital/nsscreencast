//
//  BLLatteGridViewController.m
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLLatteGridViewController.h"
#import <KKGridView/KKGridView.h>
#import "BLLatte.h"
#import "BLLatteCell.h"
#import "BLLatteViewController.h"
#import "BLNotifications.h"

@interface BLLatteGridViewController ()

@property (nonatomic, strong) KKGridView *gridView;
@property (nonatomic, strong) NSMutableArray *lattes;

@end

@implementation BLLatteGridViewController

@synthesize gridView = _gridView;
@synthesize lattes = _lattes;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gridView = [self setupLatteGrid];
    [self.view addSubview:self.gridView];
    
    self.title = @"Best Latte";
    self.navigationItem.rightBarButtonItem = [self submitButton];
    
    [self listenForCreatedLattes];
    [self loadLattes];
}

- (void)listenForCreatedLattes {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(latteCreated:)
                                                 name:BLLatteCreatedNotification
                                               object:nil];
}

- (UIBarButtonItem *)submitButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                         target:self
                                                         action:@selector(addLatte:)];
}

- (KKGridView *)setupLatteGrid {
    KKGridView *gridView = [[KKGridView alloc] initWithFrame:self.view.bounds];
    gridView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    const CGFloat ThumbSize = 50.0;
    const CGFloat Padding = 2;
    gridView.numberOfItemsInSectionBlock = ^(KKGridView *gv, NSUInteger section) {
        return self.lattes.count;
    };
    gridView.cellSize = CGSizeMake(ThumbSize, ThumbSize);
    gridView.cellPadding = CGSizeMake(Padding, Padding);
    gridView.cellBlock = ^(KKGridView *gv, KKIndexPath *indexPath) {
        BLLatte *latte = [self.lattes objectAtIndex:indexPath.index];
        BLLatteCell *cell = [BLLatteCell cellForGridView:gv];
        [cell setLatte:latte];
        return cell;
    };
    gridView.didSelectIndexPathBlock = ^(KKGridView *gv, KKIndexPath *indexPath) {
        BLLatte *selectedLatte = [self.lattes objectAtIndex:indexPath.index];
        BLLatteViewController *latteVC = [[BLLatteViewController alloc] initWithLatte:selectedLatte];
        [self.navigationController pushViewController:latteVC animated:YES];
    };
    return gridView;
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)loadLattes {
    [BLLatte fetchLattes:^(NSArray *lattes, NSError *error) {
        if (lattes) {
            NSLog(@"Received %d lattes", lattes.count);
            self.lattes = [NSMutableArray arrayWithArray:lattes];
            [self.gridView reloadData];
            [self.gridView setNeedsLayout];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"ERROR"
                                        message:@"Couldn't fetch the lattes."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
}

- (void)addLatte:(id)sender {

    UIStoryboard *addLatteStoryBoard = [UIStoryboard storyboardWithName:@"BLAddLatteStoryboard"
                                                                 bundle:nil];
    id vc = [addLatteStoryBoard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)latteCreated:(NSNotification *)notification {
    [self.lattes insertObject:notification.object atIndex:0];
    KKIndexPath *firstItemPath = [KKIndexPath indexPathForIndex:0 inSection:0];
    [self.gridView insertItemsAtIndexPaths:[NSArray arrayWithObject:firstItemPath]
                             withAnimation:KKGridViewAnimationSlideRight];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
