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


/*!
 * @protocol MDKConverterProtocol
 * @brief This protocol describes a Converter
 */
@protocol MDKConverterProtocol <NSObject>


#pragma mark - Methods
/*!
 * @brief Creates and intializes a new instance of converter with the given parameters
 * @param parameters Some specific parameters to use in conversion
 * @return The new built and initilized instance of the converter
 */
- (id)initWithParameters:(NSDictionary *)parameters;

#pragma mark - Class methods


@optional
/*!
 * @brief Cette méthode convertit un objet définit par la classe implémentant ce protocole en NSString
 * @param la valeur à convertir.
 * @return la valeur convertie en NSString
 */
+ (NSString *)toString:(id)value;

@optional
/*!
 * @brief Cette méthode convertit un objet définit par la classe implémentant ce protocole en NSString
 * @param la valeur à convertir.
 * @return la valeur convertie en NSString
 */
+ (NSString *)toStringForValidation:(id)value;


@optional
/*!
 * @brief Cette méthode convertit un objet définit par la classe implémentant ce protocole en NSString
 * @param la valeur à convertir.
 * @return la valeur convertie en NSString
 */
+ (NSString *)toNumber:(id)value;

@optional
/*!
 * @brief Cette méthode convertit un objet définit par la classe implémentant ce protocole en NSString
 * @param la valeur à convertir.
 * @return la valeur convertie en NSString
 */
+ (NSDate *)toDate:(id)value;


@end
