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

#import "MDKSliderStyle.h"
#import "MDKUISlider.h"

@implementation MDKSliderStyle


-(void)applyDisabledStyleOnComponent:(id)component {
    ((MDKUISlider *)component).innerSlider.enabled= NO;
    ((MDKUISlider *)component).innerSliderValueLabel.enabled= NO;
}

-(void)applyEnabledStyleOnComponent:(id)component {
    ((MDKUISlider *)component).innerSlider.enabled= YES;
    ((MDKUISlider *)component).innerSliderValueLabel.enabled= YES;
}
@end
