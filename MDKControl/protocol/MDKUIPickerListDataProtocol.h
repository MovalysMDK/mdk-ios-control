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
@class MDKUIPickerList;
@class MDKUIList;

/*!
 * @protocol MDKUIPickerListDataProtocol
 * @brief This protocol defines available methods to custom a PickerList component
 * @discussion Some of methods declared in this protocol are required.
 * It must be implemented in the project.
 */
@protocol MDKUIPickerListDataProtocol <UITableViewDataSource, UITableViewDelegate>


#pragma mark - Properties
/*!
 * @brief The picker managed by this delegate
 */
@property (nonatomic, strong) MDKUIPickerList *picker;

/*!
 * @brief The list displayed by the picker list
 */
@property (nonatomic, weak) MDKUIList *list;




#pragma mark - Required Methods
@required

/*!
 * @brief The xib name to used for all items of the PickerList
 * @discussion The XIB file pointed by this method must exist and contain an unique view that
 * inherits from UITableViewCell.
 * @return The xib name to used for all items of the PickerList
 */
- (NSString *)xibNameForPickerListCells;


@end
