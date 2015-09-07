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

/*!
 * @protocol MDKControlValidationProtocol
 * @brief This protocol adds methods and properties that
 * allows to validate a MDK Control
 * @discussion The validation depends on the control, and its declared control validators
 */
@protocol MDKControlValidationProtocol <NSObject>

#pragma mark - Properties
/*!
 * Indicate if the control is valid.
 */
@property(nonatomic, setter=setIsValid:) BOOL isValid;


#pragma mark - Methods

/*!
 * Validate the ui component value.
 * @return Number of errors detected by the UI component
 */
@optional
-(NSInteger) validate;

/*!
 * Returns an array of field validators specific to this control only.
 * @retur
 n An array of field validators specific to this control only.
 */
@optional
-(NSArray *) controlValidators;

@end
