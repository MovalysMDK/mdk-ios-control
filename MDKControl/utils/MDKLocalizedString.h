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
 * @class MDKLocalizedString
 * @brief Util class to retrieve a localized string from strings files.
 * @discussion By default, a string is retrieved in project bundle, and 
 * if it's nil, it will be retrieved in this framework bundle. If it's again,
 * the key used to retrieve a localized string will be returned.
 */
@interface MDKLocalizedString : NSObject

#pragma mark - Static methods

/*!
 * @brief Returns a localized string given a key
 * @discussion The localizable string will be retrieved from the default "Localizable" table
 * @param key The key of the localizable string to retrieve
 * @return The localizable string corresponding to the given key, or the key itself if a localizable
 * string can not be found.
 */
+(NSString *)localizableStringFromKey:(NSString *)key;

/*!
 * @brief Returns a localized string given a key and a class
 * @discussion The localizable string will be retrieved from the default "Localizable" table in
 * the bundle that contains the given class
 * @param key The key of the localizable string to retrieve
 * @param aClass The class that will identify the bundle to use to retrieve a localizable string
 * @return The localizable string corresponding to the given key, or the key itself if a localizable
 * string can not be found.
 */
+(NSString *)localizableStringFromKey:(NSString *)key forClass:(Class)aClass;

/*!
 * @brief Returns a localized string given a key and a table
 * @discussion The localizable string will be retrieved from the given table
 * @param key The key of the localizable string to retrieve
 * @param table The table from where to retrieve the localizable string
 * @return The localizable string corresponding to the given key, or the key itself if a localizable
 * string can not be found.
 */
+(NSString *)localizableStringFromKey:(NSString *)key inTable:(NSString *)table;

/*!
 * @brief Returns a localized string given a key, a table and a class
 * @discussion The localizable string will be retrieved from the default "Localizable" table in
 * the bundle that contains the given class
 * @param key The key of the localizable string to retrieve
 * @param table The table from where to retrieve the localizable string
 * @param aClass The class that will identify the bundle to use to retrieve a localizable string
 * @return The localizable string corresponding to the given key, or the key itself if a localizable
 * string can not be found.
 */
+(NSString *)localizableStringFromKey:(NSString *)key inTable:(NSString *)table forClass:(Class)aClass;

@end


/*!
 * Cette macro permet d'appeller MFLocalizedString de la même manière que NSLocalizedString
 */
#define MDKLocalizedString(key, comment)                 \
[MDKLocalizedString localizableStringFromKey:key]        \

/*!
 * Cette macro permet d'appeller MFLocalizedString de la même manière que NSLocalizedString
 */
#define MDKLocalizedStringForClass(key, class, comment)                 \
[MDKLocalizedString localizableStringFromKey:key forClass:class]        \


/*!
 * Cette macro permet d'appeller MFLocalizedString de la même manière que NSLocalizedString
 */
#define MDKLocalizedStringFromTable(key, table, comment)               \
[MDKLocalizedString localizableStringFromKey:key inTable:table]        \


/*!
 * Cette macro permet d'appeller MFLocalizedString de la même manière que NSLocalizedString
 */
#define MDKLocalizedStringFromTableForClass(key, table, class, comment)                       \
[MDKLocalizedString localizableStringFromKey:key inTable:table forClass:class]        \
