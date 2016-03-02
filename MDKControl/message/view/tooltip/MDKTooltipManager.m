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

#import "MDKTooltipManager.h"


@interface MDKTooltipManager ()

@property (nonatomic, strong) NSArray *tooltips;

@end


@implementation MDKTooltipManager

#pragma mark - Getters

- (NSArray *)tooltips
{
    if (!_tooltips) {
        _tooltips = @[];
    }
    return _tooltips;
}

- (UIColor *)backdropColour
{
    if (!_backdropColour) {
        _backdropColour = [UIColor lightGrayColor];
    }
    return _backdropColour;
}


#pragma mark - Init

- (instancetype)initWithHostView:(UIView *)view tooltips:(NSArray *)tooltips;
{
    self = [super init];
    if (self) {
        [self commonInit];
        self.tooltips = tooltips;
        self.hostView = view;
    }
    return self;
}

- (instancetype)initWithHostView:(UIView *)view
{
    self = [self initWithHostView:view tooltips:nil];
    return self;
}

- (void)commonInit
{
    self.showsBackdropView = NO;
    self.backdropAlpha = 0.2f;
    self.backdropTapActionEnabled = YES;
}


#pragma mark - Adding Tooltips (Public)

- (void)addTooltips:(NSArray *)tooltips
{
    NSMutableArray *allTooltips = [self.tooltips mutableCopy];
    for (MDKTooltipView *tooltip in tooltips) {
        if ([tooltip isKindOfClass:[MDKTooltipView class]]) {
            [allTooltips addObject:tooltip];
        }
    }
    self.tooltips = [NSArray arrayWithArray:allTooltips];
}

- (void)addTooltip:(MDKTooltipView *)tooltip
{
    if (![tooltip isKindOfClass:[MDKTooltipView class]]) {
        return;
    }
    
    self.tooltips = [self.tooltips arrayByAddingObject:tooltip];
}

- (void)addTooltipWithTargetPoint:(CGPoint)targetPoint tooltipText:(NSString *)tooltipText
                   arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection hostView:(UIView *)hostView width:(CGFloat)width
{
    MDKTooltipView *tooltip = [[MDKTooltipView alloc]
                               initWithTargetPoint:targetPoint
                               hostView:hostView
                               tooltipText:tooltipText
                               arrowDirection:arrowDirection
                               width:width];
    [self addTooltip:tooltip];
}

- (void)addTooltipWithTargetPoint:(CGPoint)targetPoint tooltipText:(NSString *)tooltipText
                   arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection hostView:(UIView *)hostView
                            width:(CGFloat)width showCompletionBlock:(MDKTooltipViewCompletionBlock)showCompletionBlock
              hideCompletionBlock:(MDKTooltipViewCompletionBlock)hideCompletionBlock
{
    MDKTooltipView *tooltip = [[MDKTooltipView alloc]
                               initWithTargetPoint:targetPoint
                               hostView:hostView
                               tooltipText:tooltipText
                               arrowDirection:arrowDirection
                               width:width
                               showCompletionBlock:showCompletionBlock
                               hideCompletionBlock:hideCompletionBlock];
    [self addTooltip:tooltip];
}

- (void)addTooltipWithTargetView:(UIView *)targetView hostView:(UIView *)hostView tooltipText:(NSString *)tooltipText
                  arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection width:(CGFloat)width
{
    MDKTooltipView *tooltip = [[MDKTooltipView alloc]
                               initWithTargetView:targetView
                               hostView:hostView
                               tooltipText:tooltipText
                               arrowDirection:arrowDirection
                               width:width];
    [self addTooltip:tooltip];
}

- (void)addTooltipWithTargetView:(UIView *)targetView hostView:(UIView *)hostView tooltipText:(NSString *)tooltipText
                  arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection width:(CGFloat)width
             showCompletionBlock:(MDKTooltipViewCompletionBlock)showCompletionBlock
             hideCompletionBlock:(MDKTooltipViewCompletionBlock)hideCompletionBlock
{
    MDKTooltipView *tooltip = [[MDKTooltipView alloc]
                               initWithTargetView:targetView
                               hostView:hostView tooltipText:tooltipText
                               arrowDirection:arrowDirection
                               width:width
                               showCompletionBlock:showCompletionBlock
                               hideCompletionBlock:hideCompletionBlock];
    [self addTooltip:tooltip];
}

- (void)addTooltipWithTargetBarButtonItem:(UIBarButtonItem *)barButtonItem hostView:(UIView *)hostView
                              tooltipText:(NSString *)tooltipText arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection
                                    width:(CGFloat)width
{
    MDKTooltipView *tooltip = [[MDKTooltipView alloc]
                               initWithTargetBarButtonItem:barButtonItem
                               hostView:hostView tooltipText:tooltipText
                               arrowDirection:arrowDirection
                               width:width];
    [self addTooltip:tooltip];
}

