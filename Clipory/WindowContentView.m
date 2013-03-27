//
//  WindowContentView.m
//  Clipory
//
//  Created by Jurica Beroš on 10/15/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import "WindowContentView.h"
#import "HBTAppDelegate.h"

@implementation WindowContentView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		NSButton *menuButton = [[NSButton alloc] initWithFrame:NSMakeRect(self.frame.size.width - 24.0f, 4.0f, 16.0f, 16.0f)];
		[menuButton setAutoresizingMask:NSViewMinYMargin | NSViewMaxXMargin];
		[menuButton setTarget:self];
		[menuButton setAction:@selector(menuButtonClicked:)];
		[menuButton setImage:[NSImage imageNamed:NSImageNameActionTemplate]];
		[menuButton setBordered:NO];
		[menuButton setButtonType:NSMomentaryChangeButton];
		[menuButton setFocusRingType:NSFocusRingTypeNone];
		[self addSubview:menuButton];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		NSButton *menuButton = [[NSButton alloc] initWithFrame:NSMakeRect(self.frame.size.width - 24.0f, 4.0f, 16.0f, 16.0f)];
		[menuButton setAutoresizingMask:NSViewMinYMargin | NSViewMaxXMargin];
		[menuButton setTarget:self];
		[menuButton setAction:@selector(menuButtonClicked:)];
		[menuButton setImage:[NSImage imageNamed:NSImageNameActionTemplate]];
		[menuButton setBordered:NO];
		[menuButton setButtonType:NSMomentaryChangeButton];
		[menuButton setFocusRingType:NSFocusRingTypeNone];
		[self addSubview:menuButton];
    }
    
    return self;
}



- (void)awakeFromNib
{

}

