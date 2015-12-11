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

#import "MDKMessageInfo.h"

@interface MDKMessageInfo ()

/*!
 Displayed field name : field name displayed to user.
 */
@property(nonatomic, strong, readonly) NSString *localizedFieldName;

/*!
 Technical field name: name used by system to workwith the field.
 */
@property(nonatomic, strong, readonly) NSString *technicalFieldName;

/*!
 Title : the title of the message
 */
@property(nonatomic, strong, readonly) NSString *title;

/*!
 Content : the content of the message
 */
@property(nonatomic, strong, readonly) NSString *content;

@end

@implementation MDKMessageInfo
@synthesize status = _status;
@synthesize identifier = _identifier;

-(instancetype)initWithDescriptionKey:(NSString *) descriptionKey withLocalizedFieldName:(NSString *)fieldName technicalFieldName:(NSString *) technicalFieldName withTitle:(NSString *)title withObject:(id)object {
    self = [super init];
    if(self) {
        NSString *infoFormat= NSLocalizedStringFromTableInBundle(descriptionKey, @"mdk_messages", [NSBundle bundleForClass:NSClassFromString(@"MDKMessageInfo")], @"");
        NSString *infoContent = [NSString stringWithFormat:infoFormat, object];
        _localizedFieldName = fieldName;
        _technicalFieldName = technicalFieldName;
        _title = title;
        _content = infoContent;
    }
    return self;
}

-(NSString *)messageTitle {
    return _title ? _title : @"INFO";
}

-(NSString *)messageContent {
    return _content;
}

-(MDKMessageStatus)status {
    return  MDKMessageStatusInfo;
}
@end
