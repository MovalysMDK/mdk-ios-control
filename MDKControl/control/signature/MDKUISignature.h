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

#import "MDKRenderableControl.h"

/******************************************************/
/* MAIN CONTROL                                       */
/******************************************************/

IB_DESIGNABLE
/*!
 * @class MDKUIScanner
 * @brief The Scanner Framework Component.
 * @discussion This component allows to scan a barcode or QRCode
 * directly on the screen it is displayed.
 */
@interface MDKUISignature : MDKRenderableControl <MDKControlChangesProtocol>
@property (weak, nonatomic) IBOutlet UIView *signatureView;

@end


/******************************************************/
/* INTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIInternalSignature : MDKUISignature <MDKInternalComponent>

@end


/******************************************************/
/* EXTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIExternalSignature : MDKUISignature <MDKExternalComponent>

/*!
 * @brief custom XIB name
 */
@property (nonatomic, strong) IBInspectable NSString *customXIBName;

/*!
 * @brief custom Error XIB Name
 */
@property (nonatomic, strong) IBInspectable NSString *customMessageXIBName;

@end


