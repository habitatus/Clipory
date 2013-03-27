//
//  MouseActivityView.m
//  Clipory
//
//  Created by Beroš Jurica on 12/3/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import "MouseActivityView.h"
#import <QuartzCore/QuartzCore.h>

#define MouseCircleRadius 10.0f


@implementation MouseActivityView
@synthesize circleColor;

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self) {
		[[NSUserDefaults standardUserDefaults] addObserver:self
												forKeyPath:@"kMouseColor"
												   options:NSKeyValueObservingOptionNew
												   context:NULL];

		NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kMouseColor"];
		if(colorData != nil) {
			self.circleColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
		}
		halos = [[NSMutableArray alloc] init];
		self.wantsLayer = YES;
	}
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context {
	NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kMouseColor"];
	if(colorData != nil) {
		self.circleColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
	}
	[self setNeedsDisplay:YES];
	
}

- (void)setDisplayEvent:(NSEvent *)_event {
	if([_event type] == NSLeftMouseDown || [_event type] == NSRightMouseDown) {
		mouseDown = YES;
	}
	if([_event type] == NSLeftMouseUp || [_event type] == NSRightMouseUp) {
		mouseDown = NO;
	}
	mousePoint = [_event locationInWindow];

	//NSRect pointRect = NSMakeRect(mousePoint.x - MouseCircleRadius, mousePoint.y - MouseCircleRadius, MouseCircleRadius * 2.0f, MouseCircleRadius * 2.0f);
	//[self setNeedsDisplayInRect:NSInsetRect(pointRect, -MouseCircleRadius * 5.0f, - MouseCircleRadius * 5.0f)];
	
	if(mouseDown) {
		CALayer *imgLayer = [[CALayer alloc] init];
		imgLayer.contents = [NSImage imageNamed:@"TrackingDotHaloSmall.png"];
		imgLayer.masksToBounds = NO;
		imgLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
		imgLayer.position = mousePoint;
		imgLayer.bounds = NSMakeRect(0.0f, 0.0f, MouseCircleRadius, MouseCircleRadius);
		[self.layer addSublayer:imgLayer];

		
		CABasicAnimation* fadeAnimation = [CABasicAnimation animation];
		fadeAnimation.keyPath = @"opacity";
		fadeAnimation.fromValue = [NSNumber numberWithFloat: 1.0f];
		fadeAnimation.toValue = [NSNumber numberWithFloat: 0.0f];

		CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
		pulseAnimation.keyPath = @"bounds";
		pulseAnimation.fromValue = [NSValue valueWithRect:imgLayer.bounds];
		pulseAnimation.toValue = [NSValue valueWithRect:NSMakeRect(0.0f, 0.0f, 85.0f, 85.0f)];
		
		
		CAAnimationGroup *group = [CAAnimationGroup animation];
		group.duration = 0.4f;
		group.delegate = self;
		group.autoreverses = NO;
		group.removedOnCompletion = NO;
		group.fillMode = kCAFillModeForwards;
		group.repeatCount = 0;
		group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		[group setAnimations:[NSArray arrayWithObjects:fadeAnimation, pulseAnimation, nil]];

		[imgLayer addAnimation:group forKey:nil];
		[halos insertObject:imgLayer atIndex:0];
	}
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	if(flag) {
		CALayer *imgLayer = [halos lastObject];
		imgLayer.opacity = 0.0f;
		[imgLayer removeAllAnimations];
		[imgLayer removeFromSuperlayer];
		[halos removeLastObject];
		//NSLog(@"NUmber imageviews: %d", (int)[self.subviews count]);
	}
}

- (void)drawRect:(NSRect)dirtyRect
{
//	if(mouseDown) {
//		NSRect pointRect = NSMakeRect(mousePoint.x - MouseCircleRadius, mousePoint.y - MouseCircleRadius, MouseCircleRadius * 2.0f, MouseCircleRadius * 2.0f);
//		
//		NSBezierPath* roundRectPath = [NSBezierPath bezierPathWithRoundedRect:pointRect xRadius:MouseCircleRadius yRadius:MouseCircleRadius];
//		[roundRectPath addClip];
//		
//		[self.circleColor setFill];
//		NSRectFill(pointRect);
//		
////		[[NSColor colorWithCalibratedWhite:1.0f alpha:0.5f] setStroke];
////		[roundRectPath setLineWidth:3.0f];
////		[roundRectPath stroke];
//	}
}

@end
