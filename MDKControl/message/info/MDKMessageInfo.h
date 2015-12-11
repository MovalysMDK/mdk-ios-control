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
#import "MDKMessageProtocol.h"





/*!
 * @class MDKMessageInfo
 * @brief A MDK UI Info message to display
 */
@interface MDKMessageInfo : NSObject <MDKMessageProtocol>

#pragma mark - Methods

/*!
 * @brief Build a new instance of
 * @param fieldName The field name that launch an info message
 * @param technicalFieldName The technical field name that launch an info message
 * @param title The title of the info message
 * @param content The content of the info message
 * @param object An object to pass to the info message
 * @return the built initialized instance
 */
-(instancetype)initWithDescriptionKey:(NSString *) descriptionKey withLocalizedFieldName:(NSString *)fieldName technicalFieldName:(NSString *) technicalFieldName withTitle:(NSString *)title withObject:(id)object;

-(id)initWithLocalizedFieldName:(NSString *)fieldName technicalFieldName:(NSString *) technicalFieldName withObject:(id)object;
@end
