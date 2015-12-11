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

#import "Message.h"
#import "MDKMessageButton.h"
#import "MDKAbstractStyle_MDK.h"

@implementation MDKMessageButton
@synthesize color = _color;

#pragma mark - Initialization

-(instancetype)init {
    self = [super init];
    if(self) {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithColor:(UIColor *)color {
    self = [super init];
    if(self) {
        self.color = color;
        [self initialize];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialize];
    }
    return self;
}
-(void) initialize {
    self.titleLabel.font = [UIFont systemFontOfSize:10.0f weight:3.0f];
}

#pragma mark - Desgin
-(void)drawRect:(CGRect)rect {
    self.clipsToBounds = NO;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents([[self color] CGColor]));
    CGContextFillPath(ctx);
    
    [self.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.layer setShadowOpacity:0.4];
    [self.layer setShadowRadius:2.0];
    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
}

-(UIColor *)color {
    if(!_color) {
        return [UIColor redColor];
    }
    return _color;
}

-(void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

@end
