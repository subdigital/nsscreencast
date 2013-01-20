//
//  NVSlideMenuViewController.m
//  NVSlideMenuViewControllerDemo
//
//  Created by Nicolas Verinaud on 31/12/12.
//  Copyright (c) 2012 Nicolas Verinaud. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NVSlideMenuController.h"

#define WIDTH_OF_CONTENT_VIEW_VISIBLE	44.f
#define ANIMATION_DURATION				0.3f

@interface NVSlideMenuController ()

@property (nonatomic, readwrite, strong) UIViewController *menuViewController;
@property (nonatomic, readwrite, strong) UIViewController *contentViewController;

- (void)setShadowOnContentViewControllerView;

/**
 Load the menu view controller view and add its view as a subview
 to self.view with correct frame.
 */
- (void)loadMenuViewControllerViewIfNeeded;

/** Gesture recognizers */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
- (void)tapGestureTriggered:(UITapGestureRecognizer *)tapGesture;

@property (nonatomic, assign) CGRect contentViewControllerFrame;
@property (nonatomic, assign) BOOL menuWasOpenAtPanBegin;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
- (void)panGestureTriggered:(UIPanGestureRecognizer *)panGesture;

/** Offset X when the menu is open */
- (CGFloat)offsetXWhenMenuIsOpen;

@end


@implementation NVSlideMenuController

#pragma mark - Memory Management

- (void)dealloc
{
	[_menuViewController release];
	[_contentViewController release];
	
	[_tapGesture release];
	[_panGesture release];
	
	[super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Creation
#pragma mark Designated Initializer

- (id)initWithMenuViewController:(UIViewController *)menuViewController andContentViewController:(UIViewController *)contentViewController
{
	self = [super initWithNibName:nil bundle:nil];
	if (self)
	{
		self.menuViewController = menuViewController;
		self.contentViewController = contentViewController;
		self.panEnabledWhenSlideMenuIsHidden = YES;
	}
	
	return self;
}

#pragma mark Overriden Initializers

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		self.menuViewController = nil;
		self.contentViewController = nil;
		self.panEnabledWhenSlideMenuIsHidden = YES;
	}
	
	return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithMenuViewController:nil andContentViewController:nil];
}


#pragma mark - Children View Controllers

- (void)setMenuViewController:(UIViewController *)menuViewController
{
	if (menuViewController != _menuViewController)
	{
		[_menuViewController willMoveToParentViewController:nil];
		[_menuViewController removeFromParentViewController];
		[_menuViewController release];
		
		_menuViewController = [menuViewController retain];
		[self addChildViewController:_menuViewController];
		[_menuViewController didMoveToParentViewController:self];
	}
}


- (void)setContentViewController:(UIViewController *)contentViewController
{
	if (contentViewController != _contentViewController)
	{
		[_contentViewController willMoveToParentViewController:nil];
		[_contentViewController removeFromParentViewController];
		[_contentViewController release];
		
		_contentViewController = [contentViewController retain];
		[self addChildViewController:_contentViewController];
		[_contentViewController didMoveToParentViewController:self];
	}
}


- (void)setShadowOnContentViewControllerView
{
	UIView *contentView = self.contentViewController.view;
	CALayer *layer = contentView.layer;
	layer.masksToBounds = NO;
	layer.shadowColor = [[UIColor blackColor] CGColor];
	layer.shadowOpacity = 1.f;
	layer.shadowOffset = CGSizeMake(-2.5f, 0.f);
	layer.shadowRadius = 5.f;
	layer.shadowPath = [[UIBezierPath bezierPathWithRect:contentView.bounds] CGPath];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.view addSubview:self.contentViewController.view];
	[self setShadowOnContentViewControllerView];
	
	[self.contentViewController.view addGestureRecognizer:self.tapGesture];
	self.tapGesture.enabled = NO;
	[self.contentViewController.view addGestureRecognizer:self.panGesture];
	self.panGesture.enabled = self.panEnabledWhenSlideMenuIsHidden;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (![self isMenuOpen])
		self.contentViewController.view.frame = self.view.bounds;
	
	[self.contentViewController beginAppearanceTransition:YES animated:animated];
	if ([self.menuViewController isViewLoaded] && self.menuViewController.view.superview)
		[self.menuViewController beginAppearanceTransition:YES animated:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.contentViewController endAppearanceTransition];
	if ([self.menuViewController isViewLoaded] && self.menuViewController.view.superview)
		[self.menuViewController endAppearanceTransition];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self.contentViewController beginAppearanceTransition:NO animated:animated];
	if ([self.menuViewController isViewLoaded])
		[self.menuViewController beginAppearanceTransition:NO animated:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[self.contentViewController endAppearanceTransition];
	if ([self.menuViewController isViewLoaded])
		[self.menuViewController endAppearanceTransition];
}


