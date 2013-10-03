//
//  TVShowCell.h
//  TuneStore
//
//  Created by ben on 9/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *collectionNameLabel;

@property (nonatomic, strong) NSURLSessionDataTask *imageDownloadTask;

@end
