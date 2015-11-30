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
#import "MDKUIList.h"


/******************************************************/
/* CONSTANTES KEY                                     */
/******************************************************/

/*!
 * @brief The key for MDKUIPickerViewKey allowing to handle external delegate
 */
FOUNDATION_EXTERN NSString *const MDKUIPickerListDelegateKey;

/*!
 * @brief The key for MDKUIPickerListKey allowing to handle external delegate
 */
FOUNDATION_EXPORT NSString *const MDKUIPickerSelectedDelegateKey;


/******************************************************/
/* MAIN CONTROL                                       */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIPickerList : MDKRenderableControl <MDKControlChangesProtocol>

#pragma mark - Properties

/*!
 * @brief button action
 */
@property (nonatomic, weak) IBOutlet UIButton *button;

/*!
 * @brief The view for table view
 */
@property (nonatomic, strong) MDKUIList *uiList;

@end


/******************************************************/
/* INTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIInternalPickerList : MDKUIPickerList <MDKInternalComponent>
@end


/******************************************************/
/* EXTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIExternalPickerList : MDKUIPickerList <MDKExternalComponent>

/*!
 * @brief custom XIB name
 */
@property (nonatomic, strong) IBInspectable NSString *customXIBName;

/*!
 * @brief custom Error XIB Name
 */
@property (nonatomic, strong) IBInspectable NSString *customErrorXIBName;

@end
