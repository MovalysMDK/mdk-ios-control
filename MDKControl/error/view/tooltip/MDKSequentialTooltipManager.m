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

#import "MDKSequentialTooltipManager.h"


@interface MDKSequentialTooltipManager ()

@property (nonatomic, strong) MDKTooltipView *currentlyShowingTooltip;

@end


@implementation MDKSequentialTooltipManager

#pragma mark - Showing Tooltips

- (void)showNextTooltip
{
    if (self.tooltips.count < 1) {
        return;
    }
    
    if (!self.currentlyShowingTooltip) {
        [self showBackdropViewIfEnabled];
        self.currentlyShowingTooltip = [self.tooltips firstObject];
        [self.currentlyShowingTooltip addTapTarget:self action:@selector(handleTooltipTap:)];
        [self showTooltip:self.currentlyShowingTooltip];
    } else {
        [self.currentlyShowingTooltip hideAnimated:YES];
        
        NSUInteger i = [self.tooltips indexOfObject:self.currentlyShowingTooltip] + 1;
        if (i < self.tooltips.count) {
            self.currentlyShowingTooltip = self.tooltips[i];
            [self.currentlyShowingTooltip addTapTarget:self action:@selector(handleTooltipTap:)];
            [self showTooltip:self.currentlyShowingTooltip];
        } else {
            [self hideBackdropView];
        }
    }
}

- (void)showTooltip:(MDKTooltipView *)tooltip
{
    if (self.showsBackdropView) {
        [tooltip showInView:self.backdropView];
    } else {
        [tooltip show];
    }
}

- (void)showAllTooltips
{
    [self showNextTooltip];
}


#pragma mark - Gesture Recognisers

- (void)handleBackdropTap:(UIGestureRecognizer *)gestureRecogniser
{
    if (self.backdropTapActionEnabled) {
        [self showNextTooltip];
    }
}

- (void)handleTooltipTap:(UIGestureRecognizer *)gestureRecogniser
{
    [self showNextTooltip];
}

@end
