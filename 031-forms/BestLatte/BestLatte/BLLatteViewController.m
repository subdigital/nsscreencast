//
//  BLLatteViewController.m
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLLatteViewController.h"
#import "UIImageView+AFNetworking.h"

@interface BLLatteViewController ()

@property (nonatomic, strong) BLLatte *latte;

// outlets
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation BLLatteViewController

- (id)initWithLatte:(BLLatte *)latte {
    self = [super initWithNibName:@"BLLatteViewController" bundle:nil];
    if (self) {
        self.latte = latte;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Latte #%d", self.latte.serverId];

    NSURL *imageUrl = [NSURL URLWithString:self.latte.largeUrl];
    [self.imageView setImageWithURL:imageUrl];
    self.imageView.clipsToBounds = YES;
    
    self.commentsLabel.text = self.latte.comments;
    self.locationLabel.text = self.latte.location;
    self.authorLabel.text = self.latte.submittedBy;
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setCommentsLabel:nil];
    [self setLocationLabel:nil];
    [self setAuthorLabel:nil];

    [super viewDidUnload];
}

@end
