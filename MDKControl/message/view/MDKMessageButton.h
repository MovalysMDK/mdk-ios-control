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
#import "MDKMessageUIManager.h"
/*!
 * @class MDKMessageButton
 * @brief The button used to show the errors
 */
IB_DESIGNABLE
@interface MDKMessageButton : UIButton

#pragma mark - Properties

/*!
 * @brief The color of the message button
 */
@property (nonatomic, strong) UIColor *color;

#pragma mark - Methods

/*!
 * @brief Builds an new instance with a given color
 * @param color The color of the message button
 * @return The new built instance
 */
-(instancetype)initWithColor:(UIColor *)color;


@end
