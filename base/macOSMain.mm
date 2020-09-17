#import <Cocoa/Cocoa.h>

#import "DemoView.h"

#import <string>

@interface DemoApplicationDelegate : NSObject
@end

@implementation DemoApplicationDelegate
	- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
	{
		return YES;
	}
@end

@interface DemoWindowDelegate : NSObject
@end

@implementation DemoWindowDelegate
	- (BOOL)acceptsFirstResponder
	{
		return YES;
	}

	- (void) keyDown:(NSEvent*) theEvent
	{
	}
@end

void macOSQuit()
{
	[NSApp terminate:NSApp];
}

void macOSSetWindowTitle(void * view, const char * title)
{
	// NSView * nsView = reinterpret_cast< NSView * >( view );
	// [[nsView window] setTitle:[NSString stringWithUTF8String: title]];
}

void macOSMain()
{
	[NSAutoreleasePool new];
	id app = [NSApplication sharedApplication];
	[app setActivationPolicy:NSApplicationActivationPolicyRegular];

	// Create window
	NSRect wndFrame = NSMakeRect(0, 0, 1280, 720);
	id window  = [[[NSWindow alloc]
		initWithContentRect:wndFrame
		styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
		backing:NSBackingStoreBuffered
		defer:NO] autorelease];
	[window cascadeTopLeftFromPoint:NSMakePoint(10, 10)];
	[window setBackgroundColor:[NSColor blueColor]];
	[window setTitle:@"TestWindow"];
	[window makeKeyAndOrderFront:nil];

	// Window controller 
	NSWindowController * windowController = [[[NSWindowController alloc] initWithWindow:window] autorelease];

	// Since Snow Leopard, programs without application bundles and Info.plist files don't get a menubar 
	// and can't be brought to the front unless the presentation option is changed
	[app setActivationPolicy:NSApplicationActivationPolicyRegular];
	
	// Next, we need to create the menu bar. You don't need to give the first item in the menubar a name 
	// (it will get the application's name automatically)
	id menubar = [[NSMenu new] autorelease];
	id appMenuItem = [[NSMenuItem new] autorelease];
	[menubar addItem:appMenuItem];
	[app setMainMenu:menubar];

	// Then we add the quit item to the menu. Fortunately the action is simple since terminate: is 
	// already implemented in NSApplication and the NSApplication is always in the responder chain.
	id appMenu = [[NSMenu new] autorelease];
	id appName = [[NSProcessInfo processInfo] processName];
	id quitTitle = [@"Quit " stringByAppendingString:appName];
	id quitMenuItem = [[[NSMenuItem alloc] initWithTitle:quitTitle
		action:@selector(terminate:) keyEquivalent:@"q"] autorelease];
	[appMenu addItem:quitMenuItem];
	[appMenuItem setSubmenu:appMenu];

	// Create Metal compatible view
	DemoView * view = [[[DemoView alloc] initWithFrame:wndFrame] autorelease];
	[window setAcceptsMouseMovedEvents:YES];
	[window setContentView:view];
	[window setDelegate:view];

	id appDelegate =[DemoApplicationDelegate new];
	[app setDelegate: appDelegate];
	[app activateIgnoringOtherApps:YES];
	[app setActivationPolicy:NSApplicationActivationPolicyRegular];

	[app run];
}
