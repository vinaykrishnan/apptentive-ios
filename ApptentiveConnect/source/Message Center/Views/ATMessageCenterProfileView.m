//
//  ATMessageCenterProfileView.m
//  ApptentiveConnect
//
//  Created by Frank Schmitt on 7/20/15.
//  Copyright (c) 2015 Apptentive, Inc. All rights reserved.
//

#import "ATMessageCenterProfileView.h"

@interface ATMessageCenterProfileView ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameVerticalSpaceToEmail;

@property (strong, nonatomic) NSLayoutConstraint *nameHorizontalSpaceToEmail;

@property (strong, nonatomic) NSArray *portraitFullConstraints;
@property (strong, nonatomic) NSArray *landscapeFullConstraints;

@property (strong, nonatomic) NSArray *portraitCompactConstraints;
@property (strong, nonatomic) NSArray *landscapeCompactConstraints;

@property (strong, nonatomic) NSArray *baseConstraints;

@end

@implementation ATMessageCenterProfileView

- (void)awakeFromNib {
	self.containerView.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
	
	self.containerView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
	
	self.portraitFullConstraints = @[self.nameTrailingConstraint, self.emailLeadingConstraint, self.nameVerticalSpaceToEmail];
	self.portraitCompactConstraints = @[self.nameTrailingConstraint, self.emailLeadingConstraint];
	
	self.nameHorizontalSpaceToEmail = [NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.emailField attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0];
	NSLayoutConstraint *nameEmailTopAlignment = [NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.emailField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
	NSLayoutConstraint *nameEmailBottomAlignment = [NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.emailField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
	
	self.landscapeFullConstraints = @[self.nameHorizontalSpaceToEmail, nameEmailTopAlignment, nameEmailBottomAlignment];
	self.landscapeCompactConstraints = @[self.emailLeadingConstraint, nameEmailTopAlignment, nameEmailBottomAlignment];
	
	// Find constraints common to both modes/orientations
	NSMutableSet *baseConstraintSet = [NSMutableSet setWithArray:self.containerView.constraints];
	[baseConstraintSet	minusSet:[NSSet setWithArray:self.portraitFullConstraints]];
	self.baseConstraints = [baseConstraintSet allObjects];
}

- (BOOL)isSizeLandscape:(CGSize)size {
	return size.width > 2.75 * size.height;
}

- (void)updateConstraints {
	[self.containerView removeConstraints:self.containerView.constraints];
	[self.containerView addConstraints:self.baseConstraints];
	
	if ([self isSizeLandscape:self.bounds.size]) {
		switch (self.mode) {
			case ATMessageCenterProfileModeFull:
				[self.containerView addConstraints:self.landscapeFullConstraints];
				break;
				
			case ATMessageCenterProfileModeCompact:
				[self.containerView addConstraints:self.landscapeCompactConstraints];
				break;
		}
	} else {
		switch (self.mode) {
			case ATMessageCenterProfileModeFull:
				[self.containerView addConstraints:self.portraitFullConstraints];
				break;
				
			case ATMessageCenterProfileModeCompact:
				[self.containerView addConstraints:self.portraitCompactConstraints];
				break;
		}
	}
	
	[super updateConstraints];
}

- (void)setMode:(ATMessageCenterProfileMode)mode {
	if (_mode != mode) {
		_mode = mode;
		
		CGFloat nameFieldAlpha;
		
		if (mode == ATMessageCenterProfileModeCompact) {
			self.requiredLabel.hidden = NO;
			nameFieldAlpha = 0;
		} else {
			self.nameField.hidden = NO;
			nameFieldAlpha = 1;
		}
		
		[self updateConstraints];
		
		[UIView animateWithDuration:0.25 animations:^{
			self.nameField.alpha = nameFieldAlpha;
			self.requiredLabel.alpha = 1.0 - nameFieldAlpha;
			
			[self layoutIfNeeded];
		} completion:^(BOOL finished) {
			if (nameFieldAlpha == 0) {
				self.nameField.hidden = YES;
			} else {
				self.requiredLabel.hidden = YES;
			}
		}];
	}
}

@end
