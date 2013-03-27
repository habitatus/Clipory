//
//  MouseDisplayWindow.m
//  Clipory
//
//  Created by Beroš Jurica on 12/3/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import "MouseDisplayWindow.h"

@implementation MouseDisplayWindow
@synthesize activityView;

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(NSUInteger)windowStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)deferCreation
{
    self = [super initWithContentRect:contentRect
							styleMask:NSBorderlessWindowMask
							  backing:bufferingType
								defer:deferCreation];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
		[self setHasShadow:NO];
		[self setLevel:kCGOverlayWindowLevelKey];
		[self setIgnoresMouseEvents:YES];
		[self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorIgnoresCycle];
		 
		[self setFrame:[[NSScreen mainScreen] frame] display:YES];
	}
    return self;
}


- (void)setDisplayEvent:(NSEvent *)_event {
	[activityView setDisplayEvent:_event];
}


@end
