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
#import <MDKControl/MDKControl.h>

#import "MDKRenderableControl.h"

/******************************************************/
/* MAIN CONTROL                                       */
/******************************************************/

IB_DESIGNABLE
/*!
 * @class MDKUISwitch
 * @brief The Switch Framework Component.
 * @discussion This components allows to choose betweend an checked or an unchecked state.
 * It allows to display a message following th check state of the control.
 * By default, the selected value is displayed on the component.
 */
@interface MDKUINumberPicker : MDKRenderableControl <MDKControlChangesProtocol>

#pragma mark - Properties

/*!
 * @brief The UISwitch control
 */
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

/*!
 * @brief An associated label that tells more about the switch state
 */
@property (weak, nonatomic) IBOutlet UILabel *label;

@end


/******************************************************/
/* INTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIInternalNumberPicker : MDKUINumberPicker <MDKInternalComponent>

@end


/******************************************************/
/* EXTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIExternalNumberPicker : MDKUINumberPicker <MDKExternalComponent>

/*!
 * @brief custom XIB name
 */
@property (nonatomic, strong) IBInspectable NSString *customXIBName;

/*!
 * @brief custom Error XIB Name
 */
@property (nonatomic, strong) IBInspectable NSString *customMessageXIBName;

@end
