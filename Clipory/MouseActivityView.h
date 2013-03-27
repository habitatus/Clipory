//
//  MouseActivityView.h
//  Clipory
//
//  Created by Beroš Jurica on 12/3/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MouseActivityView : NSView {
	BOOL mouseDown;
	NSPoint mousePoint;
	NSMutableArray *halos;
}

@property (nonatomic, strong) NSColor *circleColor;

- (void)setDisplayEvent:(NSEvent *)_event;

@end
