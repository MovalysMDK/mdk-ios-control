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


#pragma mark - MDKUIWebViewKey - Keys

/*!
 * @brief The key for MDKUIWebViewKey allowing to add control attributes
 */
NSString *const MDKUIWebViewKey = @"MDKUIWebViewKey";


#pragma mark - MDKUIWebView - Private interface

@interface MDKUIWebView() <UIWebViewDelegate>

/*!
 * @brief The private current data allow to know if the update is necessary
 */
@property (nonatomic, strong) id currentData;

/*!
 * @brief This variable allow to know the current enum class name
 */
@property (nonatomic, strong) NSString *currentEnumClassName;

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


#pragma mark - Control attribute

- (void)setControlAttributes:(NSDictionary *)controlAttributes {
    if (controlAttributes && [controlAttributes objectForKey:MDKUIWebViewKey]) {
        self.currentEnumClassName = [controlAttributes valueForKey:MDKUIWebViewKey];
    }
}


#pragma mark - Control Data protocol

+ (NSString *)getDataType {
    return @"NSURL";
}

- (void)setData:(id)data {
    if ( data && ![data isEqual:self.currentData]) {
        self.currentData = data;
        [self displayData];
    }
    [super setData:data];
}

- (id)getData {
    return self.currentData;
}

- (void)setEditable:(NSNumber *)editable {
    [super setEditable:editable];
}

- (void)setDisplayComponentValue:(id)value {}


#pragma mark - UIWebViewDelegate implementation

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.hud            = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    self.hud.mode       = MBProgressHUDModeIndeterminate;
    self.hud.labelText  = @"Loading...";
    self.hud.removeFromSuperViewOnHide = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self.hud hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Oopps, we cannot load your website ..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - Private API

- (void)displayData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLoadUrl:(NSURL *)self.currentData];
    });
}

- (void)startLoadUrl:(NSURL *)url {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
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