#pragma mark - Appearance & rotation callbacks

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
	return NO;
}


- (BOOL)shouldAutomaticallyForwardRotationMethods
{
	return YES;
}


- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
	return NO;
}


#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
	return [self.menuViewController shouldAutorotate] && [self.contentViewController shouldAutorotate];
}


- (NSUInteger)supportedInterfaceOrientations
{
	return [self.menuViewController supportedInterfaceOrientations] & [self.contentViewController supportedInterfaceOrientations];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return [self.menuViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation] && [self.contentViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if ([self isMenuOpen])
	{
		CGRect frame = self.contentViewController.view.frame;
		frame.origin.x = [self offsetXWhenMenuIsOpen];
		[UIView animateWithDuration:duration animations:^{
			self.contentViewController.view.frame = frame;
		}];
	}
}


#pragma mark - Menu view lazy load

- (void)loadMenuViewControllerViewIfNeeded
{
	if (!self.menuViewController.view.superview)
	{
		CGRect menuFrame = self.view.bounds;
		menuFrame.size.width -= WIDTH_OF_CONTENT_VIEW_VISIBLE;
		self.menuViewController.view.frame = menuFrame;
		[self.view insertSubview:self.menuViewController.view atIndex:0];
	}
}


#pragma mark - Navigation

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
	NSAssert(contentViewController != nil, @"Can't show a nil content view controller.");
	
	if (contentViewController != self.contentViewController)
	{
		// Preserve the frame
		CGRect frame = self.contentViewController.view.frame;
		
		// Remove old content view
		[self.contentViewController.view removeGestureRecognizer:self.tapGesture];
		[self.contentViewController.view removeGestureRecognizer:self.panGesture];
		[self.contentViewController beginAppearanceTransition:NO animated:NO];
		[self.contentViewController.view removeFromSuperview];
		[self.contentViewController endAppearanceTransition];
		
		// Add the new content view
		self.contentViewController = contentViewController;
		self.contentViewController.view.frame = frame;
		[self.contentViewController.view addGestureRecognizer:self.tapGesture];
		[self.contentViewController.view addGestureRecognizer:self.panGesture];
		[self setShadowOnContentViewControllerView];
		[self.contentViewController beginAppearanceTransition:YES animated:NO];
		[self.view addSubview:self.contentViewController.view];
		[self.contentViewController endAppearanceTransition];
	}
	
	// Perform the show animation
	[self showContentViewControllerAnimated:animated completion:completion];
}


- (void)showContentViewControllerAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
	// Remove gestures
	self.tapGesture.enabled = NO;
	self.panGesture.enabled = self.panEnabledWhenSlideMenuIsHidden;
	
	self.menuViewController.view.userInteractionEnabled = NO;
	
	NSTimeInterval duration = animated ? ANIMATION_DURATION : 0;
	
	UIView *contentView = self.contentViewController.view;
	CGRect contentViewFrame = contentView.frame;
	contentViewFrame.origin.x = 0;
	
	[self.menuViewController beginAppearanceTransition:NO animated:animated];
	
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		contentView.frame = contentViewFrame;
	} completion:^(BOOL finished) {
		[self.menuViewController endAppearanceTransition];
		self.menuViewController.view.userInteractionEnabled = YES;
	
		if (completion)
			completion(finished);
	}];
}


- (IBAction)toggleMenuAnimated:(id)sender
{
	if ([self isMenuOpen])
		[self showContentViewControllerAnimated:YES completion:nil];
	else
		[self showMenuAnimated:YES completion:nil];
}


- (void)showMenuAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{	
	NSTimeInterval duration = animated ? ANIMATION_DURATION : 0;
	
	UIView *contentView = self.contentViewController.view;
	CGRect contentViewFrame = contentView.frame;
	contentViewFrame.origin.x = [self offsetXWhenMenuIsOpen];
	
	[self loadMenuViewControllerViewIfNeeded];
	[self.menuViewController beginAppearanceTransition:YES animated:animated];
	
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		contentView.frame = contentViewFrame;
	} completion:^(BOOL finished) {
		[self.menuViewController endAppearanceTransition];
		
		self.tapGesture.enabled = YES;
		self.panGesture.enabled = YES;
		
		if (completion)
			completion(finished);
	}];
}


