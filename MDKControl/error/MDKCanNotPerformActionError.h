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
 * @brief Specific error code.
 */
FOUNDATION_EXPORT NSInteger const CAN_NOT_PERFORM_ACTION_ERROR_CODE;

/*!
 * @brief Specific localized description key.
 */
FOUNDATION_EXPORT NSString *const CAN_NOT_PERFORM_ACTION_ERROR_LOCALIZED_DESCRIPTION_KEY;

#import "MDKValidationError.h"

/*!
 * @class MDKCanNotPerformActionError
 * @brief Report a action that cannot be performed error.
 * @discussion An instance of this error type must be associated with a field name.
 */
@interface MDKCanNotPerformActionError : MDKValidationError


/*!
 * @brief Init new instance.
 * @param fieldName - Associated displayed field name.
 * @param object An object to pass in the error
 * @return New instance of MDKCanNotPerformActionError.
 */
-(id)initWithLocalizedFieldName:(NSString *)fieldName technicalFieldName:(NSString *) technicalFieldName withObject:(id)object;

@end
