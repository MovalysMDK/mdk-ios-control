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
#import "MDKSignaturePopupView.h"


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
@property (nonatomic, strong) MDKSignaturePopupView *signaturePopupView;

@end




@implementation MDKUISignature
@synthesize targetDescriptors = _targetDescriptors;
@synthesize signaturePath = _signaturePath;

#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
}

-(void)didInitializeOutlets {
    [super didInitializeOutlets];
    self.signatureView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.signatureView.layer.cornerRadius = 10.0f;
    self.signatureView.clipsToBounds = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.signatureView.signature = self;
}



#pragma mark - Drawing



- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                              SIGNATURE_DRAWING_WIDTH, SIGNATURE_DRAWING_HEIGHT);
    [self setFrame:frame];
    
    self.signatureView.frame = self.frame;
    [self setNeedsDisplay];
}


#pragma mark - Control Data Protocol

+(NSString *)getDataType {
    return @"NSString";
}

-(void)setData:(id)data {
    [super setData:data];
    self.signaturePath = [MDKSignatureHelper convertFromStringToLines:data width:self.bounds.size.width originX:0 originY:0];
}

-(id)getData {
    return self.controlData;
}

-(void)setDisplayComponentValue:(NSString *)value {
    [self.signatureView setNeedsDisplay];
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

-(NSMutableArray *) signaturePath {
    return _signaturePath;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([self.editable isEqualToNumber:@1]) {
        self.signatureView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.signatureView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([self.editable isEqualToNumber:@1]) {
        self.signatureView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.signatureView performSelector:@selector(setBackgroundColor:) withObject:[UIColor colorWithWhite:0.9f alpha:1.0f] afterDelay:0.15f];
    
    
    NSString *xibIdentifier = @"MDK_MDKUISignaturePopup";
    self.signaturePopupView = [[[NSBundle bundleForClass:[MDKSignaturePopupView class]] loadNibNamed:xibIdentifier owner:self options:nil] firstObject];
    self.signaturePopupView.translatesAutoresizingMaskIntoConstraints = NO;
    self.signaturePopupView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
    self.signaturePopupView.signatureDrawing.signaturePath = [self.signaturePath mutableCopy];
    
    self.signaturePopupView.translatesAutoresizingMaskIntoConstraints = NO;
    self.signaturePopupView.sourceControl = self;
    [[UITableView appearanceWhenContainedIn:self.parentViewController.view.superview.class, nil] setBackgroundColor:UIColor.clearColor];
    [[UITableView appearanceWhenContainedIn:self.parentViewController.view.superview.class, nil] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.parentViewController.view addSubview:self.signaturePopupView];
    
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.signaturePopupView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.parentViewController.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.signaturePopupView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.parentViewController.view  attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.signaturePopupView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.parentViewController.view  attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.signaturePopupView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.parentViewController.view  attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.parentViewController.view addConstraints:@[right, left, bottom, top]];
    
    // Perform animation
    CGRect finalFrame = self.signaturePopupView.frame;
    CGRect startFrame = CGRectMake(finalFrame.origin.x, finalFrame.size.height, finalFrame.size.width, finalFrame.size.height);
    self.signaturePopupView.frame = startFrame;
    
    // Animation
    [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:10.0f initialSpringVelocity:18.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.signaturePopupView.frame = finalFrame;
    } completion:NULL];
    
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
