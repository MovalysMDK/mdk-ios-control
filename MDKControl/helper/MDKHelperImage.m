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

#import "MDKHelperImage.h"


#pragma mark - MDKHelperImage -

@implementation UIImage (MDKHelperImage)

- (UIImage *)squareCropImageWithSideLength:(CGFloat)sideLength {
    // input size comes from image
    CGSize inputSize = self.size;
    
    // round up side length to avoid fractional output size
    sideLength = ceilf(sideLength);
    
    // output size has sideLength for both dimensions
    CGSize outputSize = CGSizeMake(sideLength, sideLength);
    
    // calculate scale so that smaller dimension fits sideLength
    CGFloat scale = MAX(sideLength / inputSize.width, sideLength / inputSize.height);
    
    // scaling the image with this scale results in this output size
    CGSize scaledInputSize = CGSizeMake(inputSize.width * scale, inputSize.height * scale);
    
    // determine point in center of "canvas"
    CGPoint center = CGPointMake(outputSize.width/2.0, outputSize.height/2.0);
    
    // calculate drawing rect relative to output Size
    float x = 0.0f;
    float y = 0.0f;
    x = center.x - scaledInputSize.width/2.0;
    y = center.y - scaledInputSize.height/2.0;
    CGRect outputRect = CGRectMake(x, y, scaledInputSize.width, scaledInputSize.height);
    
    // begin a new bitmap context, scale 0 takes display scale
    UIGraphicsBeginImageContextWithOptions(outputSize, YES, 0);
    
    // optional: set the interpolation quality.
    // For this you need to grab the underlying CGContext
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    
    // draw the source image into the calculated rect
    [self drawInRect:outputRect];
    
    // create new image from bitmap context
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up
    UIGraphicsEndImageContext();
    
    // pass back new image
    return outImage;
}

@end
