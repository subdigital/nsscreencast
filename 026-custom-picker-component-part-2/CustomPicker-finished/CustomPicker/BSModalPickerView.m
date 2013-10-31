//
//  BSModalPickerView.m
//  CustomPicker
//
//  Created by Ben Scheirman on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define BSMODALPICKER_PANEL_HEIGHT 200
#define BSMODALPICKER_TOOLBAR_HEIGHT 40
#define BSMODALPICKER_BACKDROP_OPACITY 0.8

#import "BSModalPickerView.h"

@interface BSModalPickerView () {
    UIPickerView *_picker;
    UIToolbar *_toolbar;
    UIView *_panel;
    UIView *_backdropView;
}

@property (nonatomic, strong) BSModalPickerViewCallback callbackBlock;

@end

@implementation BSModalPickerView

@synthesize selectedIndex = _selectedIndex;
@synthesize values = _values;
@synthesize callbackBlock = _callbackBlock;

- (id)initWithValues:(NSArray *)values {
    self = [super init];
    if (self) {
        self.values = values;
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)setValues:(NSArray *)values {
    _values = values;
    
    if (values) {
        if (_picker) {
            [_picker reloadAllComponents];
        }
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (_picker) {
        [_picker selectRow:selectedIndex inComponent:0 animated:YES];
    }
}

- (void)setSelectedValue:(NSString *)selectedValue {
    NSInteger index = [self.values indexOfObject:selectedValue];
    [self setSelectedIndex:index];
}

- (NSString *)selectedValue {
    return [self.values objectAtIndex:self.selectedIndex];
}

- (void)onCancel:(id)sender {
    self.callbackBlock(NO);
    [self dismissPicker];
}

- (void)onDone:(id)sender {
    self.callbackBlock(YES);
    [self dismissPicker];
}

- (void)onBackdropTap:(id)sender {
    [self onCancel:sender];
}

- (void)dismissPicker {
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect newFrame = _panel.frame;
                         newFrame.origin.y += _panel.frame.size.height;
                         _panel.frame = newFrame;
                         _backdropView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_panel removeFromSuperview];
                         _panel = nil;
                         
                         [_backdropView removeFromSuperview];
                         _backdropView = nil;
                         
                         [self removeFromSuperview];
                     }];
}

- (UIPickerView *)picker {
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, BSMODALPICKER_TOOLBAR_HEIGHT, self.bounds.size.width, BSMODALPICKER_PANEL_HEIGHT - BSMODALPICKER_TOOLBAR_HEIGHT)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow:self.selectedIndex inComponent:0 animated:NO];
    
    return picker;
}


- (UIToolbar *)toolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, BSMODALPICKER_TOOLBAR_HEIGHT)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    toolbar.items = [NSArray arrayWithObjects:
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                   target:self 
                                                                   action:@selector(onCancel:)],
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                   target:nil 
                                                                   action:nil],
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                   target:self 
                                                                   action:@selector(onDone:)],
                     nil];
    
    return toolbar;
}

- (UIView *)backdropView {
    UIView *backdropView = [[UIView alloc] initWithFrame:self.bounds];
    backdropView.backgroundColor = [UIColor colorWithWhite:0 alpha:BSMODALPICKER_BACKDROP_OPACITY];
    backdropView.alpha = 0;
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackdropTap:)];
    [backdropView addGestureRecognizer:tapRecognizer];
    return backdropView;
}

- (void)presentInView:(UIView *)view withBlock:(BSModalPickerViewCallback)callback {
    self.frame = view.bounds;
    self.callbackBlock = callback;
    
    [_panel removeFromSuperview];
    [_backdropView removeFromSuperview];
    
    _panel = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - BSMODALPICKER_PANEL_HEIGHT, self.bounds.size.width, BSMODALPICKER_PANEL_HEIGHT)];
    _picker = [self picker];
    _toolbar = [self toolbar];
    
    _backdropView = [self backdropView];
    [self addSubview:_backdropView];

    [_panel addSubview:_picker];
    [_panel addSubview:_toolbar];
    
    [self addSubview:_panel];
    [view addSubview:self];
    
    CGRect oldFrame = _panel.frame;
    CGRect newFrame = _panel.frame;
    newFrame.origin.y += newFrame.size.height;
    _panel.frame = newFrame;
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _panel.frame = oldFrame;
                         _backdropView.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)presentInWindowWithBlock:(BSModalPickerViewCallback)callback {
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(window)]) {
        UIWindow *window = [appDelegate window];
        [self presentInView:window withBlock:callback];
    } else {
        [NSException exceptionWithName:@"Can't find a window property on App Delegate.  Please use the presentInView:withBlock: method" reason:@"The app delegate does not contain a window method"
                              userInfo:nil];
    }
}

#pragma mark - Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.values.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.values objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
}

@end
