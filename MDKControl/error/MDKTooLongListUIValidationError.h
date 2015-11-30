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


#import "MDKValidationError.h"


/*!
 * @brief Specific error code.
 */
FOUNDATION_EXPORT NSInteger const TOO_LONG_LIST_UI_VALIDATION_ERROR_CODE;

/*!
 * @brief Specific localized description key.
 */
FOUNDATION_EXPORT NSString *const TOO_LONG_LIST_UI_VALIDATION_ERROR_LOCALIZED_DESCRIPTION_KEY;


/*!
 * @class MDKTooLongListUIValidationError
 * @brief Report a too long user data keyboarding.
 * @discussion An instance of this error type must be associated with a field name.
 */
@interface MDKTooLongListUIValidationError : MDKValidationError

/*!
 * @brief Init new instance.
 * @param fieldName - Associated displayed field name.
 * @param object An object to pass in the error
 * @return New instance of MDKTooLongListUIValidationError.
 */
-(id)initWithLocalizedFieldName:(NSString *)fieldName technicalFieldName:(NSString *) technicalFieldName withObject:(id)object;
@end
