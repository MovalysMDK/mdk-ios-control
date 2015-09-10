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
#import "Protocol.h"

#import  "MDKControlProtocol.h"

/*!
 * @class MDKTextField
 * @brief The Text Field component
 * @discussion This component inherits from iOS UITextField
 */

IB_DESIGNABLE
@interface MDKTextField : UITextField <MDKControlProtocol, MDKControlChangesProtocol>

#pragma mark - Properties


/*!
 * @brief An IBInscpectable properties that allows to show the error 
 * button on InterfaceBuilder
 */
@property (nonatomic) IBInspectable BOOL onError_MDK;

/*!
 * @brief A MDK Control that hold this MDKTextField instance
 */
@property (nonatomic, weak) id<MDKControlProtocol> sender;


#pragma mark - Methods
-(void)setIsValid:(BOOL) isValid;

/*!
 * @brief A method that is called at the initialization of the component
 * to do some treatments.
 */
-(void) initializeComponent;

/*!
 * @brief Gets the string data of the component
 * @discussion This method should be used when the data managed by the component is a 
 * of Kind 'NSAttributedString'.
 * @return The data of the component as NSSring.
 */
-(NSString *) stringData;

/*!
 * @brief This method allows to add some views to the TextField
 * @param accessoryViews A dictionary that contains key/value pairs as follow :
 * key is a NSString  custom identifier object that correspond to a 
 * UIView accessory view value to add to the component. 
 * @discussion The key NSString-typed identifiers should be defined 
 * in a MDK style class (that implements MFStyleProtocol).
 * @see MFStyleProtocol
 */
-(void) addAccessories:(NSDictionary *) accessoryViews;

/*!
 * @brief The event called when the error button is clicked
 * @discussion This method is sometimes called by validators to force the error to display
 * @param sender The sender of the event
 */
-(void) onErrorButtonClick:(id)sender;
@end

