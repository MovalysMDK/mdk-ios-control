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

IB_DESIGNABLE
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

/*!
 * @brief The setp of the slider
 */
@property (nonatomic) float step;


@end


IB_DESIGNABLE
@interface MDKUIInternalSlider : MDKUISlider <MDKInternalComponent>

@end


IB_DESIGNABLE
@interface MDKUIExternalSlider : MDKUISlider <MDKExternalComponent>

@property (nonatomic, strong) IBInspectable NSString *customXIBName;
@property (nonatomic, strong) IBInspectable NSString *customErrorXIBName;

@end

// on met le header à la fin car la classe doit être déclarée avant la categorie.
// ne pas déplacer

#import "MDKUISlider+UISliderForwarding.h"
