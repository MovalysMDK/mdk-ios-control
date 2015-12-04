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
#import "MDKPickerListBaseDelegate.h"
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

/*!
 * @class MDKUIPickerList
 * @brief This component allow to launch an enum list with custom view defined by user.
 */
IB_DESIGNABLE
@interface MDKUIPickerList : MDKRenderableControl <MDKControlChangesProtocol>

#pragma mark - Properties

/*!
 * @brief button action
 */
@property (nonatomic, weak) IBOutlet UIButton *button;

/*!
 * @brief The selected view that shows the selected item of the picker list
 */
@property (nonatomic, weak) UIView *selectedView;

/*!
 * @brief The view that shows a table view containing all the items of picker list
 */
@property (nonatomic, strong) MDKUIList *uiList;

/*!
 * @brief The delegate used to manage the list.
 */
@property (nonatomic, strong) MDKPickerListBaseDelegate<MDKUIPickerListDataProtocol> *userListDelegate;

/*!
 * @brief The delegate used to manage the selected view.
 */
@property (nonatomic, strong) NSObject<MDKUIPickerSelectedDataProtocol> *userSelectedDelegate;


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




/******************************************************/
/* FILTER                                             */
/******************************************************/

/*!
 * @protocol MDKPickerListFilterProtocol
 * @brief A protocol that identfy a PickerList filter
 * @discussion The class that implements this protocol can filter a list of picker items bu
 * implementing the filterItems:withString: method
 */
@protocol MDKPickerListFilterProtocol <NSObject>

/*!
 * @brief Filters a given array of items with a given string
 * @param items An array of items
 * @param string The string used to filter
 * @return An array of filtered items
 */
@required
-(NSArray *)filterItems:(NSArray *)items withString:(NSString *)string;

@end


@interface MDKPickerListDefaultFilter : NSObject <MDKPickerListFilterProtocol>

@end


