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


@interface MDKLabel ()


/**
 * @brief Cette propriété permet de personnaliser le texte de la mension "obligatoire"
 */
@property (nonatomic, strong) NSString *mandatoryIndicator;

@end

@implementation MDKLabel

/******************************************************/
/* CONSTANTS                                          */
/******************************************************/


NSString * const MF_MANDATORY_INDICATOR = @"MandatoryIndicator";

/******************************************************/
/* SYNTHESIZE                                         */
/******************************************************/

#pragma mark - Synthesize
#pragma mark Style
@synthesize styleClass = _styleClass;
@synthesize customStyleClass = _customStyleClass;
@synthesize styleClassName = styleClassName;

#pragma mark Properties
@synthesize mandatory = _mandatory;
@synthesize visible = _visible;
@synthesize editable = _editable;

#pragma mark Validation
@synthesize isValid = _isValid;

#pragma mark Error
@synthesize tooltipView= _tooltipView;

#pragma mark AssociatedLabel
@synthesize associatedLabel = _associatedLabel;

#pragma mark Attributes
@synthesize controlAttributes = _controlAttributes;

#pragma mark Data
@synthesize privateData = _privateData;

#pragma mark Common
@synthesize inInitMode = _inInitMode;
@synthesize controlDelegate = _controlDelegate;
@synthesize lastUpdateSender = _lastUpdateSender;



/******************************************************/
/* IMPLEMENTATION                                     */
/******************************************************/

#pragma mark - Initialization and deallocation
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
#if !TARGET_INTERFACE_BUILDER

    self.controlDelegate = [[MDKControlDelegate alloc] initWithControl:self];
    self.errors = [NSMutableArray new];
    if(!self.sender) {
        self.sender = self;
    }

//    MFConfigurationHandler *registry = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
//    self.mandatoryIndicator = [registry getStringProperty:MF_MANDATORY_INDICATOR];
#endif

}


#pragma mark - Custom Methods
-(NSString *) insertOrRemoveMandatoryIndicator:(NSString *)data {
    NSString *fixedString = data;
    if([self.mandatory isEqual: @1] && [data rangeOfString:self.mandatoryIndicator].location == NSNotFound) {
        fixedString = [data stringByAppendingString:[NSString stringWithFormat:@" %@",self.mandatoryIndicator]];
    }
    else if ([self.mandatory isEqual: @0] && [self.text rangeOfString:self.mandatoryIndicator].location != NSNotFound ) {
        fixedString = [data stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@",self.mandatoryIndicator] withString:@""];
    }
    return fixedString;
}

-(NSString *)mandatoryIndicator {
    if(!_mandatoryIndicator) {
        _mandatoryIndicator = @"*";
    }
    return _mandatoryIndicator;
}

-(void) postInvalidate {
    [self setData:[self getData]];
}

- (void)setI18nKey:(NSString *) defaultValue {
    [self setData:defaultValue];
}

-(void)addAccessories:(NSDictionary *)accessoryViews {
    //Nothing to do by default
}


#pragma mark - Control Data Protocol
-(void)setData:(id)data {
    id fixedData = nil;
    if(data && ![data isKindOfClass:NSClassFromString(@"MFKeyNotFound")]) {
        fixedData = data;
    }
    else {
        NSString *defaultValue = NSStringFromClass(self.class);
        fixedData = defaultValue;
    }
    fixedData = [self insertOrRemoveMandatoryIndicator:fixedData];
    
    if([fixedData isKindOfClass:[NSString class]]) {
        self.text = fixedData;
    }
    else if([fixedData isKindOfClass:[NSAttributedString class]]){
        self.attributedText = fixedData;
    }
}

-(id)getData {
    return self.text;
}

+(NSString *)getDataType {
    return @"NSString";
}





#pragma mark - Validation
-(BOOL) isValid {
    return ([self validate] == 0);
}

-(void)setIsValid:(BOOL) isValid {
    [self.controlDelegate setIsValid:isValid];
}

-(NSInteger)validate {
    return [self.controlDelegate validate];
}

-(NSArray *)controlValidators {
    return  @[];
}



#pragma mark - Errors
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

-(void)onErrorButtonClick:(id)sender {
    [self.controlDelegate onErrorButtonClick:sender];
}



#pragma mark - Control Attributes
-(void)addControlAttribute:(id)controlAttribute forKey:(NSString *)key {
    [self.controlDelegate addControlAttribute:controlAttribute forKey:key];
}



#pragma mark - Control Properties Protocol
-(void)setEditable:(NSNumber *)editable {
    _editable = editable;
    self.userInteractionEnabled = [editable boolValue];
}

-(void)setMandatory:(NSNumber *)mandatory {
    _mandatory = mandatory;
    [self postInvalidate];
}

-(void)setVisible:(NSNumber *)visible {
    _visible = visible;
    [self.controlDelegate setVisible:visible];
}



#pragma mark - Style
-(void)setCustomStyleClass:(Class)customStyleClass {
    _customStyleClass = customStyleClass;
    [self.controlDelegate setCustomStyleClass:customStyleClass];
}



#pragma mark - Live Rendering
-(void)prepareForInterfaceBuilder {
    [self.styleClass applyStandardStyleOnComponent:self];
    
    if(self.onError_MDK) {
        [self.styleClass applyErrorStyleOnComponent:self];
    }
    else {
        [self.styleClass applyValidStyleOnComponent:self];
    }
}





@end
