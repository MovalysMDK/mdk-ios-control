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

#import "MDKUIScanner.h"

@interface MDKUIScanner ()

@property (nonatomic) BOOL hasInitializedScanner;

@end

@implementation MDKUIScanner
@synthesize targetDescriptors = _targetDescriptors;
@synthesize session = _session;
@synthesize device = _device;
@synthesize input = _input;
@synthesize output = _output;
@synthesize prevLayer = _prevLayer;
@synthesize highlightView = _highlightView;
@synthesize barCodeScannerDelegate = _barCodeScannerDelegate;
@synthesize mainView = _mainView;



#pragma mark - Initialization and deallocation

-(void)initialize {
    [super initialize];
    self.hasInitializedScanner = NO;
    
}

-(void)didInitializeOutlets {
    [super didInitializeOutlets];
    
    BOOL __strong scannerInitialized = self.hasInitializedScanner;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!scannerInitialized) {
            // Initializing MFBarCodeScannerDelegate
            self.barCodeScannerDelegate = [[MDKBarCodeScannerDelegate alloc] initWithSource:self];
            
            //Indicated what is the main view for MFBarCodeScannerDelegate
            self.mainView = self.scanView;
            
            //Initializing Scanner Camera Output
            [self.barCodeScannerDelegate initializeScanner];
            
            //Post initializing
            [self.barCodeScannerDelegate postInitialize];
            self.hasInitializedScanner = YES;
        }
    });
    
    
    
    self.scanView.layer.cornerRadius = 10.0f;
    self.label.layer.cornerRadius = 5.0f;
    self.label.clipsToBounds = YES;
    self.scanView.clipsToBounds = YES;
}


#pragma mark - Custom methods
-(void)doActionOnDetectionOfString:(NSString *)detectionString {
    [self setData:detectionString];
    [self valueChanged:self.scanView];
}

//#pragma mark - MFOrientationChangedProtocol forwarded methods
-(void)orientationDidChanged:(NSNotification *)notification {
    [self fixCaptureOrientation];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if(_prevLayer) {
        _prevLayer.frame =  self.bounds;
    }
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [self.barCodeScannerDelegate captureOutput:captureOutput didOutputMetadataObjects:metadataObjects fromConnection:connection];
}

#pragma mark - Custom methods
/**
 * @brief Method called after an orientation change. It adapts captureOutput to the new orientation
 */
-(void) fixCaptureOrientation {
    AVCaptureConnection *videoConnection = self.prevLayer.connection;
    if ([videoConnection isVideoOrientationSupported]) {
        if(UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
            [videoConnection setVideoOrientation:[self.barCodeScannerDelegate performSelector:@selector(videoOrientation)]];
        }
        if(self.prevLayer) {
            self.prevLayer.frame = self.mainView.bounds;
        }
    }
}


#pragma mark - Control Data Protocol

+(NSString *)getDataType {
    return @"NSString";
}

-(id)getData {
    return [self displayComponentValue];
}

-(void)setData:(id)data {
    if([data isKindOfClass:NSString.class]) {
        [super setData:data];
    }
}

-(void)setDisplayComponentValue:(NSString *)value {
    self.label.text = value;
}

-(id)displayComponentValue {
    return self.controlData;
}




#pragma mark - Control changes

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
    commonCCTD.target = target;
    commonCCTD.action = action;
    self.targetDescriptors = @{@(self.scanView.hash) : commonCCTD};
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void) valueChanged:(UIView *)sender {
    MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
    [cctd.target performSelector:cctd.action withObject:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:ASK_HIDE_KEYBOARD object:nil];
    [self validate];
}
#pragma clang diagnostic pop

@end



/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalScanner
-(NSString *)defaultXIBName {
    return @"MDKUIScanner";
}
@end

@implementation MDKUIInternalScanner
-(void)forwardOutlets:(MDKUIExternalScanner *)receiver {
    [receiver setLabel:self.label];
    [receiver setScanView:self.scanView];
}
@end
