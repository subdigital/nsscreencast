//
//  MailMessageCell.h
//  SwipeToRevealCell
//
//  Created by ben on 2/10/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailMessageCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *senderLabel;
@property (nonatomic, strong) IBOutlet UILabel *subjectLabel;
@property (nonatomic, strong) IBOutlet UILabel *previewLabel;

@end
