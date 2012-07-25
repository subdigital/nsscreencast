//
//  BSModalPickerView.h
//  CustomPicker
//
//  Created by Ben Scheirman on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BSModalPickerViewCallback)(BOOL madeChoice);

@interface BSModalPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSString *selectedValue;
@property (nonatomic, retain) NSArray *values;

/* Initializes a new instance of the picker with the values to present to the user.
 (Note: call presentInView:withBlock: or presentInWindowWithBlock: to display the control)
 */
- (id)initWithValues:(NSArray *)values;

/* Presents the control embedded in the provided view.
 Arguments:
   view        - The view that will contain the control.
   callback    - The block that will receive the result of the user action. 
 */
- (void)presentInView:(UIView *)view withBlock:(BSModalPickerViewCallback)callback;

/* Presents the control embedded in the window.
 Arguments:
   callback    - The block that will receive the result of the user action. 
 */
- (void)presentInWindowWithBlock:(BSModalPickerViewCallback)callback;

@end
