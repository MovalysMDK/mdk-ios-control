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
 * @brief Cette classe de type Helper permet de détecter le type d'un objet dans une classe
 */
@interface MDKHelperType : NSObject

/*!
 * @brief Cette méthode permet de retourner sous forme d'une chaînde de caractère le type
 * d'un objet pour une classe données.
 * @param key Le nom de l'objet dont on souhaite récupérer le type
 * @param classOfModel La classe dans laquelle on souhaite récupérer le type de l'objet nommé par la variable "key"
 * @return Le type de l'objet spécifié dans la classe spécifiée, sous forme de chaîne de caractère. Le type retourné
 * peut être primitif ou complexe
 */
+(NSString *) getClassOfObjectWithKey:(NSString *)key inClass:(Class)classOfModel;


/*!
 * @brief Cette méthode permet de retourner sous forme d'une chaîne de caractère le nom d'une classe avec "Helper" à la fin
 * @param key Le nom de la classe
 * @return Un objet NSString contenant le nom de la classe avec "Helper" à la fin
 */
+(NSString *) getClassHelperOfClassWithKey:(NSString *)key;


/*!
 * @brief Renvoie le type d'une vue sous forme d'une chaîne de caractère
 * @param primitiveTypeKey La clé du type primitf retournée par la fonction processTypeFromString
 * @return Le nom du type primitf (int, unsigned, float, double etc ...)
 */
+(NSString *)processViewTypeFromView:(id)view;

/*!
 * @brief Renvoie le type élagué de tout préfixe Objective-C ou Framework
 */
+ (NSString *)primaryType:(NSString *)type;
@end
