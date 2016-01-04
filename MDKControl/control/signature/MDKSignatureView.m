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

#import "MDKSignatureView.h"
#import "MDKUISignature.h"
#import "MDKSignatureDrawing.h"


@implementation MDKSignatureView

-(void)drawRect:(CGRect)rect {
    // Get graphic context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Configure stroke style
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetLineCap(context , kCGLineCapRound);
    
    // Draw lines
    for (NSValue *nsLine in [self.signature signaturePath]) {
        struct MDKLine couple;
        [nsLine getValue:&couple];
        [self drawLineFrom:couple.from to:couple.to context:context];
    }
    CGContextStrokePath(context);
}

- (void) drawLineFrom:(CGPoint)from to:(CGPoint)to context:(CGContextRef) context {
    CGContextMoveToPoint(context, from.x, from.y);  // Start at this point
    CGContextAddLineToPoint(context, to.x, to.y);   // Draw to this point
}

@end
