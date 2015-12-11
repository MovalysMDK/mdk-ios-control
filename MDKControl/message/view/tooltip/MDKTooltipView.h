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
 *
 *
 *
 * Copyright (c) 2014 Joe Fryer <joe.d.fryer@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>


#pragma mark - MDKTooltipViewArrowDirection
/*!
 *  Possible directions in which a MDKTooltipView's arrow will point.
 */
typedef NS_ENUM(NSInteger, MDKTooltipViewArrowDirection){
    /*!
     *  The arrow is on top of the tooltip, pointing up.
     */
    MDKTooltipViewArrowDirectionUp,
    /*!
     *  The arrow is on the right of the tooltip, pointing to the right.
     */
    MDKTooltipViewArrowDirectionRight,
    /*!
     *  The arrow is on the bottom of the tooltip, pointing down.
     */
    MDKTooltipViewArrowDirectionDown,
    /*!
     *  The arrow is on the left of the tooltip, pointing to the left.
     */
    MDKTooltipViewArrowDirectionLeft
};


#pragma mark - MDKTooltipViewCompletionBlock
/*!
 *  Completion block for MDKTooltipView animation completions. No paramaters, no return value.
 */
typedef void (^MDKTooltipViewCompletionBlock)();



// *****
// ****************************************************
            #pragma mark - MDKTooltipView
// ****************************************************
// *****
/*!
 *  MDKTooltipView is a UIView subclass that allows you to easily show a 'tooltip' style view to the user. The tooltips look like a small popover containing some text, with an arrow on one of the edges that points to a point of interest (typically another view) to which the text refers.
 */
@interface MDKTooltipView : UIView

#pragma mark Tooltip Text


/*!
 *  The text that is displayed in the tooltip.
 */
@property (nonatomic, copy) NSString *tooltipText;

/*!
 *  The text that is displayed in the tooltip.
 */
@property (nonatomic, copy) NSAttributedString *tooltipAttributedText;

/*!
 *  The colour of the tooltip text. Default is @c white.
 */
@property (nonatomic, strong) UIColor *textColour;

/*!
 *  The font for the text shown in the tooltip.
 */
@property (nonatomic, strong) UIFont *font;


#pragma mark Other Options

/*!
 *  The background colour for the tooltip. Default is @c darkGray.
 */
@property (nonatomic, strong) UIColor *tooltipBackgroundColour;

/*!
 *  The direction that the tooltip's arrow will point
 */
@property (nonatomic) MDKTooltipViewArrowDirection arrowDirection;

/*!
 *  Indicates whether or not the tooltip has a shadow. Default is @c YES.
 */
@property (nonatomic) BOOL shadowEnabled;

/*!
 *  The colour of the shadow. Default is @c gray.
 */
@property (nonatomic, strong) UIColor *shadowColour;

/*!
 *  Indicates whether the tooltip will dismiss itself when it is touched.
 */
@property (nonatomic) BOOL dismissOnTouch;


#pragma mark Initialisation
/*!
 *  Initialises A MDKTooltipView with the arrow at the specified point. If you want to support interface orientation, you will need to do so manually for a tooltip created with this initialiser. If you want rotation to be handled automatically, you should use one of the initWithTargetView: or initWithTargetBarButtonItem: methods instead.
 *
 *  @param targetPoint    The point at which the tooltip's arrow points.
 *  @param hostView       The view in which the tooltip will be displayed.
 *  @param tooltipText    The text displayed in the tooltip.
 *  @param arrowDirection The direction of the tooltip's arrow.
 *  @param width          The width of the tooltip. If the text goes beyond this width, the tooltip will be resized vertically to accomodate it.
 *
 *  @return An initialised MDKTooltipView.
 */
- (instancetype)initWithTargetPoint:(CGPoint)targetPoint hostView:(UIView *)hostView tooltipText:(NSString *)tooltipText arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection width:(CGFloat)width;

/*!
 *  Initialises A MDKTooltipView with the arrow at the specified point. If you want to support interface orientation, you will need to do so manually for a tooltip created with this initialiser. If you want rotation to be handled automatically, you should use one of the initWithTargetView: or initWithTargetBarButtonItem: methods instead.
 *
 *  @param targetPoint         The point at which the tooltip's arrow points.
 *  @param hostView            The view in which the tooltip will be displayed.
 *  @param tooltipText         The text displayed in the tooltip.
 *  @param arrowDirection      The direction of the tooltip's arrow.
 *  @param width               The width of the tooltip. If the text goes beyond this width, the tooltip will be resized vertically to accomodate it.
 *  @param showCompletionBlock A block that gets executed after the tooltip is shown.
 *  @param hideCompletionBlock A block that gets executed after the tooltip has been dismissed.
 *
 *  @return An initialised MDKTooltipView.
 */
- (instancetype)initWithTargetPoint:(CGPoint)targetPoint hostView:(UIView *)hostView tooltipText:(NSString *)tooltipText arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection width:(CGFloat)width showCompletionBlock:(MDKTooltipViewCompletionBlock)showCompletionBlock hideCompletionBlock:(MDKTooltipViewCompletionBlock)hideCompletionBlock;

