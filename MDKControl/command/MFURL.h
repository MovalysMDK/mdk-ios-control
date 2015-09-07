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


/*!
 * Equivalent to NSURL but extended for framework use.
 * This class use new schemes:
 * - bundle://[bundle name]/resource_path
 * - Other standard scheme managed by NSURL
 *
 * Today, only main bundle is managed by this class.
 */
@interface MFURL : NSObject

#pragma mark - NSURL category properties

/* The following methods work on the path portion of a URL in the same manner that the NSPathUtilities methods on NSString do.
 */
- (NSArray *)pathComponents NS_AVAILABLE(10_6, 4_0);
- (NSString *)lastPathComponent NS_AVAILABLE(10_6, 4_0);
- (NSString *)pathExtension NS_AVAILABLE(10_6, 4_0);


#pragma mark - NSURL properties

- (NSString *)absoluteString;
- (NSString *)relativeString; // The relative portion of a URL.  If baseURL is nil, or if the receiver is itself absolute, this is the same as absoluteString
- (NSURL *)baseURL; // may be nil.
- (NSURL *)absoluteURL; // if the receiver is itself absolute, this will return self.

/* Any URL is composed of these two basic pieces.  The full URL would be the concatenation of [myURL scheme], ':', [myURL resourceSpecifier]
 */
- (NSString *)scheme;
- (NSString *)resourceSpecifier;

/* If the URL conforms to rfc 1808 (the most common form of URL), the following accessors will return the various components; otherwise they return nil.  The litmus test for conformance is as recommended in RFC 1808 - whether the first two characters of resourceSpecifier is @"//".  In all cases, they return the component's value after resolving the receiver against its base URL.
 */
- (NSString *)host;
- (NSNumber *)port;
- (NSString *)user;
- (NSString *)password;
- (NSString *)path;
- (NSString *)fragment;
- (NSString *)parameterString;
- (NSString *)query;
- (NSString *)relativePath; // The same as path if baseURL is nil

- (BOOL)isFileURL; // Whether the scheme is file:; if [myURL isFileURL] is YES, then [myURL path] is suitable for input into NSFileManager or NSPathUtilities.

- (NSURL *)standardizedURL;

#pragma mark - MFURL specific elements

/*!
 * Whether the scheme is bundle: if [myURL isBundleURL] is YES, then [myURL path] is suitable for input into NSFileManager or NSPathUtilities.
 *
 */
-(BOOL) isBundleURL;

/*!
 * YES if URL references a main bundle element.
 */
-(BOOL) isMainBundleURL;

/*!
 * Indicate if this instance only constains a file name.
 */
-(BOOL) isOnlyFileName;

- initWithString:(NSString *)URLString;

+ (id)URLWithString:(NSString *)URLString;

/*!
 * Return the file system management path if possible.
 * If not possible return nil.
 */
- (NSString *)absoluteFileSystemStringIfPossible;

@end
