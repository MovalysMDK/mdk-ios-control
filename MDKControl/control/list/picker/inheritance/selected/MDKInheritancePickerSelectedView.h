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
#import "MDKUIPickerSelectedDataProtocol.h"


@class MDKUIPickerList;


/*!
 * @class MDKInheritancePickerSelectedView
 * @brief The MDKInheritancePickerSelectedView framework
 * @discussion This object allow to simply user's life. You have to inherit of this object to
 * initialize your selected view
 */
@interface MDKInheritancePickerSelectedView : NSObject <MDKUIPickerSelectedDataProtocol>

#pragma mark - Properties
/*!
 * @brief Picker list property
 */
@property (nonatomic, weak) MDKUIPickerList *pickerList;

#pragma mark - Methods
/*!
 * @brief This method is called on MDKUIPickerList - User can override it to implement his initialization of custom selected view
 */
- (instancetype)initWithPickerList:(MDKUIPickerList *)pickerList;

@end
