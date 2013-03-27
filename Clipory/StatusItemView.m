//
//  StatusItemView.m
//  Clipory
//
//  Created by Jurica Beroš on 10/15/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import "StatusItemView.h"

#define StatusItemViewPaddingWidth  10
#define StatusItemViewPaddingHeight 3

@implementation StatusItemView
@synthesize statusItem, title;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		isHighlighted = NO;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDisplayed:) name:kNotificationWindowDisplayed object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowHidden:) name:kNotificationWindowHidden object:nil];
    }
    
    return self;
}

- (NSColor *)titleForegroundColor {
    if (isHighlighted) {
        return [NSColor whiteColor];
    }
    else {
        return [NSColor blackColor];
    }    
}

- (NSDictionary *)titleAttributes {
    // Use default menu bar font size
    NSFont *font = [NSFont menuBarFontOfSize:0];
	
    NSColor *foregroundColor = [self titleForegroundColor];
	
    return [NSDictionary dictionaryWithObjectsAndKeys:
            font,            NSFontAttributeName,
            foregroundColor, NSForegroundColorAttributeName,
            nil];
}

- (NSRect)titleBoundingRect {
    return [title boundingRectWithSize:NSMakeSize(1e100, 1e100)
                               options:0
                            attributes:[self titleAttributes]];
}

- (void)setTitle:(NSString *)newTitle {
    if (![title isEqual:newTitle]) {
        title = newTitle;
		
        // Update status item size (which will also update this view's bounds)
        NSRect titleBounds = [self titleBoundingRect];
        int newWidth = titleBounds.size.width + (2 * StatusItemViewPaddingWidth);
        [statusItem setLength:newWidth];
		
        [self setNeedsDisplay:YES];
    }
}


- (void)drawRect:(NSRect)rect
{
    // Draw status bar background, highlighted if menu is showing
    [statusItem drawStatusBarBackgroundInRect:[self bounds]
                                withHighlight:isHighlighted];
	
    // Draw title string
    NSPoint origin = NSMakePoint(StatusItemViewPaddingWidth,
                                 StatusItemViewPaddingHeight);
    [title drawAtPoint:origin
        withAttributes:[self titleAttributes]];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusItemClicked object:nil];
	//[statusItem popUpStatusItemMenu:statusItem.menu];
}

- (void)mouseUp:(NSEvent *)theEvent
{
}


- (void)windowDisplayed:(id)sender
{
	isHighlighted = YES;
	[self setNeedsDisplay:YES];	
}
- (void)windowHidden:(id)sender
{
	isHighlighted = NO;
	[self setNeedsDisplay:YES];	
}

@end
