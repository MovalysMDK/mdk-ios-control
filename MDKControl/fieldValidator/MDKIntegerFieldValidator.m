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

#import "MessageError.h"

#import "MDKIntegerFieldValidator.h"

NSString *FIELD_VALIDATOR_MIN_DIGITS = @"minDigits";
NSString *FIELD_VALIDATOR_MAX_DIGITS = @"maxDigits";

@implementation MDKIntegerFieldValidator

+(instancetype)sharedInstance{
    static MDKIntegerFieldValidator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(NSArray *)recognizedAttributes {
    return @[FIELD_VALIDATOR_MIN_DIGITS,
             FIELD_VALIDATOR_MAX_DIGITS];
}

-(MDKInvalidIntegerValueUIValidationError *)validate:(id)value withCurrentState:(NSDictionary *)currentState withParameters:(NSDictionary *)parameters {
    MDKInvalidIntegerValueUIValidationError *result = nil;
    if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSAttributedString class]] ) {
        if(![self matchPattern:value withParameters:parameters]) {
            result = [[MDKInvalidIntegerValueUIValidationError alloc]  initWithLocalizedFieldName:parameters[@"componentName"] technicalFieldName:parameters[@"componentName"]];
        }
    }
    return result;
}

-(BOOL)canValidControl:(UIView *)control {
    BOOL canValid = YES;
    canValid = canValid && [control isKindOfClass:NSClassFromString(@"UITextField")];
    return canValid;
}

-(BOOL)isBlocking {
    return NO;
}

-(BOOL) matchPattern:(NSString *)checkString withParameters:(NSDictionary *)parameters {
    NSString *stringToMatch = checkString;
    if([checkString isKindOfClass:[NSAttributedString class]]) {
        stringToMatch = [(NSAttributedString *)checkString string];
    }
    NSString *regex = [self createPatternFromParameters:parameters];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:stringToMatch];
}

- (NSString *) createPatternFromParameters:(NSDictionary *)parameters {
    //Construction de la regex de vérification en fonction des propriétés du PLIST
    NSString *quantificateurPartieEntiere;
    
    //Génération des quantificateurs
    
    //Si un nombre minimum de chiffres pour la partie entière est spécifié (et différent de zéro)
    if (parameters[FIELD_VALIDATOR_MIN_DIGITS] != nil
        && [parameters[FIELD_VALIDATOR_MIN_DIGITS] intValue] != 0) {
        quantificateurPartieEntiere = [NSString stringWithFormat:@"%@,", parameters[FIELD_VALIDATOR_MIN_DIGITS]];
        //Autrement, il faudra saisir au moins un chiffre
    } else {
        quantificateurPartieEntiere = [NSString stringWithFormat:@"1,"];
    }
    
    //Si un nombre maximum de chiffres pour la partie entière est spécifié (et différent de zéro) et qu'il est
    //supérieur au nombre minimum
    if (parameters[FIELD_VALIDATOR_MAX_DIGITS] != nil
        && [parameters[FIELD_VALIDATOR_MAX_DIGITS] intValue] != 0 && [parameters[FIELD_VALIDATOR_MAX_DIGITS] intValue] >= [parameters[FIELD_VALIDATOR_MIN_DIGITS] intValue]) {
        quantificateurPartieEntiere = [NSString stringWithFormat:@"%@%@", quantificateurPartieEntiere, parameters[FIELD_VALIDATOR_MAX_DIGITS]];
    }
    
    //Génération de la regex de vérification
    return [NSString stringWithFormat:@"^-?[0-9]{%@}$", quantificateurPartieEntiere];
}

@end
