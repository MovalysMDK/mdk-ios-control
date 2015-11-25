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


#import <UIKit/UIKit.h>
@class MDKUIList;


/******************************************************/
/* PROTOCOLE                                          */
/******************************************************/

@protocol MDKUIEnumListProtocol <NSObject>

/*!
 * @brief Send notification if user did tap on cell
 */
- (void)userDidSelectCell:(NSString *)text;

@end


/******************************************************/
/* MAIN CONTROL                                       */
/******************************************************/

@interface MDKDelegateEnumList : NSObject <UITableViewDataSource, UITableViewDelegate>

/*!
 * @brief Initializes a new TableViewDelegate based on the given MDKUIList
 * @param MDKUIList The list the TableView will be managed by this delegate
 * @return A new instance of a TableViewDelegate
 */
- (instancetype)initWithEnumClassName:(NSString *)enumClassName;

/*!
 * @brief Delegate for MDKUIListDelegate protocol
 */
@property (nonatomic, weak) id<MDKUIEnumListProtocol> protocol;

@end
