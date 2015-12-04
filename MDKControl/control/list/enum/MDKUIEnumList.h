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

#import "MDKRenderableControl.h"


/******************************************************/
/* CONSTANTES KEY                                     */
/******************************************************/

/*!
 * @brief The key for MDKUIEnumListKey allowing to add control attributes
 */
FOUNDATION_EXTERN NSString *const MDKUIEnumListKey;


/******************************************************/
/* MAIN CONTROL                                       */
/******************************************************/


/*!
 * @class MDKUIEnumList
 * @brief This component allow to launch the enum list
 */
IB_DESIGNABLE
@interface MDKUIEnumList : MDKRenderableControl <MDKControlChangesProtocol>

#pragma mark - Properties

/*!
 * @brief button action
 */
@property (nonatomic, weak) IBOutlet UIButton *button;

@end


/******************************************************/
/* INTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIInternalEnumList : MDKUIEnumList <MDKInternalComponent>
@end


/******************************************************/
/* EXTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIExternalEnumList : MDKUIEnumList <MDKExternalComponent>

/*!
 * @brief custom XIB name
 */
@property (nonatomic, strong) IBInspectable NSString *customXIBName;

/*!
 * @brief custom Error XIB Name
 */
@property (nonatomic, strong) IBInspectable NSString *customErrorXIBName;

@end
