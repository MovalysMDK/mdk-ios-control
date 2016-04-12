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

#import "AlertView.h"
#import "Style.h"
#import "ControlExtension.h"
#import "ControlCommons.h"
#import "Utils.h"
#import "Theme.h"

#import "MDKTextField.h"
#import "MDKLabel.h"

@interface MDKTextField ()

@property (nonatomic, strong) MDKTextFieldExtension *extension;

@property (nonatomic) BOOL initializing;
@property (nonatomic, strong) NSMutableArray *userFieldValidators;

@end

@implementation MDKTextField

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

#pragma mark Message
@synthesize tooltipView= _tooltipView;
@synthesize messages = _messages;

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

#pragma mark Changes
@synthesize targetDescriptors = _targetDescriptors;


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
    [[MDKTheme sharedTheme] applyThemeOnMDKUITextField:self];
    
    self.controlDelegate = [[MDKControlDelegate alloc] initWithControl:self];
    self.messages = [NSMutableArray new];
    self.extension = [[MDKTextFieldExtension alloc] init];
#if !TARGET_INTERFACE_BUILDER
    if(!self.sender) {
        self.sender = self;
    }
    self.userFieldValidators = [NSMutableArray new];
    self.initializing = YES;
    [self addTarget:self action:@selector(innerTextDidChange:) forControlEvents:UIControlEventEditingChanged|UIControlEventValueChanged];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignFirstResponder) name:ASK_HIDE_KEYBOARD object:nil];
#endif
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeTarget:self action:@selector(innerTextDidChange:) forControlEvents:UIControlEventEditingChanged|UIControlEventValueChanged];
    self.targetDescriptors = nil;
}


#pragma mark - TextField Methods

-(CGRect)textRectForBounds:(CGRect)bounds {
    [super textRectForBounds:bounds];
    return [((MDKTextFieldStyle *)self.styleClass) textRectForBounds:bounds onComponent:self];
}

-(CGRect)editingRectForBounds:(CGRect)bounds {
    [super editingRectForBounds:bounds];
    return [((MDKTextFieldStyle *)self.styleClass) editingRectForBounds:bounds onComponent:self];
}

-(CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect superBounds = [super clearButtonRectForBounds:bounds];
    return [((MDKTextFieldStyle *)self.styleClass) clearButtonRectForBounds:superBounds onComponent:self];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect superBounds = [super textRectForBounds:bounds];
    return [((MDKTextFieldStyle *)self.styleClass) placeholderRectForBounds:superBounds onComponent:self];
}

-(CGRect)borderRectForBounds:(CGRect)bounds {
    CGRect superBounds = [super borderRectForBounds:bounds];
    return [((MDKTextFieldStyle *)self.styleClass) borderRectForBounds:superBounds onComponent:self];
    
}


#pragma mark - Custom methods
-(void) addAccessories:(NSDictionary *) accessoryViews {
    for(UIView *view in accessoryViews.allValues) {
        [self addSubview:view];
        [self bringSubviewToFront:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *constraintsToAdd = [((MDKTextFieldStyle *)self.styleClass) defineConstraintsForAccessoryView:view withIdentifier:[[accessoryViews allKeysForObject:view] firstObject] onControl:self];
        [self addConstraints:constraintsToAdd];
    }
}

-(NSString *) stringData {
    return [[self getData] isKindOfClass:[NSAttributedString class]] ? [[self getData] string] : [self getData];
}

#pragma mark - Control Data Protocol
-(void)setData:(id)data {
    id fixedData = data;
    if(data && ![data isKindOfClass:NSClassFromString(@"MFKeyNotFound")]) {
        NSString *stringData = (NSString *)data;
        fixedData = stringData;
    }
    else if(!data) {
        fixedData = @"";
    }
    if([fixedData isKindOfClass:[NSAttributedString class]]) {
        self.attributedText = fixedData;
    }
    else {
        self.text = fixedData;
    }
    [self validate];
    self.initializing = NO;
}

-(id)getData {
    return self.attributedText ? [self.attributedText string] : self.text;
}

+(NSString *) getDataType {
    return @"NSString";
}



#pragma mark - Validation
-(void)setIsValid:(BOOL) isValid {
    [self.controlDelegate setIsValid:isValid];
}

-(BOOL) isValid {
    return ([self validate] == 0);
}

-(NSArray *)controlValidators {
    return @[];
}

-(NSInteger)validate {
    return [self.controlDelegate validate];
}



#pragma mark - Messages
-(NSArray *)getMessages {
    return [self.controlDelegate getMessages];
}

-(void)addMessages:(NSArray *)errors {
    [self.controlDelegate addMessages:errors];
}

-(void)clearMessages {
    [self.controlDelegate clearMessages];
}

-(void)showMessage:(BOOL)showMessage {
    [self.controlDelegate setIsValid:!showMessage];
}

-(void)onMessageButtonClick:(id)sender {
    [self.controlDelegate onMessageButtonClick:sender];
}

#pragma mark - Control attributes
-(void)setControlAttributes:(NSDictionary *)controlAttributes {
    _controlAttributes = controlAttributes;
    self.mandatory = controlAttributes[@"mandatory"] ? controlAttributes[@"mandatory"] : @1;
    if(self.associatedLabel) {
        self.associatedLabel.mandatory = self.mandatory;
    }
    self.editable = controlAttributes[@"editable"] ? controlAttributes[@"editable"] : @1;
    self.visible = controlAttributes[@"visible"] ? controlAttributes[@"visible"] : @1;
}

-(void)addControlAttribute:(id)controlAttribute forKey:(NSString *)key {
    [self.controlDelegate addControlAttribute:controlAttribute forKey:key];
}


#pragma mark - Properties
-(void)setMandatory:(NSNumber *)mandatory {
    _mandatory = mandatory;
    if(self.associatedLabel) {
        self.associatedLabel.mandatory = _mandatory;
    }
}
-(void)setEditable:(NSNumber *)editable {
    _editable = editable;
    self.userInteractionEnabled = [editable boolValue];
    [self applyStandardStyle];
}

-(void)setVisible:(NSNumber *)visible {
    _visible = visible;
    [self.controlDelegate setVisible:visible];
}


#pragma mark - Associated Label
-(void)setAssociatedLabel:(MDKLabel *)associatedLabel {
    _associatedLabel = associatedLabel;
    self.associatedLabel.mandatory = self.mandatory;
}



#pragma mark - Style
-(void)setCustomStyleClass:(Class)customStyleClass {
    _customStyleClass = customStyleClass;
    [self.controlDelegate setCustomStyleClass:customStyleClass];
}



#pragma mark - Changes
-(void)innerTextDidChange:(id)sender {
    [self valueChanged:sender];
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if([self isEqual:target]) {
        [super addTarget:target action:action forControlEvents:controlEvents];
    }
    else {
        MDKControlEventsDescriptor *commonCCTD = [MDKControlEventsDescriptor new];
        commonCCTD.target = target;
        commonCCTD.action = action;
        self.targetDescriptors = @{@(self.hash) : commonCCTD};
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void) valueChanged:(UIView *)sender {
    if([self.controlDelegate validate] == 0) {
        MDKControlEventsDescriptor *cctd = self.targetDescriptors[@(sender.hash)];
        [cctd.target performSelector:cctd.action withObject:self];
    }
}
#pragma clang diagnostic pop


#pragma mark - Live Rendering
-(void)prepareForInterfaceBuilder {
    [self applyStandardStyle];
    
    if(self.onError_MDK) {
        [self applyEnabledStyle];
    }
    else {
        [self applyValidStyle];
    }
}

@end