- (void)addTooltipWithTargetBarButtonItem:(UIBarButtonItem *)barButtonItem hostView:(UIView *)hostView
                              tooltipText:(NSString *)tooltipText arrowDirection:(MDKTooltipViewArrowDirection)arrowDirection
                                    width:(CGFloat)width showCompletionBlock:(MDKTooltipViewCompletionBlock)showCompletionBlock
                      hideCompletionBlock:(MDKTooltipViewCompletionBlock)hideCompletionBlock
{
    MDKTooltipView *tooltip = [[MDKTooltipView alloc]
                               initWithTargetBarButtonItem:barButtonItem
                               hostView:hostView tooltipText:tooltipText
                               arrowDirection:arrowDirection
                               width:width
                               showCompletionBlock:showCompletionBlock
                               hideCompletionBlock:hideCompletionBlock];
    [self addTooltip:tooltip];
}


#pragma mark - Showing Tooltips (Public)

- (void)showAllTooltips
{
    if (self.tooltips.count < 1) {
        return;
    }
    
    if (self.showsBackdropView) {
        [self showBackdropView];
    } else {
        [self.backdropView removeFromSuperview];
        self.backdropView = nil;
    }
    for (MDKTooltipView *tooltip in self.tooltips) {
        if (![tooltip isKindOfClass:[MDKTooltipView class]]) {
            continue;
        }
        if (self.showsBackdropView) {
            [tooltip showInView:self.backdropView];
        } else {
            [tooltip show];
        }
    }
}


#pragma mark - Hiding Tooltips (Public)

- (void)hideAllTooltipsAnimated:(BOOL)animated
{
    for (MDKTooltipView *tooltip in self.tooltips) {
        if (![tooltip isKindOfClass:[MDKTooltipView class]]) {
            continue;
        }
        [tooltip hideAnimated:animated];
    }
    [self hideBackdropView];
}


#pragma mark - Public

- (void)setTooltipsNeedLayoutWithHostViewSize:(CGSize)hostViewSize
{
    self.backdropView.frame = self.hostView.window.bounds;
    for (MDKTooltipView *tooltip in self.tooltips) {
        [tooltip setTooltipNeedsLayoutWithHostViewSize:hostViewSize];
    }
}

- (void)setBackgroundColourForAllTooltips:(UIColor *)colour
{
    for (MDKTooltipView *tooltip in self.tooltips) {
        tooltip.tooltipBackgroundColor = colour;
    }
}

- (void)setTextColourForAllTooltips:(UIColor *)colour
{
    for (MDKTooltipView *tooltip in self.tooltips) {
        tooltip.textColour = colour;
    }
}

- (void)setFontForAllTooltips:(UIFont *)font
{
    for (MDKTooltipView *tooltip in self.tooltips) {
        tooltip.font = font;
    }
}

- (void)setShadowEnabledForAllTooltips:(BOOL)shadowEnabled
{
    for (MDKTooltipView *tooltip in self.tooltips) {
        tooltip.shadowEnabled = shadowEnabled;
    }
}

- (void)setShadowColourForAllTooltips:(UIColor *)shadowColour
{
    for (MDKTooltipView *tooltip in self.tooltips) {
        tooltip.shadowColour = shadowColour;
    }
}

- (void)setDismissOnTouchForAllTooltips:(BOOL)dismissOnTouch
{
    for (MDKTooltipView *tooltip in self.tooltips) {
        tooltip.dismissOnTouch = dismissOnTouch;
    }
}


#pragma mark - Backdrop View

- (void)showBackdropViewIfEnabled
{
    if (self.showsBackdropView) {
        [self showBackdropView];
    }
}

- (void)showBackdropView
{
    UIWindow *window = self.hostView.window;
    self.backdropView = [[UIView alloc] initWithFrame:window.bounds];
    UITapGestureRecognizer *tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackdropTap:)];
    [self.backdropView addGestureRecognizer:tapRecogniser];
    self.backdropView.backgroundColor = [self.backdropColour colorWithAlphaComponent:0.0f];
    [window addSubview:self.backdropView];
    [UIView animateWithDuration:0.2 animations:^{
        self.backdropView.backgroundColor = [self.backdropColour colorWithAlphaComponent:self.backdropAlpha];
    }];
}

- (void)hideBackdropView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.backdropView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.backdropView removeFromSuperview];
    }];
}


#pragma mark - Gesture recognisers

- (void)handleBackdropTap:(UIGestureRecognizer *)gestureRecogniser
{
    if (self.backdropTapActionEnabled) {
        [self hideAllTooltipsAnimated:YES];
    }
}

@end