#pragma mark - Gestures

- (UITapGestureRecognizer *)tapGesture
{
	if (!_tapGesture)
		_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTriggered:)];
	
	return _tapGesture;
}


- (void)tapGestureTriggered:(UITapGestureRecognizer *)tapGesture
{
	if (tapGesture.state == UIGestureRecognizerStateEnded)
		[self showContentViewControllerAnimated:YES completion:nil];
}


- (UIPanGestureRecognizer *)panGesture
{
	if (!_panGesture)
	{
		_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureTriggered:)];
		[_panGesture requireGestureRecognizerToFail:self.tapGesture];
	}
	
	return _panGesture;
}


- (void)panGestureTriggered:(UIPanGestureRecognizer *)panGesture
{
	if (panGesture.state == UIGestureRecognizerStateBegan)
	{
		self.contentViewControllerFrame = self.contentViewController.view.frame;
		self.menuWasOpenAtPanBegin = [self isMenuOpen];
		
		if (!self.menuWasOpenAtPanBegin)
		{
			[self loadMenuViewControllerViewIfNeeded]; // Menu is closed, load it if needed
			[self.menuViewController beginAppearanceTransition:YES animated:YES]; // Menu is appearing
		}
	}
	
	CGPoint translation = [panGesture translationInView:panGesture.view];
	
	CGRect frame = self.contentViewControllerFrame;
	frame.origin.x += translation.x;
	
	CGFloat offsetXWhenMenuIsOpen = [self offsetXWhenMenuIsOpen];
	
	if (frame.origin.x < 0)
		frame.origin.x = 0;
	else if (frame.origin.x > offsetXWhenMenuIsOpen)
		frame.origin.x = offsetXWhenMenuIsOpen;
	
	panGesture.view.frame = frame;
	
	if (panGesture.state == UIGestureRecognizerStateEnded)
	{
		CGPoint velocity = [panGesture velocityInView:panGesture.view];
		CGFloat distance = 0;
		NSTimeInterval animationDuration = 0;
				
		if (velocity.x < 0) // Close
		{
			// Compute animation duration
			distance = frame.origin.x;
			animationDuration = fabs(distance / velocity.x);
			if (animationDuration > ANIMATION_DURATION)
				animationDuration = ANIMATION_DURATION;
			
			// Remove gestures
			self.tapGesture.enabled = NO;
			self.panGesture.enabled = self.panEnabledWhenSlideMenuIsHidden;
			
			frame.origin.x = 0;
			
			if (!self.menuWasOpenAtPanBegin)
				[self.menuViewController endAppearanceTransition];
			
			[self.menuViewController beginAppearanceTransition:NO animated:YES];
			
			[UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				self.contentViewController.view.frame = frame;
			} completion:^(BOOL finished) {
				[self.menuViewController endAppearanceTransition];
			}];
		}
		else // Open
		{
			distance = fabsf(offsetXWhenMenuIsOpen - frame.origin.x);
			animationDuration = fabs(distance / velocity.x);
			if (animationDuration > ANIMATION_DURATION)
				animationDuration = ANIMATION_DURATION;
			
			frame.origin.x = offsetXWhenMenuIsOpen;
			
			[UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				self.contentViewController.view.frame = frame;
			} completion:^(BOOL finished) {
				self.tapGesture.enabled = YES;
				
				if (!self.menuWasOpenAtPanBegin)
					[self.menuViewController endAppearanceTransition];
			}];
		}
		
		self.contentViewControllerFrame = frame;
	}
}


#pragma mark - Utils

- (BOOL)isMenuOpen
{
	return self.contentViewController.view.frame.origin.x > 0;
}


- (CGFloat)offsetXWhenMenuIsOpen
{
	return CGRectGetWidth(self.view.bounds) - WIDTH_OF_CONTENT_VIEW_VISIBLE;
}

@end


#pragma mark -
#pragma mark - UIViewController (NVSlideMenuController)

@implementation UIViewController (NVSlideMenuController)

- (NVSlideMenuController *)slideMenuController
{
	NVSlideMenuController *slideMenuController = nil;
	UIViewController *parentViewController = self.parentViewController;
	
	while (!slideMenuController && parentViewController)
	{
		if ([parentViewController isKindOfClass:NVSlideMenuController.class])
			slideMenuController = (NVSlideMenuController *) parentViewController;
		else
			parentViewController = parentViewController.parentViewController;
	}
	
	return slideMenuController;
}

@end
