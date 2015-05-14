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

@interface ViewController () <MPMediaPickerControllerDelegate, UICollectionViewDelegate> {
    BOOL _panning;
}

@property (nonatomic, strong) MPMediaItemCollection *playlist;
@property (nonatomic, strong) MPMusicPlayerController *player;
@property (nonatomic, strong) NSTimer *progressTimer;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet PlayerBar *playerBar;
@property (nonatomic, weak) IBOutlet UIView *headerContainerView;
@property (nonatomic, strong) IBOutlet PlaylistDataSource *playlistDataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player = [MPMusicPlayerController systemMusicPlayer];
    [self.player stop];
    [self.player setQueueWithItemCollection:nil];
    [self listenForPlayerNotifications];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(-64, 0, 44, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(-64, 0, 44, 0);

    UINib *headerNib = [UINib nibWithNibName:@"PlaylistHeaderView" bundle:nil];
    NSArray *objects = [headerNib instantiateWithOwner:self
                                               options:nil];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGSize itemSize = flowLayout.itemSize;
    itemSize.width = self.collectionView.frame.size.width;
    flowLayout.itemSize = itemSize;
    
    PlaylistHeaderView *header = [objects firstObject];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(headerPan:)];
    [header addGestureRecognizer:pan];
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

- (void)listenForPlayerNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(handleTrackChange:)
               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
             object:nil];
    [nc addObserver:self
           selector:@selector(handleStateChange:)
               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
             object:nil];
    [self.player beginGeneratingPlaybackNotifications];
}

- (void)handleTrackChange:(NSNotification *)note {
    NSInteger index = [self.playlist.items indexOfObject:self.player.nowPlayingItem];
    self.playlistDataSource.currentTrackIndex = index;
}

- (void)handleStateChange:(NSNotification *)note {
    BOOL isPlaying = self.player.playbackState == MPMusicPlaybackStatePlaying;
    [self.playerBar setPlayButtonState:isPlaying];
    
    if (isPlaying) {
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                              target:self
                                                            selector:@selector(tick)
                                                            userInfo:nil
                                                             repeats:YES];
    } else {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}

- (void)headerPan:(UIPanGestureRecognizer *)pan {

    PlaylistHeaderView *headerView = self.playlistDataSource.playlistHeaderView;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _panning = YES;
            
        case UIGestureRecognizerStateChanged: {
            CGFloat x = [pan translationInView:headerView].x;
            CGFloat percent = x / headerView.bounds.size.width;
            headerView.progress += percent;
            [pan setTranslation:CGPointZero inView:headerView];
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            NSTimeInterval total = self.player.nowPlayingItem.playbackDuration;
            NSTimeInterval current = headerView.progress * total;
            self.player.currentPlaybackTime = current;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            _panning = NO;
            
        default:
            break;
    }

 }


- (void)tick {
    if (_panning) {
        return;
    }
    
    NSTimeInterval total = self.player.nowPlayingItem.playbackDuration;
    NSTimeInterval current = self.player.currentPlaybackTime;
    CGFloat progress = current / total;
    self.playlistDataSource.playlistHeaderView.progress = progress;
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
    } else {
        NSLog(@"playing");
        [self.player play];
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
   
#if !TARGET_IPHONE_SIMULATOR
    [self.player skipToNextItem];
#endif
}

- (void)playerBarPreviousTrack:(PlayerBar *)playerBar {
    self.playlistDataSource.currentTrackIndex -= 1;

#if !TARGET_IPHONE_SIMULATOR
    [self.player skipToPreviousItem];
#endif

}

- (void)playerBarPlayPause:(PlayerBar *)playerBar {
    [self togglePlayPause];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // if this item is already selected, do nothing
    if (indexPath.row == self.playlistDataSource.currentTrackIndex) {
        return;
    }
    
    self.playlistDataSource.currentTrackIndex = indexPath.row;
    
#if !TARGET_IPHONE_SIMULATOR
    MPMediaItem *item = self.playlist.items[indexPath.row];
    [self.player setNowPlayingItem:item];
    
    if (self.player.playbackState == MPMusicPlaybackStateStopped ||
        self.player.playbackState == MPMusicPlaybackStatePaused) {
        [self.player play];
    }
#endif
}

@end
