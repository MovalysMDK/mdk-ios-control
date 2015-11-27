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

#import "Protocol.h"

/*!
 * @class MDKUIFixedListBaseDelegate
 * @brief This class is the base FixedList Delegate to manage a FixedList.
 * @discussion It must me inherited in the user-project to make the FixedList working
 */
@interface MDKUIFixedListBaseDelegate : NSObject <MDKUIFixedListDataProtocol>

#pragma mark - Methods
/*!
 * @brief Create a new instance of MDKUIFixedListBaseDelegate based on a FixedList instance.
 * @param fixedList The FixedList control that will be managed by this delegate
 * @return The new created instance of MDKUIFixedListBaseDelegate
 */
-(instancetype)initWithFixedList:(MDKUIFixedList *)fixedList;

@end
