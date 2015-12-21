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

#import "MDKLocalizedString.h"

@implementation MDKLocalizedString

+(NSString *)localizableStringFromKey:(NSString *)key {
    NSString *string = [MDKLocalizedString localizableStringFromKey:key inTable:@"Localizable-project"];
    
    if ([string isEqualToString:key]) {
        string = [MDKLocalizedString localizableStringFromKey:key inTable:@"Localizable-framework"];
    }
    
    if ([string isEqualToString:key]) {
        string = [MDKLocalizedString localizableStringFromKey:key inTable:@"Localizable"];
    }
    return string;
}

+(NSString *)localizableStringFromKey:(NSString *)key forClass:(Class)aClass{
    NSString *string = [MDKLocalizedString localizableStringFromKey:key inTable:@"Localizable" forClass:aClass];
    return string;
}

+(NSString *)localizableStringFromKey:(NSString *)key inTable:(NSString *)table{
    NSString *string = NSLocalizedStringFromTableInBundle(key, table, [NSBundle bundleForClass:NSClassFromString(@"AppDelegate")], "");
    
    if ([string isEqualToString:key]) {
        string = NSLocalizedStringFromTableInBundle(key, table, [NSBundle bundleForClass:NSClassFromString(@"MDKLocalizedString")], "");
    }
    if ([string isEqualToString:key]) {
        string = NSLocalizedString(key, "");
    }
    if ([string isEqualToString:key]) {
        string = key;
    }
    return string;
}

+(NSString *)localizableStringFromKey:(NSString *)key inTable:(NSString *)table forClass:(Class)aClass{
    NSString *string = NSLocalizedStringFromTableInBundle(key, table, [NSBundle bundleForClass:aClass], "");
    
    if ([string isEqualToString:key]) {
        string = NSLocalizedStringFromTableInBundle(key, table, [NSBundle bundleForClass:NSClassFromString(@"AppDelegate")], "");
    }
    if ([string isEqualToString:key]) {
        string = NSLocalizedStringFromTableInBundle(key, table, [NSBundle bundleForClass:NSClassFromString(@"MDKLocalizedString")], "");
    }
    if ([string isEqualToString:key]) {
        string = NSLocalizedString(key, "");
    }
    if ([string isEqualToString:key]) {
        string = key;
    }
    return string;
}



@end
