//
//  GPNavigationController.m
//  GitPad
//
//  Created by Robert Widmann on 11/29/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "GPNavigationController.h"
#include <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "GPNavigationBar.h"

static char GP_VIEWCONTROLLER_KEY;

@implementation UIViewController (GPNavigationController)

-(void)setGp_navigationController:(GPNavigationController *)gp_navigationController {
	objc_setAssociatedObject (gp_navigationController, &GP_VIEWCONTROLLER_KEY, self, OBJC_ASSOCIATION_RETAIN);
}

-(GPNavigationController*)gp_navigationController {
	return objc_getAssociatedObject(self, &GP_VIEWCONTROLLER_KEY);
}

@end

@interface GPNavigationController ()

@property (nonatomic) NSMutableArray *stack;

@end

static CGFloat const UINavigationControllerAnimationDuration = 0.25f;

@implementation GPNavigationController

- (id)initWithRootViewController:(UIViewController *)viewController {
	self = [super init];
	if (self) {
		_stack = [@[] mutableCopy];
		[_stack addObject:viewController];
		viewController.gp_navigationController = self;
		self.view.clipsToBounds = YES;
	}
	return self;
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view.backgroundColor = [UIColor clearColor];
	
	UIViewController *visible = [self topViewController];
	
	[visible viewWillAppear:NO];
	
	[self.view addSubview:visible.view];
	visible.view.frame = self.view.bounds;
	visible.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[visible viewDidAppear:YES];
	
}


#pragma mark - Properties

- (NSArray *)viewControllers {
	return [NSArray arrayWithArray:_stack];
}

- (UIViewController *)topViewController {
	return [_stack lastObject];
}

#pragma mark - Methods
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
	[self setViewControllers:viewControllers animated:animated completion:nil];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	CGFloat duration = (animated ? UINavigationControllerAnimationDuration : 0);
	
	UIViewController *viewController = [viewControllers lastObject];
	BOOL containedAlready = ([_stack containsObject:viewController]);
	
	[CATransaction begin];
	//Push if it's not in the stack, pop back if it is
	[self.view addSubview:viewController.view];
	viewController.view.frame = (containedAlready ? UINavigationOffscreenLeftFrame(self.view.bounds) : UINavigationOffscreenRightFrame(self.view.bounds));
	[CATransaction flush];
	[CATransaction commit];
	
	UIViewController *last = [self topViewController];
	
	for (UIViewController *controller in _stack) {
		controller.gp_navigationController = nil;
	}
	[_stack removeAllObjects];
	[_stack addObjectsFromArray:viewControllers];
	for (UIViewController *controller in viewControllers) {
		controller.gp_navigationController = self;
	}
	
	[UIView animateWithDuration:duration animations:^{
		last.view.frame = (containedAlready ? UINavigationOffscreenRightFrame(self.view.bounds) : UINavigationOffscreenLeftFrame(self.view.bounds));
		viewController.view.frame = self.view.bounds;
	} completion:^(BOOL finished) {
		[last.view removeFromSuperview];
		
		[viewController viewDidAppear:animated];
		
		[last viewDidDisappear:animated];
		
		if (completion) {
			completion(finished);
		}
		
	}];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[self pushViewController:viewController animated:animated completion:nil];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	
	UIViewController *last = [self topViewController];
	[_stack addObject:viewController];
	viewController.gp_navigationController = self;
	
	CGFloat duration = (animated ? UINavigationControllerAnimationDuration : 0);
	
	[last viewWillDisappear:animated];
	
	
	[viewController viewWillAppear:animated];
	
	[self.view addSubview:viewController.view];
	
	//Make sure the app draws the frame offscreen instead of just 'popping' it in
	[CATransaction begin];
	viewController.view.frame = UINavigationOffscreenRightFrame(self.view.bounds);
	[CATransaction flush];
	[CATransaction commit];
	
	[UIView animateWithDuration:duration animations:^{
		last.view.frame = UINavigationOffscreenLeftFrame(self.view.bounds);
		viewController.view.frame = self.view.bounds;
	} completion:^(BOOL finished) {
		[last.view removeFromSuperview];
		
		[viewController viewDidAppear:animated];
		
		[last viewDidDisappear:animated];
		
		if (completion) {
			completion(finished);
		}
		
	}];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	return [self popViewControllerAnimated:animated completion:nil];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	if ([_stack count] <= 1) {
		NSLog(@"Not enough view controllers on stack to pop");
		return nil;
	}
	UIViewController *popped = [_stack lastObject];
	[self popToViewController:_stack[([_stack count] - 2)] animated:animated completion:completion];
	return popped;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
	return [self popToRootViewControllerAnimated:animated completion:nil];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	if ([[self topViewController] isEqual:_stack[0]] == YES) {
		return @[];
	}
	return [self popToViewController:_stack[0] animated:animated completion:completion];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
	return [self popToViewController:viewController animated:animated completion:nil];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	if ([_stack containsObject:viewController] == NO) {
		NSLog(@"View controller %@ is not in stack", viewController);
		return @[];
	}
	
	UIViewController *last = [_stack lastObject];
	
	NSMutableArray *popped = [@[] mutableCopy];
	while ([viewController isEqual:[_stack lastObject]] == NO) {
		[popped addObject:[_stack lastObject]];
		[(UIViewController *)[_stack lastObject] setGp_navigationController:nil];
		[_stack removeLastObject];
	}
	
	
	[self.view addSubview:viewController.view];
	viewController.view.frame = UINavigationOffscreenLeftFrame(self.view.bounds);
	
	CGFloat duration = (animated ? UINavigationControllerAnimationDuration : 0);
	
	[last viewWillDisappear:animated];
	
	[viewController viewWillAppear:animated];
	
	[UIView animateWithDuration:duration animations:^{
		last.view.frame = UINavigationOffscreenRightFrame(self.view.bounds);
		viewController.view.frame = self.view.bounds;
	} completion:^(BOOL finished) {
		[last.view removeFromSuperview];
		
		[viewController viewDidAppear:animated];
		
		[last viewDidDisappear:animated];
		
		if (completion) {
			completion(finished);
		}
		
	}];
	
	
	return popped;
}

//Le Sigh... Come on Apple, I want to do these things without your "help"
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark - Private

static inline CGRect UINavigationOffscreenLeftFrame(CGRect bounds) {
	CGRect offscreenLeft = bounds;
	offscreenLeft.origin.x -= bounds.size.width;
	return offscreenLeft;
}

static inline CGRect UINavigationOffscreenRightFrame(CGRect bounds) {
	CGRect offscreenRight = bounds;
	offscreenRight.origin.x += bounds.size.width;
	return offscreenRight;
}

@end