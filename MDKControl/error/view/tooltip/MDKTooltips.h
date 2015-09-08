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
#ifndef JoeTooltips_MDKTooltips_h
#define JoeTooltips_MDKTooltips_h


#endif

#import "MDKTooltipView.h"
#import "MDKSequentialTooltipManager.h"
#import "MDKTooltipManager.h"


/*!
 Todo (high priority):
 - Empty. Woo!
 */

/*!
 Todo (low priority):
 - Check the managers - will the view that is initially supplied as the hostView for a tooltip be superceded by the hostView on the manager? Is this correct?
 - If, for example, being shown from a non-full-screen modal on iPad, make sure it can overflow outside of the modal itself.
 - Maybe revisit the logic for positioning the tooltips (better centring etc)
 - In some cases (different positions), the tooltips 'move' if they are shown repeatedly.
 - Allow showing without an arrow
 - Allow showing an image/icon instead/as well?
 - Auto-dismiss option after specified time.
 - Managers - change the convenience methods to affect tooltips that are added later
 - Add the backdrop to the host instead of the host's window? Or the keyWindow?
 - Add completion blocks to the managers.
 - Documentation - mention that all tooltips in a single manager need to have the same hostView for orientation to work. (They do, don't they?).
 - Allow using tabBarItems as targets?
 - Add some kind of layout block, so that you can supply your own code for laying out the tooltip (useful for allowing you to use targetPoint and still suporting rotation).
 - More shadow customisation options?
 - setTooltipNeedsLayoutWithHostViewSize: - do we need to supply the size here?
 - Add the ability to adjust the positioning relative to a view (move further up by x etc)
 - MDKTooltipSequentialManager (sequentially show all in one go, with kind of quick bubbling effect as well?)
 - Managers - Completion blocks (on hide etc.)

 */

