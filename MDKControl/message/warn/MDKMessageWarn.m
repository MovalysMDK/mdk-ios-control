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

#import "Utils.h"
#import "MDKMessageWarn.h"

@interface MDKMessageWarn ()

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

@implementation MDKMessageWarn

@synthesize status = _status;

-(instancetype)initWithDescriptionKey:(NSString *) descriptionKey withLocalizedFieldName:(NSString *)fieldName technicalFieldName:(NSString *) technicalFieldName withTitle:(NSString *)title withObject:(id)object {
    self = [super init];
    if(self) {
        NSString *warnFormat = MDKLocalizedStringFromTable(descriptionKey, @"mdk_messages", @"");
        NSString *warnContent = [NSString stringWithFormat:warnFormat, object];
        _localizedFieldName = fieldName;
        _technicalFieldName = technicalFieldName;
        _title = title;
        _content = warnContent;
        _status = MDKMessageStatusWarning;
    }
    return self;
}

-(NSString *)messageTitle {
    return _title ? _title : @"WARN";
}

-(NSString *)messageContent {
    return _content;
}
@end
