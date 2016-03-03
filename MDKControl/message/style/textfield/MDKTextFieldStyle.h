
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

#import <Foundation/Foundation.h>
#import "Protocol.h"

#import "MDKControlProtocol.h"
#import "MDKDefaultStyle.h"

@class MDKTextField;

FOUNDATION_EXPORT NSInteger DEFAULT_ACCESSORIES_MARGIN;

/*!
 * @class MDKTextFieldStyle
 * @brief This class manages the syle of a MDKTextFieldStyle control
 */
@interface MDKTextFieldStyle : MDKDefaultStyle <MDKMessageViewProtocol, MDKBackgroundViewProtocol>

#pragma mark - Methods

/*!
 * @brief This methods allows to define constraints that will be applied on 
 * custom accessory view added to the control.
 * @param accessoryView The Accessory View added to the control on that the 
 * constraints will be applied
 * @param identifier A NSString object that identify the accessoryView.
 * @param control The control that will add the defined constraints
 * @return A NSArray object that contains the constraints that will define a position
 * for the given accessoryView in the control.
 * @discussion This method is called for each accessoryView that has been defined 
 * for this control. Be careful when defining constraints : use identifier parameter
 * to identify the accessoryView you want to define the position in the control.
 */
-(NSArray *)defineConstraintsForAccessoryView:(UIView *)accessoryView withIdentifier:(NSString *)identifier onControl:(MDKTextField *)control;

@end
