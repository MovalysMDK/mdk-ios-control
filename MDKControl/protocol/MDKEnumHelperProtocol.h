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
 * @protocol MDKEnumHelperProtocol
 * @brief This helper may be used to translates enumerations values into strings values,
 * and vice versa
 */
@protocol MDKEnumHelperProtocol <NSObject>

@required
/*!
 * @brief return text from enumeration value
 * @param nsnEnum value for enumeration
 * @return text for enumeration value name
 */
+(NSString *)textFromEnum:(NSNumber *)nsnEnum;

/*!
 * @brief return enumeration value matching text
 * @param nssText text for enumeration value name
 * @return int enumeration value matching text
 */
+(int)enumFromText:(NSString *)nssText;

/*!
 * @brief return array of strings for enumeration values names
 * @return NSArray of NSString for enumeration values names
 */
+(NSArray *)valuesToTexts;

/*!
 * @brief return count for enumeration values
 * @return NSUInteger for enumeration values count
 */
+(NSUInteger)valuesCount;

@end
