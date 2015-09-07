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

#import "Protocol.h"

#import "MDKControlDelegate.h"
#import "MFUIErrorView.h"

@protocol MDKStyleProtocol;



/*!
 * @protocol MDKControlProtocol
 * @brief This is the main protocol to describes a MDK Control.
 * @discussion It gives all properties and methods needed to make a view a MDK Control.
 */
@protocol MDKControlProtocol <MDKControlDataProtocol, MDKControlErrorProtocol, MDKControlPropertiesProtocol, MDKControlValidationProtocol, MDKControlAttributesProtocol, MDKControlAssociatedLabelProtocol>

#pragma mark - Properties

@property (nonatomic, strong) MDKControlDelegate *controlDelegate;

/*!
 * @brief UI control display name.
 */
@property(nonatomic, strong) NSString *localizedFieldDisplayName;

/*!
 * @brief The name of the custom class to use to render component style
 */
@property (nonatomic, strong) NSString *styleClassName;

/*!
 * @brief The instance of the style lass to use to render the component style.
 */
@property (nonatomic, strong) NSObject<MDKStyleProtocol> *styleClass;

/*!
 * @brief Indicates if the component self-validation is active
 */
@property (nonatomic) BOOL componentValidation;

/*!
 * @brief initialisation
 */
@property (nonatomic) BOOL inInitMode;

/*!
 * @brief L'IndexPath de la cellule dans laquelle se trouve ce composant.
 */
@property (nonatomic, strong) NSIndexPath *componentInCellAtIndexPath;

/*!
 * @brief The last object that updates the valus of this control.
 */
@property (nonatomic, weak) id lastUpdateSender;


@end
