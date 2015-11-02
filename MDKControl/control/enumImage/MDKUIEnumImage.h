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


#import "Converter.h"
#import "MDKRenderableControl.h"


/******************************************************/
/* CONSTANTES KEY                                     */
/******************************************************/

/*!
 * @brief The key for MDKUIEnumImage allowing to add control attributes
 */
FOUNDATION_EXTERN NSString *const MDKUIEnumImageKey;


/******************************************************/
/* MAIN CONTROL                                       */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIEnumImage : MDKRenderableControl <MDKControlChangesProtocol>

#pragma mark - Properties
/*!
 * @brief The image view that displays the image of an enum
 */
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

/*!
 * @brief The label that displays a text if no image is found
 */
@property (nonatomic, weak) IBOutlet UILabel *label;

@end



/******************************************************/
/* INTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIInternalEnumImage : MDKUIEnumImage <MDKInternalComponent>

@end



/******************************************************/
/* EXTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIExternalEnumImage : MDKUIEnumImage <MDKExternalComponent>

/*!
 * @brief custom XIB name
 */
@property (nonatomic, strong) IBInspectable NSString *customXIBName;

/*!
 * @brief custom Error XIB Name
 */
@property (nonatomic, strong) IBInspectable NSString *customErrorXIBName;

@end
