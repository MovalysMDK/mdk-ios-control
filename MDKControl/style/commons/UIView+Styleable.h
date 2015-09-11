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

/*!
 * @category Styleable
 * @brief This category adds style methods on views.
 * @discussion It is used to apply MDK Style classes
 */
@interface UIView (Styleable)

/*!
 * @brief Applies the standard style on this view.
 * The standard style is the style when the view is not on
 * a valid or invalid state.
 */
-(void) applyStandardStyle;

/*!
 * @brief Applies the valid style on this view.
 */
-(void) applyValidStyle;

/*!
 * @brief Applies the error style on this view.
 */
-(void) applyErrorStyle;

/*!
 * @brief Applies the enabled style on this view.
 */
-(void) applyEnabledStyle;

/*!
 * @brief Applies the disabled style on this view.
 */
-(void) applyDisabledStyle;

@end
