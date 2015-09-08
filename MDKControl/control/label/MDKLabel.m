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

#import "MDKLabel.h"
#import "MDKLabelStyle.h"
#import "MDKControlProtocol.h"
//#import "MFUIError.h"
//#import "MFConfigurationHandler.h"
//#import "MFLocalizedString.h"


@interface MDKLabel ()


/**
 * @brief Cette propriété permet de personnaliser le texte de la mension "obligatoire"
 */
@property (nonatomic, strong) NSString *mandatoryIndicator;

@end

@implementation MDKLabel
@synthesize styleClass = _styleClass;
@synthesize componentInCellAtIndexPath = _componentInCellAtIndexPath;

@synthesize localizedFieldDisplayName = _localizedFieldDisplayName;

@synthesize inInitMode = _inInitMode;
@synthesize controlDelegate = _controlDelegate;
@synthesize isValid = _isValid;
@synthesize mandatory = _mandatory;
@synthesize visible = _visible;
@synthesize editable = _editable;
@synthesize tooltipView= _tooltipView;
@synthesize styleClassName = styleClassName;
@synthesize controlAttributes = _controlAttributes;
@synthesize associatedLabel = _associatedLabel;
@synthesize lastUpdateSender = _lastUpdateSender;
@synthesize componentValidation = _componentValidation;
@synthesize privateData = _privateData;

NSString * const MF_MANDATORY_INDICATOR = @"MandatoryIndicator";

#pragma mark - Initialization
-(instancetype)init {
    self = [super init];
    if(self) {
        [self initializeComponent];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initializeComponent];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initializeComponent];
    }
    return self;
}

-(void) initializeComponent {
    self.controlDelegate = [[MDKControlDelegate alloc] initWithControl:self];
//    [self.baseStyleClass applyStandardStyleOnComponent:self];
    self.errors = [NSMutableArray new];
    if(!self.sender) {
        self.sender = self;
    }
    
#if !TARGET_INTERFACE_BUILDER
//    MFConfigurationHandler *registry = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
//    self.mandatoryIndicator = [registry getStringProperty:MF_MANDATORY_INDICATOR];
#endif
}


-(void)setIsValid:(BOOL) isValid {
    [self.controlDelegate setIsValid:isValid];
}


#pragma mark - MDK

-(void)setCustomStyleClass:(Class)customStyleClass {
    _customStyleClass = customStyleClass;
    self.styleClass = [customStyleClass new];
}

- (void)setI18nKey:(NSString *) defaultValue {
    [self setData:defaultValue];
}

+(NSString *)getDataType {
    return @"NSString";
}


-(void)setData:(id)data {
    NSString *fixedData = nil;
    if(data && ![data isKindOfClass:NSClassFromString(@"MFKeyNotFound")]) {
        fixedData = data;
    }
    else {
        NSString *defaultValue = NSStringFromClass(self.class);
        //PROTODO : Valeur par défaut i18n
        fixedData = defaultValue;
    }
    fixedData = [self insertOrRemoveMandatoryIndicator:fixedData];
    [self setDisplayComponentValue:fixedData];
}

-(id)getData {
    return [self displayComponentValue];
}

-(NSString *)displayComponentValue {
    return self.text;
}

-(void)setDisplayComponentValue:(id)value {
    if([value isKindOfClass:[NSString class]]) {
        self.text = value;
    }
    else if([value isKindOfClass:[NSAttributedString class]]){
        self.attributedText = value;
    }
}

//-(NSInteger)validateWithParameters:(NSDictionary *)parameters {
//    
//    [self.errors removeAllObjects];
//    if(parameters) {
//        // Do some treatments with specific
//    }
//    NSInteger length = [[self displayComponentValue] length];
//    NSError *error = nil;
//    // Control's errros init or reinit
//    NSInteger nbOfErrors = 0;
//    
//
//    
//    return nbOfErrors;
//    
//}

-(void)setEditable:(NSNumber *)editable {
    _editable = editable;
    self.userInteractionEnabled = [editable boolValue];
}

-(NSString *) insertOrRemoveMandatoryIndicator:(NSString *)data {
    NSString *fixedString = data;
    if([self.mandatory isEqual: @1] && [data rangeOfString:self.mandatoryIndicator].location == NSNotFound) {
        fixedString = [data stringByAppendingString:[NSString stringWithFormat:@" %@",self.mandatoryIndicator]];
    }
    else if ([self.mandatory isEqual: @0] && [self  .text rangeOfString:self.mandatoryIndicator].location != NSNotFound ) {
        fixedString = [data stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@",self.mandatoryIndicator] withString:@""];
    }
    return fixedString;
}



#pragma mark - Forwarding to binding delegate


-(BOOL) isValid {
    return ([self validate] == 0);
}

-(NSArray *)getErrors {
    return [self.controlDelegate getErrors];
}

-(void)addErrors:(NSArray *)errors {
    [self.controlDelegate addErrors:errors];
}

-(void)clearErrors {
    [self.controlDelegate clearErrors];
}

-(void)showError:(BOOL)showError {
    [self.controlDelegate setIsValid:!showError];
}

-(void)prepareForInterfaceBuilder {
    [self.styleClass applyStandardStyleOnComponent:self];
    
    if(self.onError_MDK) {
        [self.styleClass applyErrorStyleOnComponent:self];
    }
    else {
        [self.styleClass applyValidStyleOnComponent:self];
    }
    self.text = @"Label";
//    self.backgroundColor = [UIColor clearColor];
}

-(void)setMandatory:(NSNumber *)mandatory {
    _mandatory = mandatory;
    [self postInvalidate];
}

-(void) postInvalidate {
    [self setData:[self getData]];
}

-(void)setVisible:(NSNumber *)visible {
    _visible = visible;
    [self.controlDelegate setVisible:visible];
}

-(void)addControlAttribute:(id)controlAttribute forKey:(NSString *)key {
    [self.controlDelegate addControlAttribute:controlAttribute forKey:key];
}

-(void)onErrorButtonClick:(id)sender {
    [self.controlDelegate onErrorButtonClick:sender];
}

-(NSInteger)validate {
    return [self.controlDelegate validate];
}

-(NSArray *)controlValidators {
    return  @[];
}

-(void)addAccessories:(NSDictionary *)accessoryViews {
    //nothing
}
@end
