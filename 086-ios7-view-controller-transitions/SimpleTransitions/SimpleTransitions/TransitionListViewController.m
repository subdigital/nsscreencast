//
//  TransitionListViewController.m
//  SimpleTransitions
//
//  Created by ben on 9/14/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "TransitionListViewController.h"
#import "ColorViewController.h"
#import "SwatchTransition.h"

enum TransitionTypes {
    TransitionTypeSwatch = 0,
    TransitionTypeCount
};

@interface TransitionListViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation TransitionListViewController

#pragma mark - Table view data source

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TransitionTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case TransitionTypeSwatch:
            cell.textLabel.text = @"Swatch";
            break;
            
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ColorViewController *vc = [[ColorViewController alloc] initWithColor:[UIColor redColor]];
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:vc animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    SwatchTransition *transition = [[SwatchTransition alloc] init];
    transition.mode = SwatchTransitionModePresent;
    return transition;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    SwatchTransition *transition = [[SwatchTransition alloc] init];
    transition.mode = SwatchTransitionModeDismiss;
    return transition;
}


@end
