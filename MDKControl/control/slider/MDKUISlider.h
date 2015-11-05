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
/* MAIN CONTROL                                       */
/******************************************************/

IB_DESIGNABLE
/*!
 * @class MDKUISlider
 * @brief The Slider Framework Component.
 * @discussion This components allows to choose a numeric value form a slider.
 * By default, the selected value is displayed on the component.
 */
@interface MDKUISlider : MDKRenderableControl <MDKControlChangesProtocol>

#pragma mark - Properties
/*!
 * @brief The inner UISlider component
 */
@property (nonatomic, strong) IBOutlet UISlider *innerSlider;

/*!
 * @brief The inner MFLabel component that displays the value of the slider.
 */
@property (nonatomic, strong) IBOutlet  UILabel *innerSliderValueLabel;

@end


/******************************************************/
/* INTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIInternalSlider : MDKUISlider <MDKInternalComponent>

@end


/******************************************************/
/* EXTERNAL VIEW                                      */
/******************************************************/

IB_DESIGNABLE
@interface MDKUIExternalSlider : MDKUISlider <MDKExternalComponent>

/*!
 * @brief custom XIB name
 */
@property (nonatomic, strong) IBInspectable NSString *customXIBName;

/*!
 * @brief custom Error XIB Name
 */
@property (nonatomic, strong) IBInspectable NSString *customErrorXIBName;

@end


