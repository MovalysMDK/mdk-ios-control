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
#import <UIKit/UIKit.h>
@class MDKUIFixedList;

/*!
 * @class MDKUIFixedListTableViewDelegate
 * @brief The TableView delegate that manages the content of the FixedList
 */
@interface MDKUIFixedListTableViewDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

#pragma mark - Methods

/*!
 * @brief Initializes a new TableViewDelegate based on the given FixedList
 * @param fixedList The FixedList the TableView will be managed by this delegate
 * @return A new instance of a TableViewDelegate
 */
-(instancetype) initWithFixedList:(MDKUIFixedList *)fixedList;


/*!
 * @brief Refresh the edition properties of the tableView
 */
-(void)refreshEditionProperties;

@end