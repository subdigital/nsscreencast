//
//  NSCRViewController.m
//  nsscreencast
//
//  Created by Ben Scheirman on 6/11/12.
//  Copyright (c) 2012 Ben Scheirman. All rights reserved.
//

#import "NSCREpisodesViewController.h"
#import "NSCRNavigationBar.h"

@interface NSCREpisodesViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSArray *episodes;
@end

@implementation NSCREpisodesViewController

- (void)refresh {
}

- (void)displayAlert:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.title = @"Home";
    
    NSCRLogoView *logoView =[NSCRNavigationBar logoTitleView];
    self.navigationItem.titleView = logoView;
    [logoView flash];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.backgroundView = backgroundView;
    self.tableView.separatorColor = [UIColor lightGrayColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.episodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EpisodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
