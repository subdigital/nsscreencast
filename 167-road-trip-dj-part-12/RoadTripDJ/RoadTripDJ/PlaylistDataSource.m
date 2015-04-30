//
//  PlaylistDataSource.m
//  RoadTripDJ
//
//  Created by Ben Scheirman on 3/11/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import "PlaylistDataSource.h"
#import "PlaylistItemCollectionViewCell.h"

@implementation PlaylistDataSource

- (void)setPlaylistHeaderView:(PlaylistHeaderView *)playlistHeaderView {
    _playlistHeaderView = playlistHeaderView;
    
    if (self.items.count > 0) {
        id<PlaylistItem> item = self.items[_currentTrackIndex];
        [self.playlistHeaderView setPlaylistItem:item animated:NO];
    }
}

- (void)setCurrentTrackIndex:(NSInteger)currentTrackIndex {
    _currentTrackIndex = currentTrackIndex;

    if (_currentTrackIndex >= (NSInteger)self.items.count) {
        _currentTrackIndex = 0;
    } else if(_currentTrackIndex < 0) {
        _currentTrackIndex = self.items.count - 1;
    }
    
    id<PlaylistItem> item = self.items[_currentTrackIndex];
    [self.playlistHeaderView setPlaylistItem:item animated:YES];
    
    if (self.items.count > _currentTrackIndex + 1) {
        NSIndexPath *nextTrackIndexPath = [NSIndexPath indexPathForItem:_currentTrackIndex + 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextTrackIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionTop
                                            animated:YES];
    } else if (self.items.count - 1 == _currentTrackIndex) {
        NSIndexPath *firstTrackIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:firstTrackIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionTop
                                            animated:YES];
    }
}

- (void)setItems:(NSArray *)items {
    _items = items;
    if (self.items.count > 0) {
        id<PlaylistItem> item = self.items[_currentTrackIndex];
        [self.playlistHeaderView setPlaylistItem:item animated:YES];
    }
    [self.collectionView reloadData];
    if (self.items.count > 1) {
        NSIndexPath *nextTrackIndexPath = [NSIndexPath indexPathForItem:_currentTrackIndex + 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextTrackIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionTop
                                            animated:NO];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlaylistItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    
    id<PlaylistItem> playlistItem = self.items[indexPath.row];
    cell.imageView.image = playlistItem.image;
    cell.artistLabel.text = playlistItem.artist;
    cell.songLabel.text = playlistItem.title;
    
    return cell;
}

@end
