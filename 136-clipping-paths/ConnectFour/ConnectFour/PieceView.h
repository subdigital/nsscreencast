//
//  PieceView.h
//  ConnectFour
//
//  Created by Ben Scheirman on 8/29/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PieceColor) {
    PieceColorRed,
    PieceColorBlack
};

@interface PieceView : UIView

- (id)initWithFrame:(CGRect)frame pieceColor:(PieceColor)pieceColor;

@end
