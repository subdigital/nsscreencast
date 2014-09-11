//
//  GameBoardView.h
//  ConnectFour
//
//  Created by Ben Scheirman on 8/16/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameBoardView : UIView

@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger columns;

- (id)initWithRows:(NSInteger)rows columns:(NSInteger)columns;

- (CGSize)pieceSize;

@end
