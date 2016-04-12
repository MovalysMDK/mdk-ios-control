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

#import "MDKUIWebView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Helper.h"
#import "AlertView.h"



#pragma mark - MDKUIWebView - Private interface

@interface MDKUIWebView() <UIWebViewDelegate>

/*!
 * @brief Allow to wait while the loading website
 */
@property (nonatomic, strong) MBProgressHUD *hud;

@end


#pragma mark - MDKUIWebView - Implementation

@implementation MDKUIWebView
@synthesize targetDescriptors = _targetDescriptors;


#pragma mark - Initialization and deallocation

- (void)initialize {
    [super initialize];
}

- (void)didInitializeOutlets {}


#pragma mark - Tags for automatic testing

- (void) setAllTags {
    if (self.webView.tag == 0) {
        self.webView.tag = TAG_MDKWEBVIEW_WEBVIEW;
    }
}


#pragma mark MDKControlChangesProtocol implementation

- (void)valueChanged:(UIView *)sender {
    NSLog(@"Value changed: %@", sender);
}


#pragma mark - Live Rendering

- (void)prepareForInterfaceBuilder {
    UILabel *innerDescriptionLabel = [[UILabel alloc] initWithFrame:self.bounds];
    innerDescriptionLabel.text = [[self class] description];
    innerDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    innerDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    [self addSubview:innerDescriptionLabel];
    self.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.34f alpha:0.5f];
    
}


#pragma mark - Control attribute

- (void)setControlAttributes:(NSDictionary *)controlAttributes {
    if (controlAttributes && [controlAttributes objectForKey:@"localUrl"]) {
        [self setData:[controlAttributes objectForKey:@"localUrl"]];
    }
}


#pragma mark - Control Data protocol

+ (NSString *)getDataType {
    return @"NSURL";
}

- (void)setData:(id)data {
    if ( data && ![data isEqual:self.controlData]) {
        [self displayData];
    }
    [super setData:data];
}

- (id)getData {
    return self.controlData;
}

- (void)setEditable:(NSNumber *)editable {
    [super setEditable:editable];
}

- (void)setDisplayComponentValue:(id)value {}


#pragma mark - UIWebViewDelegate implementation

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.hud            = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    self.hud.mode       = MBProgressHUDModeIndeterminate;
    self.hud.labelText  = MDKLocalizedStringFromTable(@"mdk_control_loading_message", @"mdk_ui", @"");
    self.hud.removeFromSuperViewOnHide = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self.hud hide:YES];
    
    MDKUIAlertController *alertController = [MDKUIAlertController alertControllerWithTitle:MDKLocalizedStringFromTable(@"mdk_control_error_title", @"mdk_ui", @"") message:MDKLocalizedStringFromTable(@"mdk_control_cannot_load_website", @"mdk_ui", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:MDKLocalizedStringFromTable(@"mdk_general_ok_button", @"mdk_ui", @"") style:UIAlertActionStyleCancel handler:NULL];
    [alertController addAction:alertAction];
    
    if(error) {
        NSLog(@"ERROR : %@", error);
    }
    
    [self.parentViewController presentViewController:alertController animated:true completion:NULL];
}


#pragma mark - Private API

- (void)displayData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLoadUrl:(NSURL *)self.controlData];
    });
}

- (void)startLoadUrl:(NSURL *)url {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

-(UIWebView *)webView {
    if([self conformsToProtocol:@protocol(MDKExternalComponent)]) {
        return ((MDKUIExternalWebView *)self.internalView).webView;
    }
    else {
        return _webView;
    }
}


@end


/******************************************************/
/* INTERNAL/EXTERNAL                                  */
/******************************************************/

@implementation MDKUIExternalWebView

- (NSString *)defaultXIBName {
    return @"MDKUIWebView";
}

@end

@implementation MDKUIInternalWebView @end