/*!
 *  Initialises a MDKTooltipView. The tooltip will try to position the arrow pointing towards the targetView, in the specified direction.
 *
 *  @param targetView     The focus of the tooltip. The tooltip will attempt to point the arrow towards the targetView.
 *  @param hostView       The view in which the tooltip will be displayed.
 *  @param tooltipText    The text displayed in the tooltip.
 *  @param arrowDirection The direction of the tooltip's arrow.
 *  @param width          The width of the tooltip. If the text goes beyond this width, the tooltip will be resized vertically to accomodate it.
 *
 *  @return An initialised MDKTooltipView.
 */
- (instancetype)initWithTargetView:(UIView *)targetView hostView:(UIView *)hostView tooltipText:(NSString *)tooltipText arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection width:(CGFloat)width;

/*!
 *  Initialises a MDKTooltipView. The tooltip will try to position the arrow pointing towards the targetView, in the specified direction.
 *
 *  @param targetView     The focus of the tooltip. The tooltip will attempt to point the arrow towards the targetView.
 *  @param hostView       The view in which the tooltip will be displayed.
 *  @param tooltipText    The text displayed in the tooltip.
 *  @param arrowDirection The direction of the tooltip's arrow.
 *  @param width          The width of the tooltip. If the text goes beyond this width, the tooltip will be resized vertically to accomodate it.
 *  @param showCompletionBlock A block that gets executed after the tooltip is shown.
 *  @param hideCompletionBlock A block that gets executed after the tooltip has been dismissed.
 *
 *  @return An initialised MDKTooltipView.
 */
- (instancetype)initWithTargetView:(UIView *)targetView hostView:(UIView *)hostView tooltipText:(NSString *)tooltipText arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection width:(CGFloat)width showCompletionBlock:(MDKTooltipViewCompletionBlock)showCompletionBlock hideCompletionBlock:(MDKTooltipViewCompletionBlock)hideCompletionBlock NS_DESIGNATED_INITIALIZER;

/*!
 *  Initialises a MDKTooltipView. The tooltip will try to position the arrow pointing towards the barButtonItem, in the specified direction.
 *
 *  @param barButtonItem  The focus of the tooltip. The tooltip will attempt to point the arrow towards the targetView.
 *  @param hostView       The view in which the tooltip will be displayed.
 *  @param tooltipText    The text displayed in the tooltip.
 *  @param arrowDirection The direction of the tooltip's arrow.
 *  @param width          The width of the tooltip. If the text goes beyond this width, the tooltip will be resized vertically to accomodate it.
 *
 *  @return An initialised MDKTooltipView.
 */
- (instancetype)initWithTargetBarButtonItem:(UIBarButtonItem *)barButtonItem hostView:(UIView *)hostView tooltipText:(NSString *)tooltipText arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection width:(CGFloat)width;

/*!
 *  Initialises a MDKTooltipView. The tooltip will try to position the arrow pointing towards the barButtonItem, in the specified direction.
 *
 *  @param barButtonItem  The focus of the tooltip. The tooltip will attempt to point the arrow towards the targetView.
 *  @param hostView       The view in which the tooltip will be displayed.
 *  @param tooltipText    The text displayed in the tooltip.
 *  @param arrowDirection The direction of the tooltip's arrow.
 *  @param width          The width of the tooltip. If the text goes beyond this width, the tooltip will be resized vertically to accomodate it.
 *  @param showCompletionBlock A block that gets executed after the tooltip is shown.
 *  @param hideCompletionBlock A block that gets executed after the tooltip has been dismissed.
 *
 *  @return An initialised MDKTooltipView.
 */
- (instancetype)initWithTargetBarButtonItem:(UIBarButtonItem *)barButtonItem hostView:(UIView *)hostView tooltipText:(NSString *)tooltipText arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection width:(CGFloat)width showCompletionBlock:(MDKTooltipViewCompletionBlock)showCompletionBlock hideCompletionBlock:(MDKTooltipViewCompletionBlock)hideCompletionBlock;

#pragma mark Showing/Hiding Tooltips
/*!
 *  Shows the tooltip.
 */
- (void)show;

/*!
 *  Shows the tooltip in the specified view.
 *
 *  @param view The view to show the tooltip in.
 */
- (void)showInView:(UIView *)view;

/*!
 *  Hides the tooltip, optionally animated.
 *
 *  @param animated BOOL determining whether to animate the hide or not.
 */
- (void)hideAnimated:(BOOL)animated;

#pragma mark Gesture Recognising
/*!
 *  Adds a target/action for taps on the tooltip.
 *
 *  @param target The target.
 *  @param action The Selector.
 */
- (void)addTapTarget:(id)target action:(SEL)action;

#pragma mark Layout
/*!
 *  You should call this method when the tooltip needs to lay itself out again e.g. to handle rotation, or if the targetView has moved. This method only has an effect when there is a targetView. If you used one of the withPoint: initialisers, this method will have no effect.
 *
 *  @param hostViewSize The new size of the host view.
 */
- (void)setTooltipNeedsLayoutWithHostViewSize:(CGSize)hostViewSize;

@end
