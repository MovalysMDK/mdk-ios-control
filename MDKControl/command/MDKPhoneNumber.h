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
 * @class MDKPhoneNumber
 * @brief This class describes a phone number
 */
@interface MDKPhoneNumber : NSObject

#pragma mark - Properties
/*!
 * @brief The base phone number
 */
@property (nonatomic, strong) NSString *baseNumber;

/*!
 * @brief The international prefix number, like '33' for France
 */
@property (nonatomic, strong) NSString *internationalPrefix;

/*!
 * @brief The potential symbol prefix ('+');
 */
@property (nonatomic, strong) NSString *symbolPrefix;

#pragma mark - Methods

/**
 * @brief Builds an returns a string that represents this phone number
 * @return A phone number as string
 */
-(NSString *) buildPhoneString;
@end
