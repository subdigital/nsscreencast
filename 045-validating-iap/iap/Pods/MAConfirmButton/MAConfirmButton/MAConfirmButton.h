//
//  MAConfirmButton.h
//
//  Created by Mike on 11-03-28.
//  Copyright 2011 Mike Ahmarani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class MAConfirmButtonOverlay;

typedef enum {
  MAConfirmButtonToggleAnimationLeft = 0,
  MAConfirmButtonToggleAnimationRight = 1,
  MAConfirmButtonToggleAnimationCenter =2

} MAConfirmButtonToggleAnimation;

@interface MAConfirmButton : UIButton {

@private
	BOOL selected;
	BOOL confirmed;
	CALayer *colorLayer;
	CALayer *darkenLayer;
	UIButton *cancelOverlay;
}

@property (nonatomic, assign) MAConfirmButtonToggleAnimation toggleAnimation;

+ (MAConfirmButton *)buttonWithTitle:(NSString *)titleString confirm:(NSString *)confirmString;
+ (MAConfirmButton *)buttonWithDisabledTitle:(NSString *)disabledString;
- (id)initWithTitle:(NSString *)titleString confirm:(NSString *)confirmString;
- (id)initWithDisabledTitle:(NSString *)disabledString;
- (void)disableWithTitle:(NSString *)disabledString;
- (void)setAnchor:(CGPoint)anchor;
- (void)setTintColor:(UIColor *)color;

@end
