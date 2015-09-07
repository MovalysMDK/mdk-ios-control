
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

#import "ControlTextFieldRegex.h"

#import "MDKRegexTextFieldStyle.h"
#import "MDKRegexTextFieldStyle+Button.h"
#import "MDKTextFieldStyle+BackgroundView.h"

@implementation MDKRegexTextFieldStyle

-(void)applyStandardStyleOnComponent:(MDKRegexTextField *)component {
    [super applyStandardStyleOnComponent:component];
    if(self.hasAccessoryButton && self.backgroundView) {
        component.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
}

-(NSDictionary *)customizeErrorViewConstraints:(NSDictionary *)errorViewConstraints onComponent:(MDKTextField *)component {
    NSMutableDictionary *constraints = [errorViewConstraints mutableCopy];
    if(self.hasAccessoryButton) {
        NSLayoutConstraint *right = errorViewConstraints[ERROR_VIEW_RIGHT_CONSTRAINT];
        right.constant -= (REGEX_BUTTON_SQUARE_SIZE + 2*DEFAULT_ACCESSORIES_MARGIN);
        constraints[ERROR_VIEW_RIGHT_CONSTRAINT] = right;
    }
    return constraints;
}

-(CGRect)textRectForBounds:(CGRect)bounds onComponent:(MDKRegexTextField *)component {
    CGRect rect = [super textRectForBounds:bounds onComponent:component];
    if(self.hasAccessoryButton) {
        rect.size.width -= (REGEX_BUTTON_SQUARE_SIZE + 2*DEFAULT_ACCESSORIES_MARGIN);
    }
    return rect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds onComponent:(MDKTextField *)component {
    CGRect rect = [super editingRectForBounds:bounds onComponent:component];
    if(self.hasAccessoryButton) {
        rect.size.width -= (REGEX_BUTTON_SQUARE_SIZE + DEFAULT_ACCESSORIES_MARGIN);
    }
    return rect;}

-(CGRect)placeholderRectForBounds:(CGRect)bounds onComponent:(MDKTextField *)component {
    CGRect rect = [super placeholderRectForBounds:bounds onComponent:component];
    if(self.hasAccessoryButton) {
        rect.size.width -= (REGEX_BUTTON_SQUARE_SIZE + DEFAULT_ACCESSORIES_MARGIN);
    }
    return rect;
}

-(CGRect)clearButtonRectForBounds:(CGRect)bounds onComponent:(MDKTextField *)component {
    CGRect rect = [super clearButtonRectForBounds:bounds onComponent:component];
    if(self.hasAccessoryButton) {
        rect.origin.x -= (REGEX_BUTTON_SQUARE_SIZE + DEFAULT_ACCESSORIES_MARGIN);
    }
    return rect;
}

-(NSDictionary *)customizeBackgroundViewConstraints:(NSDictionary *)backgroundViewConstraints onComponent:(MDKTextField *)component {
    NSMutableDictionary *dictionary = [backgroundViewConstraints mutableCopy];
    if(self.hasAccessoryButton) {
        NSLayoutConstraint *width = backgroundViewConstraints[BACKGROUND_VIEW_WIDTH_CONSTRAINT];
        width.constant -= (REGEX_BUTTON_SQUARE_SIZE + 2*DEFAULT_ACCESSORIES_MARGIN);
        dictionary[BACKGROUND_VIEW_WIDTH_CONSTRAINT] = width;
        [self.backgroundView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    }
    return dictionary;
}

-(BOOL)hasAccessoryButton {
    return YES;
}


@end
