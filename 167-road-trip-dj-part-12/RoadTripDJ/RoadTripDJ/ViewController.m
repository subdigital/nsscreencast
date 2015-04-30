//
//  ViewController.m
//  RoadTripDJ
//
//  Created by Ben Scheirman on 2/3/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import "ViewController.h"
#import "PlaylistDataSource.h"
#import "SamplePlaylistItem.h"
#import "PlaylistHeaderView.h"
@import MediaPlayer;

@interface ViewController () <MPMediaPickerControllerDelegate>

@property (nonatomic, strong) MPMediaItemCollection *playlist;
@property (nonatomic, strong) MPMusicPlayerController *player;
//@property (nonatomic, strong) UIBarButtonItem *playButton;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet PlayerBar *playerBar;
@property (nonatomic, weak) IBOutlet UIView *headerContainerView;
@property (nonatomic, strong) IBOutlet PlaylistDataSource *playlistDataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player = [[MPMusicPlayerController alloc] init];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(-64, 0, 44, 0);
    UINib *headerNib = [UINib nibWithNibName:@"PlaylistHeaderView" bundle:nil];
    NSArray *objects = [headerNib instantiateWithOwner:self
                                               options:nil];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGSize itemSize = flowLayout.itemSize;
    itemSize.width = self.collectionView.frame.size.width;
    flowLayout.itemSize = itemSize;
    
    PlaylistHeaderView *header = [objects firstObject];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.headerContainerView addSubview:header];
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[header]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(header)];
    constraints = [constraints arrayByAddingObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(header)]];
    [NSLayoutConstraint activateConstraints:constraints];
    
    
#if TARGET_IPHONE_SIMULATOR
    NSArray *items = @[
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"inutero.jpg"] artist:@"Nirvana" title:@"Heart-Shaped Box"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"inrainbows.jpg"] artist:@"Radiohead" title:@"House of Cards"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"aenima.jpg"] artist:@"Tool" title:@"Forty-six and Two"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"meddle.jpg"] artist:@"Pink Floyd" title:@"Echoes"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"andjustice.jpg"] artist:@"Metallica" title:@"One"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"bloodsugar.jpg"] artist:@"Red Hot Chili Peppers" title:@"Give it Away"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"inrainbows.jpg"] artist:@"Radiohead" title:@"House of Cards"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"ten.jpg"] artist:@"Pearl Jam" title:@"Ten"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"darkside.jpg"] artist:@"Pink Floyd" title:@"The Great Gig in the Sky"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"dummy.jpg"] artist:@"Portishead" title:@"Strangers"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"suburbs.jpg"] artist:@"Arcade Fire" title:@"Modern Man"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"housesoftheholy.jpg"] artist:@"Led Zeppelin" title:@"No Quarter"],
                       [[SamplePlaylistItem alloc] initWithImage:[UIImage imageNamed:@"kindofblue.jpg"] artist:@"Miles Davis" title:@"Freddie Freeloader"]
                       ];

    self.playlistDataSource.items = items;
    self.playerBar.enabled = YES;
#endif
    
    self.playlistDataSource.playlistHeaderView = header;
}

- (UIBarButtonItem *)playButtonItemForPlaybackState:(MPMusicPlaybackState)state {
    UIBarButtonSystemItem systemItem;
    if (state == MPMusicPlaybackStatePlaying) {
        systemItem = UIBarButtonSystemItemPause;
    } else {
        systemItem = UIBarButtonSystemItemPlay;
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem
                                                                                target:self
                                                                                action:@selector(playPause:)];
    return buttonItem;
}

- (void)togglePlayPause {
    if (self.player.playbackState == MPMusicPlaybackStatePlaying) {
        NSLog(@"pausing");
        [self.player pause];
        [self.playerBar setPlayButtonState:NO];

    } else {
        NSLog(@"playing");
        [self.player play];
        [self.playerBar setPlayButtonState:YES];
    }
}

#pragma mark - Actions

- (IBAction)playPause:(id)sender {
    [self togglePlayPause];
}

- (IBAction)addMusic:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.prompt = @"Add music to your playlist";
    mediaPicker.showsCloudItems = YES;
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (!self.playlist) {
        self.playlist = mediaItemCollection;
    } else {
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:self.playlist.count + mediaItemCollection.count];
        [items addObjectsFromArray:self.playlist.items];
        [items addObjectsFromArray:mediaItemCollection.items];
        MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:items];
        self.playlist = collection;
    }
    
    self.playerBar.enabled = YES;
    
    int index = 1;
    for (MPMediaItem *item in self.playlist.items) {
        NSLog(@"%d) %@ - %@", index++, item.artist, item.title);
    }
    
    [self.player setQueueWithItemCollection:self.playlist];
    self.playlistDataSource.items = self.playlist.items;
        
    if (self.player.playbackState != MPMusicPlaybackStatePlaying) {
        [self togglePlayPause];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PlayerBarDelegate

- (void)playerBarNextTrack:(PlayerBar *)playerBar {
    self.playlistDataSource.currentTrackIndex += 1;
}

- (void)playerBarPreviousTrack:(PlayerBar *)playerBar {
    self.playlistDataSource.currentTrackIndex -= 1;
}

- (void)playerBarPlayPause:(PlayerBar *)playerBar {
    [self togglePlayPause];
}

@end
