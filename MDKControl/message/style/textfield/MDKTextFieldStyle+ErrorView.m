
/**
 * Copyright (C) 2010 Sopra (support_movalys@sopra.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
#import "MDKTextFieldStyle+ErrorView.h"
#import "MDKTextField.h"
#import "MDKMessageButton.h"

NSInteger DEFAULT_CLEAR_BUTTON_CONTAINER = 19;
NSInteger DEFAULT_ERROR_VIEW_SQUARE_SIZE = 20;

/**
 * Width constraint : errorView.width = 22;
 */
NSString * ERROR_VIEW_WIDTH_CONSTRAINT = @"ERROR_VIEW_WIDTH_CONSTRAINT";

/**
 * Height constraint : height == 22;
 */
NSString * ERROR_VIEW_HEIGHT_CONSTRAINT = @"ERROR_VIEW_HEIGHT_CONSTRAINT";

/**
 * CenterY constraint : errorView.centerY == component.centerY;
 */
NSString * ERROR_VIEW_CENTER_Y_CONSTRAINT = @"ERROR_VIEW_CENTER_Y_CONSTRAINT";

/**
 * CenterY constraint : errorView.right == component.right - 2;
 */
NSString * ERROR_VIEW_RIGHT_CONSTRAINT = @"ERROR_VIEW_RIGHT_CONSTRAINT";


@implementation MDKTextFieldStyle (ErrorView)

-(void) addErrorViewOnComponent:(MDKTextField *)component {
    if(!self.messageView) {
        MDKMessageButton *errorButton = [MDKMessageButton buttonWithType:UIButtonTypeCustom];
        errorButton.clipsToBounds = YES;
        [errorButton addTarget:component action:@selector(onMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.messageView = errorButton;
        self.messageView.alpha = 0.0;
        self.messageView.tintColor = [UIColor redColor];
        [component addSubview:self.messageView];
        
        NSDictionary *errorViewConstraints = [self defineErrorViewConstraintsOnComponent:component];
        errorViewConstraints = [self customizeErrorViewConstraints:errorViewConstraints onComponent:component];
        [component addConstraints:errorViewConstraints.allValues];
        
    }
    if(self.messageView) {
        [MDKMessageUIManager autoStyleMessageButton:self.messageView forMessages:[component messages]];
    }
    [component layoutIfNeeded];
    
    self.messageView.alpha = 1.0;
    
}

-(void) removeErrorViewOnComponent:(MDKTextField *)component {
    [self.messageView removeFromSuperview];
    self.messageView = nil;
}


-(NSDictionary *)defineErrorViewConstraintsOnComponent:(UIView *)component {
    
    component.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.messageView
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual toItem:component
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1 constant:0];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.messageView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual toItem:component
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1 constant:-DEFAULT_ACCESSORIES_MARGIN];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.messageView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0 constant:DEFAULT_ERROR_VIEW_SQUARE_SIZE];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.messageView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:0 constant:DEFAULT_ERROR_VIEW_SQUARE_SIZE];
    NSDictionary *errorViewConstraints = @{
                             ERROR_VIEW_CENTER_Y_CONSTRAINT:centerY,
                             ERROR_VIEW_HEIGHT_CONSTRAINT:height,
                             ERROR_VIEW_RIGHT_CONSTRAINT:right,
                             ERROR_VIEW_WIDTH_CONSTRAINT:width
                             };
    
    return errorViewConstraints;
    
}


#pragma mark - Public Methods


-(NSDictionary *) customizeErrorViewConstraints:(NSDictionary *)errorViewConstraints onComponent:(MDKTextField *)component{
    return errorViewConstraints;
}




@end
