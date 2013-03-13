//
//  FacebookFriendsViewController.m
//  SocialApp
//
//  Created by ben on 3/2/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "FacebookFriendsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface FacebookFriendsViewController ()

@property (nonatomic, strong) NSArray *friendsList;

@end

@implementation FacebookFriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIBarButtonItem *)postButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                         target:self
                                                         action:@selector(onPost:)];
}

- (void)onPost:(id)sender {
    // NSString *initialText = @"Posting from iOS 6 😏";
    // TODO
}

- (UIBarButtonItem *)doneButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                         target:self
                                                         action:@selector(onDone:)];
}

- (void)onDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Facebook Friends";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.099 green:0.367 blue:0.654 alpha:1.000];
    self.navigationItem.leftBarButtonItem = [self postButton];
    self.navigationItem.rightBarButtonItem = [self doneButton];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.accountStore requestAccessToAccountsWithType:fbAccountType
                                               options:options
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    NSLog(@"Granted!");
                                                    ACAccount *account = [[self.accountStore accountsWithAccountType:fbAccountType] lastObject];
                                                    [self fetchFacebookFriendsFor:account];
                                                } else {
                                                    NSLog(@"Not granted: %@", error);
                                                    [[[UIAlertView alloc] initWithTitle:@"Facebook Permissions Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil] show];
                                                }
                                            }];
}

- (void)fetchFacebookFriendsFor:(ACAccount *)facebookAccount {
    SLRequest *friendsRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                   requestMethod:SLRequestMethodGET
                                                             URL:URLIFY(@"https://graph.facebook.com/me/friends")
                                                      parameters:nil];
    friendsRequest.account = facebookAccount;
    [friendsRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSLog(@"Got a response: %@", [[NSString alloc] initWithData:responseData
                                                               encoding:NSUTF8StringEncoding]);
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError = nil;
                NSDictionary *friendsListData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                options:NSJSONReadingAllowFragments
                                                                                  error:&jsonError];
                if (jsonError) {
                    NSLog(@"Error parsing friends list: %@", jsonError);
                } else {
                    self.friendsList = friendsListData[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }
        } else {
            NSLog(@"ERROR Connecting");
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *friendData = self.friendsList[indexPath.row];
    cell.textLabel.text = friendData[@"name"];
    
    UIImage *defaultAvatar = [UIImage imageNamed:@"facebook_avatar.png"];
    NSURL *friendImageUrl = URLIFY(F(@"https://graph.facebook.com/%@/picture", friendData[@"id"]));
    cell.imageView.contentMode = UIViewContentModeCenter;   
    [cell.imageView setImageWithURL:friendImageUrl placeholderImage:defaultAvatar];
    
    return cell;
}

@end
