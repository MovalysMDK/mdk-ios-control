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


//Tags
#import "Protocol.h"
#import "Error.h"

#import "MDKControlProtocol.h"


@protocol MDKControlAssociatedLabelProtocol;

//Framework constants
FOUNDATION_EXPORT NSTimeInterval const ERROR_BUTTON_ANIMATION_DURATION;
FOUNDATION_EXPORT CGFloat const ERROR_BUTTON_SIZE;
IB_DESIGNABLE

/*!
 * @class MDKBaseControl
 * @brief The main class for all framework components
 * @discussion It represents a base framework component. 
 * @discussion It allows to represent any kind of components (label, texfield, slider ...), with the benefits of binding. 
 * @discussion This class allows to add an error button associated to a tooltip when the error button is clicked.
 * @warning If you need to create a custom component binded with the framework, you ALWAYS should inherits this class. If your custom component have some basic methods of another basic iOS component, you can combine with a category that forwards needed methods and properties
 */
@interface MDKBaseControl : UIControl<MDKControlProtocol, MDKControlAssociatedLabelProtocol>


#pragma mark - Properties

/*!
 * @brief The component that holds or has created this component
 */
@property (nonatomic, weak) MDKBaseControl *sender;

/*! 
 * @brief Info-bulle affichant la liste des erreurs
 */
@property (nonatomic, strong) MDKTooltipView *baseTooltipView;


/*!
 * @brief MF Parent Composant
 */
@property (nonatomic, weak) MDKBaseControl *mfParent;


/*!
 * @brief initialisation
 */
@property (nonatomic, strong) NSNumber *parentEditable;

/*!
 * @brief The data manged by the control.
 * @discussion This property is set by the setdata method.
 * @see MDKControlDataProtocol
 */
@property (nonatomic, strong) id controlData;


#pragma mark - Methods

/*!
 * @brief Custom init that initialize the component with a specified frame, on set another sender component.
 * @param frame The frame opf the created componenty
 * @param sender The component that holds this component
 * @return The created component.
 */
- (instancetype)initWithFrame:(CGRect)frame withSender:(MDKBaseControl *)sender;

/*!
 * @brief Initialise certains propriétés de la classe
 */
-(void) initialize;

/*!
 * @brief Allows to display or not the view that indicates that the component is in an invalid state
 * @param showErrorView A BOOL value that indicates if the component is in an invalid state or not
 */
-(void) showError:(BOOL)showErrorView;

/*!
 * @brief Permet de vider la liste des erreurs
 */
-(void) clearErrors;

/*!
 * @brief Permet d'ajouter des erreurs à la liste des erreurs
 * @param errors Une liste d'erreurs à ajouter
 */
-(void) addErrors:(NSArray *) errors;


/*!
 * @brief This method is called after the STYLE has been applied to the component and the subcomponents of its method.
 * You can do some customizations here on the component
 */
-(void) selfCustomization;



@end
