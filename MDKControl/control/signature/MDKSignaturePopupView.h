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
#import "MDKSignatureDrawing.h"

@class MDKUISignature;

/*!
 * @class MDKSignaturePopupView
 * @brief The popup-view that allows to edit a signature for a MDKUISignature control
 * @discussion
 */
@interface MDKSignaturePopupView : UIView

#pragma mark - Properties

/*!
 * @brief The view used to draw
 */
@property (weak, nonatomic) IBOutlet MDKSignatureDrawing *signatureDrawing;

/*!
 * @brief The source MDKUISignature control
 */
@property (weak, nonatomic) MDKUISignature *sourceControl;

@end
