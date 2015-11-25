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
@class MDKUIFixedList;

/*!
 * @protocol MDKUIFixedListDataProtocol
 * @brief This protocol defines available methods to custom a FixedList component
 * @discussion Some of methods declared in this protocol are required.
 * It must be implemented in the project.
 */
@protocol MDKUIFixedListDataProtocol <NSObject>

#pragma mark - Required Methods


/*!
 * @brief The xib name to used for all items of the FixedList
 * @discussion The XIB file pointed by this method must exist and contain a unique view that
 * inherits from UITableViewCell.
 * @return The xib name to used for all items of the FixedList
 */
@required
-(NSString *) xibNameForFixedListCells;

/*!
 * @brief This method allows to map a cell of the FixedList to the associated object
 * @discussion It should be used to dispatch object values to the inner components of the given cell
 * @param fixedList The FixedList component managed by this delegate
 * @param cell The cell to map
 * @param object The object used to map the cell
 * @param indexPath The indexPath of the given cell
 */
@required
-(void)fixedList:(MDKUIFixedList *)fixedList mapCell:(UITableViewCell *)cell withObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Optional methods
/*!
 * @brief Returns the number of rows that should be shown in the fixedList.
 * @discussion The returned value must be inferior than the given totalNumberOfRows parameter
 * @param totalNumberOfRows The total number of rows that can actually be displayed in the FixedList
 * @return the number of rows to show in the FixedList
 */
@optional
-(NSInteger)fixedList:(MDKUIFixedList *)fixedList numberOfRows:(NSInteger)totalNumberOfRows;

/*!
 * @brief Returns the cell height of items of the FixedList
 * @param originalCellHeight The original cell height computed by the given XIB item cells.
 * @return The hight of the items of FixedList
 */
@optional
-(CGFloat)fixedList:(MDKUIFixedList *)fixedList heightForFixedListCells:(NSInteger)originalCellHeight;

/**
 * @brief Event called when the addButton of the Fixed List is tapped
 * @discussion The method must be implemented in the user project.
 */
@optional
-(id) addItemOnFixedList:(id)sender;

/*!
 * @brief Event called when a row is selected
 * @param fixedList The fixedList managed by the delegate that implements this protocol.
 * @param indexPath The indexPath of the selected row
 * @param object The object asscoated to this row.
 */
@optional
-(void)fixedList:(MDKUIFixedList *)fixedList didSelectRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;



/*!
 * @brief Event called when a row will be deleted
 * @param fixedList The fixedList managed by the delegate that implements this protocol.
 * @param indexPath The indexPath of the deleted row
 * @param object The object assciated to this row.
 */
@optional
-(void)fixedList:(MDKUIFixedList *)fixedList willDeleteRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;



/*!
 * @brief Event called when a row has been deleted
 * @param fixedList The fixedList managed by the delegate that implements this protocol.
 * @param indexPath The indexPath of the deleted row
 * @param object The object asscoated to this row.
 */
@optional
-(void)fixedList:(MDKUIFixedList *)fixedList didDeleteRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;



@end
