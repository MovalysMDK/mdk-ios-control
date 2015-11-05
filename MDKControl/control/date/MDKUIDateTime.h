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

/*!
 * @class MDKDateTime
 * @brief The date framework component
 * @discussion This components allows to choose and display a date, a time, or a datetime.
 */
IB_DESIGNABLE
@interface MDKUIDateTime : MDKRenderableControl <MDKControlChangesProtocol>


#pragma mark - Custom enumeration (edit mode options)
/*!
 * @brief This structure defines the mode of the date Picker
 * MFDatePickerModeDate : The view displayed is a date Picker
 * MFDatePickerModeTime : The view displayed is a time Picker
 * MFDatePickerModeDateTime : The view displayed is a dateTime Picker
 */
typedef enum {
    MDKDateTimeModeDate = 0,
    MDKDateTimeModeTime = 1,
    MDKDateTimeModeDateTime = 2
} MDKDateTimeMode;


#pragma mark - Properties

/*!
 * @brief The button displays a selected date and allow to display the picker to choose another one
 */
@property (nonatomic, strong) IBOutlet UIButton *dateButton;

/*!
 * @brief The date format the component must adopt
 */
@property (nonatomic, strong) IBInspectable NSString *MDK_dateFormat;

/*!
 * @brief The time mode the component must adopt
 */
@property (nonatomic) IBInspectable MDKDateTimeMode MDK_dateTimeMode;

@end



IB_DESIGNABLE
@interface MDKUIInternalDateTime : MDKUIDateTime <MDKInternalComponent>

@end


IB_DESIGNABLE
@interface MDKUIExternalDateTime : MDKUIDateTime <MDKExternalComponent>

/*!
 * @brief custom XIB name
 */
@property (nonatomic, strong) IBInspectable NSString *customXIBName;

/*!
 * @brief custom Error XIB Name
 */
@property (nonatomic, strong) IBInspectable NSString *customErrorXIBName;

@end





