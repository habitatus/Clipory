//
//  EventDisplayWindow.m
//  Clipory
//
//  Created by Beroš Jurica on 12/3/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import "EventDisplayWindow.h"

@implementation EventDisplayWindow
@synthesize displayTextField;

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(NSUInteger)windowStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)deferCreation
{
    self = [super initWithContentRect:contentRect
							styleMask:NSBorderlessWindowMask | NSResizableWindowMask
							  backing:bufferingType
								defer:deferCreation];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
		[self setHasShadow:YES];
		[self setLevel:kCGOverlayWindowLevelKey];
		[self setMovableByWindowBackground:YES];
		[self setDelegate:self];
		
		[[NSUserDefaults standardUserDefaults] addObserver:self
												forKeyPath:@"kTextColor"
												   options:NSKeyValueObservingOptionNew
												   context:NULL];
	}
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context {
	NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kTextColor"];
	if(colorData != nil) {
		displayTextField.textColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
	}
}

- (void)windowDidResize:(NSNotification *)notification {
	displayTextField.font = [NSFont boldSystemFontOfSize:displayTextField.bounds.size.height / 1.18f];
}

- (void)setDisplayEvent:(NSEvent *)_event {
	displayTextField.stringValue = @"";
	displayTextField.alphaValue = 1.0f;
	
	NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kTextColor"];
	if(colorData != nil) {
		displayTextField.textColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
	}
	[[displayTextField cell] setBackgroundStyle:NSBackgroundStyleDark];
	
	NSMutableArray *symbols = [[NSMutableArray alloc] init];

	if([_event type] == NSFlagsChanged) {
		shift = NO;
		option = NO;
		command = NO;
		if ([_event modifierFlags] & NSShiftKeyMask) {
			shift = YES;
		} 
		if ([_event modifierFlags] & NSAlternateKeyMask) {
			option = YES;
		} 
		if ([_event modifierFlags] & NSCommandKeyMask) {
			command = YES;
		}
	}

	

	if(command) {
		[symbols addObject:@"⌘"];
	}
	if(shift) {
		[symbols addObject:@"⇧"];
	}
	if(option) {
		[symbols addObject:@"⌥"];
	}
	
	if([_event type] == NSKeyDown) {
		
		NSString *characters;
		characters = [_event characters];
		
		unichar character;
		character = [characters characterAtIndex: 0];
		
		if (character == NSRightArrowFunctionKey) {
			[symbols addObject:@"→"];
		} else if (character == NSLeftArrowFunctionKey) {
			[symbols addObject:@"←"];
		} else if (character == NSUpArrowFunctionKey) {
			[symbols addObject:@"↑"];
		} else if (character == NSDownArrowFunctionKey) {
			[symbols addObject:@"↓"];
		} else if (character == NSTabCharacter) {
			[symbols addObject:@"⇥"];
		} else if (character == 32) {
			[symbols addObject:@"space"];
		} else if (character == 27) {
			[symbols addObject:@"⎋"];
		} else {
			[symbols addObject:[_event characters]];
		}
	}
	
	NSString *stringToDisplay = [symbols componentsJoinedByString:@"+"];
	displayTextField.stringValue = stringToDisplay;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearTextField) object:nil];
	[self performSelector:@selector(clearTextField) withObject:nil afterDelay:1.0f];
}

- (void)clearTextField {
	if(command || shift || option) return;
	[[displayTextField animator] setAlphaValue:0.0f];
}

@end