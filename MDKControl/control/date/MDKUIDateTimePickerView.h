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

#import <UIKit/UIKit.h>

#import "MDKUIDateTime.h"

/*!
 * @class MDKUIDateTimePickerView
 * @brief This view is shown to pick a date/time, when the user 
 * tap on DateTime component
 */
@interface MDKUIDateTimePickerView : UIView

#pragma mark - Properties

/*!
 * @brief The content view of the picker
 */
@property (weak, nonatomic) IBOutlet UIView *contentView;

/*!
 * @brief The inner DatePicker
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

/*!
 * @brief The source DateTime component that shows this picker
 */
@property (weak, nonatomic) MDKUIDateTime *sourceComponent;


#pragma mark - Methods
/*!
 * @brief Refreshs the picker given a date and a mode
 * @param date The date to display
 * @param mode The mode to use to show the date
 */
-(void) refreshWithDate:(NSDate *)date andMode:(MDKDateTimeMode)mode;

/*!
 * @brief Dismiss the picker
 */
-(void)dismiss;

@end
