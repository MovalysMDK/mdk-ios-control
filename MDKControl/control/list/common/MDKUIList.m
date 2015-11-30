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

#import "MDKUIList.h"
#import "Helper.h"


#pragma mark - MDKUIList - Keys

/*!
 * @brief The key for MDKUIListIdentifier allowing to name component identifier
 */
NSString *const MDKUIListIdentifier = @"MDK_MDKUIList";


#pragma mark - MDKUIList - Implementation

@implementation MDKUIList


#pragma mark Handle user event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}


#pragma mark Public API

- (void) dismiss {
    // Perform animation
    CGRect startFrame = self.tableView.frame;
    CGRect finalFrame = CGRectMake(startFrame.origin.x, self.frame.size.height, startFrame.size.width, startFrame.size.height);
    self.tableView.frame = startFrame;
    
    // Animation
    [UIView animateWithDuration:0.2f delay:0.0f usingSpringWithDamping:10.0f initialSpringVelocity:18.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.frame = finalFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
