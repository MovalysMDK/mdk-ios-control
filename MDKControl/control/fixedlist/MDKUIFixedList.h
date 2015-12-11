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

FOUNDATION_EXPORT NSString *const FIXEDLIST_PARAMETER_DATA_DELEGATE_KEY;
FOUNDATION_EXPORT NSString *const FIXEDLIST_PARAMETER_CAN_MOVE_KEY;
FOUNDATION_EXPORT NSString *const FIXEDLIST_PARAMETER_CAN_ADD_KEY;
FOUNDATION_EXPORT NSString *const FIXEDLIST_PARAMETER_CAN_DELETE_KEY;
FOUNDATION_EXPORT NSString *const FIXEDLIST_PARAMETER_CAN_SELECT_KEY;


/******************************************************/
/* MAIN CONTROL                                       */
/******************************************************/


IB_DESIGNABLE

/*!
 * @class MDKUIFixedList
 * @brief The FixedList framework component
 * @discussion This components allows to show a list that could be edited :
 * each item of the liste can be edited, deleted, moved. It is also possible
 * to add a new item.
 */
@interface MDKUIFixedList : MDKRenderableControl <MDKControlChangesProtocol>

#pragma mark - Properties

/*!
 * @brief the AddItem button of the FixedList
 */
@property (weak, nonatomic) IBOutlet UIButton *addButton;

/*!
 * @brief The TableView of theFixedList
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


#pragma mark - Methods

/*!
 * @brief Returns the FixedList delegate that manages this control
 * @return The delegate that manages this FixedList.
 */
-(id<MDKUIFixedListDataProtocol>) fixedListDelegate;
- (IBAction)addButtonAction:(id)sender;

@end

/******************************************************/
/* INTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIInternalFixedList : MDKUIFixedList <MDKInternalComponent>

@end


/******************************************************/
/* EXTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIExternalFixedList : MDKUIFixedList <MDKExternalComponent>

/*!
 * @brief custom XIB name
 */
@property (nonatomic, strong) IBInspectable NSString *customXIBName;

/*!
 * @brief custom Error XIB Name
 */
@property (nonatomic, strong) IBInspectable NSString *customMessageXIBName;

@end
