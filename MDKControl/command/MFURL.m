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


#import "MFURL.h"

@interface MFURL ()

@property(nonatomic, strong) NSURL *url;

@end

@implementation MFURL

static NSString *const SCHEME_BUNDLE = @"bundle";

static NSString *const MAIN_BUNDLE = @"main";

#pragma mark - NSURL category properties

/* The following methods work on the path portion of a URL in the same manner that the NSPathUtilities methods on NSString do.
 */
- (NSArray *)pathComponents
{
    return self.url.pathComponents;
}

- (NSString *)lastPathComponent
{
    return self.url.lastPathComponent;
}

- (NSString *)pathExtension
{
    return self.url.pathExtension;
}


#pragma mark - NSURL properties

- (NSString *)absoluteString
{
    return self.url.absoluteString;
}

- (NSString *)relativeString
{
    return self.url.relativeString;
}

- (NSURL *)baseURL
{
    return self.url.baseURL;
}

- (NSURL *)absoluteURL
{
    return self.url.absoluteURL;
}

/* Any URL is composed of these two basic pieces.  The full URL would be the concatenation of [myURL scheme], ':', [myURL resourceSpecifier]
 */
- (NSString *)scheme
{
    return self.url.scheme;
}

- (NSString *)resourceSpecifier
{
    return self.url.resourceSpecifier;
}

/* If the URL conforms to rfc 1808 (the most common form of URL), the following accessors will return the various components; otherwise they return nil.  The litmus test for conformance is as recommended in RFC 1808 - whether the first two characters of resourceSpecifier is @"//".  In all cases, they return the component's value after resolving the receiver against its base URL.
 */
- (NSString *)host
{
    return self.url.host;
}

- (NSNumber *)port
{
    return self.url.port;
}

- (NSString *)user
{
    return self.url.user;
}

- (NSString *)password
{
    return self.url.password;
}

- (NSString *)path
{
    return self.url.path;
}

- (NSString *)fragment
{
    return self.url.fragment;
}

- (NSString *)parameterString
{
    return self.url.parameterString;
}

- (NSString *)query
{
    return self.url.query;
}

- (NSString *)relativePath
{
    return self.url.relativePath;
}

- (BOOL)isFileURL
{
    return self.url.isFileURL;
}

- (NSURL *)standardizedURL
{
    return self.url.standardizedURL;
}

#pragma mark - MFURL specific functionalities 

-(BOOL) isBundleURL
{
    return [[self.scheme lowercaseString] isEqualToString:SCHEME_BUNDLE] || [self isOnlyFileName];
}

-(BOOL) isMainBundleURL
{
    // It's a bundle and its form is like : bundle://main/filename.extension
    return ([self isBundleURL] && [MAIN_BUNDLE isEqualToString:[self.host lowercaseString]]) || [self isOnlyFileName];
}

-(BOOL) isOnlyFileName
{
    return ([self.url.path rangeOfString:@"/"].length == 0) /* No / */
    && ([self.url.path rangeOfString:@"\\"].length == 0) /* No / */
    && ([self.url.path rangeOfString:@"."].length == 1); /* Only one point for extension */
}

- initWithString:(NSString *)URLString
{
    self = [super init];
    if(self)
    {
        self.url = [[NSURL alloc] initWithString:URLString];
    }
    return self;
}

+ (id)URLWithString:(NSString *)URLString
{
    MFURL *mfUrl = [[MFURL alloc] init];
    mfUrl.url = [[NSURL alloc] initWithString:URLString];
    return mfUrl;
}

- (NSString *)absoluteFileSystemStringIfPossible
{
    NSString *tempPath = nil;
    if([self isBundleURL] && self.url.path)
    {
        if([self isMainBundleURL])
        {
            NSArray *components = @[[[NSBundle mainBundle] bundlePath], self.url.path];
            if([self isOnlyFileName])
            {
                tempPath = [components componentsJoinedByString:@"/"];
            }
            else
            {
                tempPath = [components componentsJoinedByString:@""];
            }
        }
        else
        {
            @throw [NSException exceptionWithName:@"UnmanagedBundle" reason:@"MFURL ony supports main bundle" userInfo:nil];
        }
    }
    else
    {
        tempPath = self.url.absoluteString;
    }
    return tempPath;
}


@end
