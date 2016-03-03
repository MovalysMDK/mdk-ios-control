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

#import "MDKAbstractStyle_MDK.h"

@implementation MDKAbstractStyle_MDK

+(UIColor *)infoColor {
    return [UIColor colorWithRed:(65.0f/255.0f) green:(115.0f/255.0f) blue:(140.0f/255.0f) alpha:1.0f];
}


+(UIColor *)warnColor {
    return [UIColor colorWithRed:(240.0f/255.0f) green:(125.0f/255.0f) blue:(0.0f/255.0f) alpha:1.0f];
}


+(UIColor *)errorColor {
    return [UIColor colorWithRed:(207.0f/255.0f) green:(2.0f/255.0f) blue:(43.0f/255.0f) alpha:1.0f];
}
@end
