//
//  EventDisplayView.m
//  Clipory
//
//  Created by Beroš Jurica on 12/3/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import "EventDisplayView.h"

@implementation EventDisplayView
@synthesize backgroundColor;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kBackgroundColor"];
		if(colorData != nil) {
			self.backgroundColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
		}

		if(!self.backgroundColor) {
			self.backgroundColor = [NSColor colorWithCalibratedWhite:0.0f alpha:0.65f];
			[[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:self.backgroundColor] 
													  forKey:@"kBackgroundColor"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
    }
	
	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:@"kBackgroundColor"
											   options:NSKeyValueObservingOptionNew
											   context:NULL];

    
    return self;
}

- (BOOL)isOpaque {
	return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context {
	NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kBackgroundColor"];
	if(colorData != nil) {
		self.backgroundColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
	}
	[self setNeedsDisplay:YES];
	
}

- (void)drawRect:(NSRect)dirtyRect
{
	NSBezierPath* roundRectPath = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:10.0f yRadius:10.0f];
    [roundRectPath addClip];
	
	[self.backgroundColor setFill];
	NSRectFill(self.bounds);
}

@end