- (void)drawRect:(NSRect)dirtyRect
{
	dirtyRect = self.frame;
	[[NSColor clearColor] set];
	NSRectFill(dirtyRect);
	
	float cornerRadius = 7.0f;
	float arrowSize = 10.0f;
	float arrowWidthCoeficient = 0.8;
	float borderWidth = 1.0f;
	
	
	dirtyRect = NSInsetRect(dirtyRect, borderWidth, borderWidth);
	dirtyRect.size.height -= arrowSize;
	
	NSPoint origin = dirtyRect.origin;
	NSSize size = dirtyRect.size;
	origin.x = fabs(origin.x) - 0.5f; 
	origin.y = fabs(origin.y) - 0.5f;

	size.height = fabs(size.height) - 0.5f;

	dirtyRect.origin = origin;
	dirtyRect.size = size;
	
	NSBezierPath *thePath = [NSBezierPath bezierPath];
	
	
	// bottom left
	[thePath moveToPoint:NSMakePoint(origin.x + borderWidth + cornerRadius, origin.y + borderWidth)];
	[thePath appendBezierPathWithArcFromPoint:NSMakePoint(origin.x + borderWidth, origin.y + borderWidth) 
									  toPoint:NSMakePoint(origin.x + borderWidth, origin.y + borderWidth + cornerRadius) 
									   radius:cornerRadius];	

	// top left
	[thePath appendBezierPathWithArcFromPoint:NSMakePoint(origin.x + borderWidth, dirtyRect.size.height - borderWidth * 2) 
									  toPoint:NSMakePoint(origin.x + borderWidth + cornerRadius, dirtyRect.size.height - borderWidth * 2) 
									   radius:cornerRadius];
	
	[thePath lineToPoint:NSMakePoint(dirtyRect.size.width / 2 - arrowSize / arrowWidthCoeficient, dirtyRect.size.height - borderWidth * 2)];
	[thePath lineToPoint:NSMakePoint(dirtyRect.size.width / 2, dirtyRect.size.height + arrowSize - 0.5f)];
	[thePath lineToPoint:NSMakePoint(dirtyRect.size.width / 2 + arrowSize / arrowWidthCoeficient, dirtyRect.size.height - borderWidth * 2)];
	
	
	// top right
	[thePath appendBezierPathWithArcFromPoint:NSMakePoint(dirtyRect.size.width - origin.x - borderWidth * 2, dirtyRect.size.height - borderWidth * 2) 
									  toPoint:NSMakePoint(dirtyRect.size.width - origin.x - borderWidth * 2, dirtyRect.size.height - borderWidth * 2 - cornerRadius) 
									   radius:cornerRadius];

	// bottom right
	[thePath appendBezierPathWithArcFromPoint:NSMakePoint(dirtyRect.size.width - origin.x - borderWidth * 2, origin.y + borderWidth) 
									  toPoint:NSMakePoint(dirtyRect.size.width - origin.x - borderWidth * 2 - cornerRadius, origin.y + borderWidth) 
									   radius:cornerRadius];
	
	// bottom left
	[thePath appendBezierPathWithArcFromPoint:NSMakePoint(origin.x + borderWidth, origin.y + borderWidth)
									  toPoint:NSMakePoint(origin.x + borderWidth, origin.y + borderWidth + cornerRadius)
									   radius:cornerRadius];

	
	[NSGraphicsContext saveGraphicsState];
	[thePath addClip];

	// Draw main Gradient
	NSColor *startingColor = [NSColor colorWithCalibratedWhite:0.4 alpha:1.0];
	NSColor *endColor = [NSColor colorWithCalibratedWhite:0.1 alpha:1.0];	
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startingColor endingColor:endColor];
	[gradient drawInBezierPath:thePath angle:-90];

	// Draw noise
	NSRect resRect = NSMakeRect(0.0, 0.0, dirtyRect.size.width, dirtyRect.size.height + arrowSize);
	[[NSColor colorWithPatternImage:[NSImage imageNamed:@"BackgroundNoise.png"]] set];
	NSRectFillUsingOperation(resRect, NSCompositeSourceOver);
	
	// Draw upper highlight gradient
	NSImage *gradientImage = [NSImage imageNamed:@"TopGradient.png"];
	NSRect resRect2 = NSMakeRect(0.0, dirtyRect.size.height - arrowSize, dirtyRect.size.width, gradientImage.size.height);
	[gradientImage drawInRect:resRect2 fromRect:NSMakeRect(0, 0, gradientImage.size.width, gradientImage.size.height) operation:NSCompositeSourceAtop fraction:1.0];

	// Inset highlight
	NSAffineTransform *transform = [NSAffineTransform transform];
	NSBezierPath *white = [thePath copy];
	[transform translateXBy: 0.0 yBy: -1.0f];
	[white transformUsingAffineTransform: transform];

	[[NSColor colorWithCalibratedWhite:1.0f alpha:0.4f] setStroke];
	[white setLineWidth:borderWidth];
	[white stroke];

	
	[NSGraphicsContext restoreGraphicsState];
	
	// Dark border
	[[NSColor colorWithCalibratedWhite:0.1f alpha:1.0f] setStroke];
	[thePath setLineWidth:borderWidth];
	[thePath stroke];
	
}


- (void)menuButtonClicked:(id)sender
{
	HBTAppDelegate *appDelegate = (HBTAppDelegate *)[NSApplication sharedApplication].delegate;
	NSMenu *popupMenu = appDelegate.popupMainMenu;

	NSRect frame = [(NSButton *)sender frame];
    NSPoint menuOrigin = [[(NSButton *)sender superview] convertPoint:NSMakePoint(frame.origin.x, frame.origin.y - 5)
                                                               toView:nil];
	
    NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                         location:menuOrigin
                                    modifierFlags:NSLeftMouseDownMask // 0x100
                                        timestamp:[NSDate timeIntervalSinceReferenceDate]
                                     windowNumber:[[(NSButton *)sender window] windowNumber]
                                          context:[[(NSButton *)sender window] graphicsContext]
                                      eventNumber:0
                                       clickCount:1
                                         pressure:1];

	[NSMenu popUpContextMenu:popupMenu withEvent:event forView:self];
}
@end
