//
//  ViewController.m
//  CacheClient
//
//  Created by Ben Scheirman on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *contacts;
@end

@implementation ViewController

@synthesize contacts = _contacts;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Contacts";
    
    self.navigationItem.rightBarButtonItem = [self refreshButton];
    
    [self refresh];
}

- (UIBarButtonItem *)refreshButton {
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(refresh)];
    return refreshButton;
}

- (void)displayError {
    [[[UIAlertView alloc] initWithTitle:@"Ooops!"
                                message:@"Something went wrong.  Try again later."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)refresh {
    NSURL *url = [NSURL URLWithString:@"http://cache-tester.herokuapp.com/contacts.json"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *op;
    op = [AFJSONRequestOperation JSONRequestOperationWithRequest:req
                                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                             self.contacts = JSON;
                                                             [self.tableView reloadData];
                                                         } failure:^(NSURLRequest *request, 
                                                                     NSHTTPURLResponse *response, 
                                                                     NSError *error, id JSON) {
                                                             [self displayError];
                                                         }];
    [op start];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:identifier];
    }
    
    id contact = [self.contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = [contact objectForKey:@"name"];
    cell.detailTextLabel.text = [contact objectForKey:@"email"];
    
    return cell;
}

@end
