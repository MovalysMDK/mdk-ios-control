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

#import "MDKRenderableControl.h"



/******************************************************/
/* MAIN CONTROL                                       */
/******************************************************/

/*!
 * @class MDKUIPosition
 * @brief This component allow to handle user position
 */
IB_DESIGNABLE
@interface MDKUIPosition : MDKRenderableControl <MDKControlChangesProtocol>

#pragma mark - Properties

/*!
 * @brief The button allow to display the location in maps
 */
@property (nonatomic, weak) IBOutlet UIButton *buttonMap;

/*!
 * @brief The button allow to navigate between current location and data location
 */
@property (nonatomic, weak) IBOutlet UIButton *buttonNavigation;

/*!
 * @brief The button allow to indicate location founded
 */
@property (nonatomic, weak) IBOutlet UIButton *buttonLocationFounded;

/*!
 * @brief The button allow to indicate location not found
 */
@property (nonatomic, weak) IBOutlet UIButton *buttonLocationNotFound;

/*!
 * @brief The button allow to remove all data
 */
@property (nonatomic, weak) IBOutlet UIButton *buttonCancel;

/*!
 * @brief The text field allow to enter longitude
 */
@property (nonatomic, weak) IBOutlet UITextField *textFieldLongitude;

/*!
 * @brief The text field allow to enter latitude
 */
@property (nonatomic, weak) IBOutlet UITextField *textFieldLatitude;
 
@end


/******************************************************/
/* INTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIInternalPosition : MDKUIPosition <MDKInternalComponent>

@end


/******************************************************/
/* EXTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIExternalPosition : MDKUIPosition <MDKExternalComponent>

/*!
 * @brief custom XIB name
 */
@property (nonatomic, strong) IBInspectable NSString *customXIBName;

/*!
 * @brief custom Error XIB Name
 */
@property (nonatomic, strong) IBInspectable NSString *customErrorXIBName;

@end
