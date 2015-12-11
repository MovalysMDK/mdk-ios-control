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


/*!
 *  MDKSequentialTooltipManager is a subclass of MDKTooltipManager that allows you to show tooltips sequentially instead of all at-once.
 
 *  By default, tapping a tooltip or the backdrop triggers @c showNextTooltip (showing the next tooltip, or finishing the sequence and hiding everything).
 */
@interface MDKSequentialTooltipManager : MDKTooltipManager

#pragma mark - Options

/*!
 *  Indicates whether a tap on the backdropView triggers an action. For MDKSequentialTooltipManager, this action is showNextTooltip. Default is YES.
 */
@property (nonatomic) BOOL backdropTapActionEnabled;


#pragma mark - Showing Tooltips
/*!
 *  Hides the manager's current tooltip (if there is a tooltip currently showing) and shows the next one.
 
 *  Tooltips are shown in the order they are added.
 
 *  If there an no more tooltips to be shown, the last tooltip and the backdrop are hidden.
 */
- (void)showNextTooltip;

@end
