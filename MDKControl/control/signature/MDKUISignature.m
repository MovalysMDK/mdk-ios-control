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

#import "MDKUISignature.h"

#import "MDKSignatureHelper.h"
#import "MDKSignatureDrawing.h"


#define SIGNATURE_DRAWING_WIDTH 240
#define SIGNATURE_DRAWING_HEIGHT 160

@interface MDKUISignature ()

/*!
 * @brief An array describing the signature path
 */
@property(nonatomic, strong) NSMutableArray *signaturePath;

/*!
 * @brief The custom signature drawing object that allows the user to draw a signature
 */
@property (nonatomic, strong) MDKSignatureDrawing *signature;

@end




@implementation MDKUISignature
@synthesize targetDescriptors = _targetDescriptors;


#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
}

-(void)didInitializeOutlets {
    [super didInitializeOutlets];
    self.signatureView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    self.signatureView.layer.cornerRadius = 10.0f;
    self.signatureView.clipsToBounds = YES;
}



#pragma mark - Drawing


// Drawing has to be done here
- (void) drawRect:(CGRect)rect {
    
    // Get graphic context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Configure stroke style
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetLineCap(context , kCGLineCapRound);
    
    // Draw lines
    for (NSValue *nsLine in _signaturePath) {
        struct MDKLine couple;
        [nsLine getValue:&couple];
        [self drawLineFrom:couple.from to:couple.to context:context];
    }
    CGContextStrokePath(context);
}


- (void) drawLineFrom:(CGPoint)from to:(CGPoint)to context:(CGContextRef) context {
    CGContextMoveToPoint(context, from.x, from.y);  // Start at this point
    CGContextAddLineToPoint(context, to.x, to.y);   // Draw to this point
    [self.signatureView updateConstraints];
}


- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                              SIGNATURE_DRAWING_WIDTH, SIGNATURE_DRAWING_HEIGHT);
    
    [self setFrame:frame];
    
    [self setNeedsDisplay];
}


#pragma mark - Control Data Protocol

+(NSString *)getDataType {
    return @"NSString";
}

-(void)setData:(id)data {
    [super setData:data];
    
    self.signaturePath = [MDKSignatureHelper
                          convertFromStringToLines:data width:self.bounds.size.width originX:0 originY:0];
    [self setNeedsDisplay];
}

-(id)getData {
    return self.controlData;
}

-(void)setDisplayComponentValue:(NSNumber *)value {
}

-(id)displayComponentValue {
    return nil;
}



-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.signatureView.hash) : commonCCTD};
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void) valueChanged:(UIView *)sender {
    MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
    [cctd.target performSelector:cctd.action withObject:self];
}
#pragma clang diagnostic pop

-(void)prepareForInterfaceBuilder {
    UILabel *innerDescriptionLabel = [[UILabel alloc] initWithFrame:self.bounds];
    innerDescriptionLabel.text = [[self class] description];
    innerDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    innerDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    [self addSubview:innerDescriptionLabel];
    self.backgroundColor = [UIColor colorWithRed:0.6f green:0.7f blue:0.65f alpha:1.0f];
    
}

@end



/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalSignature
-(NSString *)defaultXIBName {
    return @"MDKUISignature";
}
@end

@implementation MDKUIInternalSignature
-(void)forwardOutlets:(MDKUIExternalSignature *)receiver {
    [receiver setSignatureView:self.signatureView];
}
@end
