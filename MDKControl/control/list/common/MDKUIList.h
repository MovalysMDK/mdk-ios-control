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


/******************************************************/
/* CONSTANTES KEY                                     */
/******************************************************/

/*!
 * @brief The key for MDKUIListIdentifier allowing to name component identifier
 */
FOUNDATION_EXTERN NSString *const MDKUIListIdentifier;


/******************************************************/
/* PROTOCOLE                                          */
/******************************************************/

@protocol MDKUIListDelegate <NSObject>

/*!
 * @brief Send notification if user did tap on cell
 */
- (void)userDidSelectCell:(NSString *)text;

@end


@interface MDKUIList : UIView

/*!
 * @brief Table view for list all elements
 */
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/*!
 * @brief Delegate for MDKUIListDelegate protocol
 */
@property (nonatomic, weak) id<MDKUIListDelegate> delegate;

/*!
 * @brief Allow to initialize all rows with an enum class name
 */
- (void)initializeRowsWithEnumClassName:(NSString *)enumClassName;

@end
