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
#import "MDKValidationError.h"

@interface MDKValidationError ()

@property(nonatomic, strong) NSString *localizedFieldName;

@property(nonatomic, strong) NSString *technicalFieldName;

@end

@implementation MDKValidationError


/*!
 * @brief Designated initializer.
 * @param code Error unique code.
 * @param dict may be nil if no userInfo desired.
 */
- (id)initWithCode:(NSInteger)code userInfo:(NSDictionary *)dict localizedFieldName: (NSString *) fieldName
technicalFieldName:(NSString *)technicalFieldName
{
    self = [super initWithDomain:fieldName code:code userInfo:dict];
    if(self)
    {
        self.localizedFieldName = fieldName;
        self.technicalFieldName = technicalFieldName;
        NSLog(@"Error domain : %@ - code : %ld - localizedFieldName : %@ - technicalFieldName : %@",fieldName, (long)self.code, self.localizedFieldName, self.technicalFieldName);
    }
    
    return self;
}

/*!
 * @brief Designated initializer.
 * @param code Error unique code.
 * @param descriptionKey complete sentence which describes why the operation failed.
 * In many cases this will be just the "because" part of the error message (but as a complete sentence, 
 * which makes localization easier).
 * @param failureReasonKey The string that can be displayed as the "informative" (aka "secondary") message on an alert panel
 */
- (id)initWithCode:(NSInteger)code localizedDescriptionKey:(NSString *)descriptionKey
localizedFailureReasonErrorKey:(NSString *) failureReasonKey localizedFieldName: (NSString *) fieldName technicalFieldName:(NSString *)technicalFieldName
{
    self = [super initWithDomain:fieldName code:code userInfo:@{NSLocalizedDescriptionKey:MDKLocalizedStringFromTable(descriptionKey, @"mdk_messages", @"")}];
    if(self)
    {
        self.localizedFieldName = fieldName;
        self.technicalFieldName = technicalFieldName;
        NSLog(@"Error domain : %@ - code : %ld - localizedFieldName : %@ - technicalFieldName : %@", descriptionKey, (long)self.code, self.localizedFieldName, self.technicalFieldName);
    }
    return self;
}

/*!
 * Designated initializer.
 * @param code Error unique code.
 * @param descriptionKey complete sentence which describes why the operation failed.
 * In many cases this will be just the "because" part of the error message (but as a complete sentence,
 * which makes localization easier).
 */
- (id)initWithCode:(NSInteger)code localizedDescriptionKey:(NSString *)descriptionKey
localizedFieldName: (NSString *) fieldName technicalFieldName:(NSString *)technicalFieldName{
    self = [super initWithDomain:fieldName code:code userInfo:@{NSLocalizedDescriptionKey:MDKLocalizedStringFromTable(descriptionKey, @"mdk_messages", @"")}];
    if(self)
    {
        self.localizedFieldName = fieldName;
        self.technicalFieldName = technicalFieldName;
        NSLog(@"Error domain : %@ - code : %ld - localizedFieldName : %@ - technicalFieldName : %@", descriptionKey, (long)self.code, self.localizedFieldName, self.technicalFieldName);
    }
    return self;
}

/*!
 * Designated initializer.
 * @param code Error unique code.
 * @param descriptionKey complete sentence which describes why the operation failed.
 * In many cases this will be just the "because" part of the error message (but as a complete sentence,
 * which makes localization easier).
 */
- (id)initWithCode:(NSInteger)code localizedDescriptionKey:(NSString *)descriptionKey
localizedFieldName: (NSString *) fieldName technicalFieldName:(NSString *)technicalFieldName withObject:(id)object {
    NSString *errorFormat= MDKLocalizedStringFromTable(descriptionKey, @"mdk_messages", @"");
    NSString *errorContent = [NSString stringWithFormat:errorFormat, object];
                                                              
    self = [super initWithDomain:fieldName code:code userInfo:@{NSLocalizedDescriptionKey :errorContent}];
    if(self)
    {
        self.localizedFieldName = fieldName;
        self.technicalFieldName = technicalFieldName;
        NSLog(@"Error domain : %@ - code : %ld - localizedFieldName : %@ - technicalFieldName : %@", descriptionKey, (long)self.code, self.localizedFieldName, self.technicalFieldName);
    }
    return self;
}


/*!
 * @brief Designated initializer. dict may be nil if no userInfo desired.
 */
+ (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict localizedFieldName: (NSString *) fieldName
 technicalFieldName:(NSString *)technicalFieldName{
    return [[MDKValidationError alloc] initWithCode:code userInfo:dict localizedFieldName:fieldName technicalFieldName:technicalFieldName];
}

#pragma mark - MDKMessageProtocol

-(NSString *)messageContent {
    return [self localizedDescription];
}

-(NSString *)messageTitle {
    return @"ERROR";
}

-(NSInteger)messagerCode {
    return [self code];
}

-(MDKMessageStatus)status {
    return MDKMessageStatusError;
}
@end
