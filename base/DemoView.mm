
#import <QuartzCore/CAMetalLayer.h>

#import "DemoView.h"
#import "vulkanexamplebase.h"

/** Rendering loop callback function for use with a CVDisplayLink. */
static CVReturn displayLinkCallback( CVDisplayLinkRef displayLink
	, const CVTimeStamp * now
	, const CVTimeStamp * outputTime
	, CVOptionFlags flagsIn
	, CVOptionFlags * flagsOut
	, void * target )
{
	reinterpret_cast< VulkanExampleBase * >( target )->renderFrame();
	return kCVReturnSuccess;
}

VulkanExampleBase * createVulkanExample();

@implementation DemoView
{
	VulkanExampleBase * m_example;
	CVDisplayLinkRef m_displayLink;
}
// Initialize
- (id) initWithFrame: (NSRect) frame
{
	self = [super initWithFrame:frame];
	running = true;

	if (![self.layer isKindOfClass:[CAMetalLayer class]])
	{
		[self setLayer:[CAMetalLayer layer]];
		[self setWantsLayer:YES];
	}

	// Initialise example
	m_example = createVulkanExample();
	m_example->initVulkan();
	m_example->setupWindow( self );
	m_example->initSwapchain();
	m_example->prepare();

	CVDisplayLinkCreateWithActiveCGDisplays( &m_displayLink );
	CVDisplayLinkSetOutputCallback( m_displayLink, &displayLinkCallback, m_example );
	CVDisplayLinkStart( m_displayLink );

	return self;
}

// Cleanup
- (void) dealloc
{   
	[super dealloc];

	CVDisplayLinkRelease( m_displayLink );
	delete m_example;
}

// Tell the window to accept input events
- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (void)mouseMoved:(NSEvent*) event
{
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	m_example->mouseMove(point.x, point.y);
}

- (void) mouseDragged: (NSEvent*) event
{
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	m_example->mouseMove(point.x, point.y);
}

- (void)scrollWheel: (NSEvent*) event
{
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	m_example->mouseScroll(point.x, point.y);
}

- (void) mouseDown: (NSEvent*) event 
{
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	m_example->mouseLeftDown(point.x, point.y);
}

- (void) mouseUp: (NSEvent*) event
 {
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	m_example->mouseLeftUp(point.x, point.y);
}

- (void) rightMouseDown: (NSEvent*) event
 {
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	m_example->mouseRightDown(point.x, point.y);
}

- (void) rightMouseUp: (NSEvent*) event
 {
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	m_example->mouseRightUp(point.x, point.y);
}

- (void)otherMouseDown: (NSEvent*) event
 {
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	m_example->mouseMiddleDown(point.x, point.y);
}

- (void)otherMouseUp: (NSEvent*) event
 {
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	m_example->mouseMiddleUp(point.x, point.y);
}

- (void) mouseEntered: (NSEvent*)event
 {
}

- (void) mouseExited: (NSEvent*)event
 {
}

- (void) keyDown: (NSEvent*) event 
{
	m_example->keyDown( event.keyCode );
}

- (void) keyUp: (NSEvent*) event
{
	m_example->keyUp( event.keyCode );
}

// Resize
- (void)windowDidResize:(NSNotification*)notification
{
	NSSize size = [self frame].size;
	m_example->windowResize(size.width, size.height);
}

// Terminate window when the red X is pressed
-(void)windowWillClose:(NSNotification *)notification
{
	if (running)
	{
		running = false;
	}

	[NSApp terminate:self];
}
@end