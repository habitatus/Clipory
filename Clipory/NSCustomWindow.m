//
//  NSCustomWindow.m
//  Clipory
//
//  Created by Jurica Beroš on 10/15/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import "NSCustomWindow.h"
#import "WindowContentView.h"

@implementation NSCustomWindow

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
		[self setHasShadow:YES];
		[self setLevel:kCGMainMenuWindowLevel];
	}
    return self;
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

//- (void)setContentView:(NSView *)aView {	
//    NSRect bounds = [self frame];
//    bounds.origin = NSZeroPoint;
//	bounds.origin.y = 0.5;
//
//    WindowContentView *frameView = [super contentView];
//    if (!frameView) {
//        frameView = [[WindowContentView alloc] initWithFrame:bounds];
//        [super setContentView:frameView];
//		//[[self contentView] setLayerContentsRedrawPolicy:NSViewLayerContentsRedrawNever];
//    }
//    
//	//[self setupTransforms];
//	[[self contentView] layer].anchorPoint = CGPointMake(0.5, 0.5);	
//
//}

@end
