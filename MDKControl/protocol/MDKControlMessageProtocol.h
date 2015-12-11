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
#import "MDKTooltipView.h"

/*!
 * @protocol MDKControlMessageProtocol
 * @brief This protocol defines properties and methods to manage errors on controls
 */
@protocol MDKControlMessageProtocol <NSObject>

#pragma mark - Properties

/*!
 * @brief The array of the errors of the component.
 */
@property (nonatomic, strong) NSMutableArray *messages;


/*!
 * @brief The tooltip displayed when the user taps on the buttonMessage of the errorView
 */
@property (nonatomic, strong) MDKTooltipView *tooltipView;

#pragma mark - Methods

/*!
 * @brief Clean all component errors
 */
-(void) clearMessages;

/*!
 * @brief Returns a array containing the error(s) of the component
 * @return  An array containing the error(s) of the component 
 */
-(NSArray *) getMessages;

/*!
 * @brief Adds an array of errors to the component
 * @param errors An array of errors 
 */
-(void) addMessages:(NSArray *) errors;

/*!
 * @brief Shows or hides the error view of the component
 * @param showMessage BOOL that is YES to show the error view, or NO to hide it.
 */
-(void) showMessage:(BOOL)showMessage;


@end
