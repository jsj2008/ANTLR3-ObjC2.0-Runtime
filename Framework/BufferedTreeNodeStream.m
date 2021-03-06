//
//  BufferedTreeNodeStream.m
//  ANTLR
//
// [The "BSD licence"]
// Copyright (c) 2010 Ian Michell 2010 Alan Condit
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BufferedTreeNodeStream.h"
#import "StreamEnumerator.h"
#import "CommonTreeAdaptor.h"

extern NSInteger debug;

#ifdef DONTUSENOMO
@implementation TreeStreamIterator
+ newTreeStreamIteratorWithNodes:(BufferedTreeNodeStream *)theStream
{
    return[[TreeStreamIterator alloc] initWithStream:theStream];
}

- (id) initWithStream:(BufferedTreeNodeStream *)theStream
{
    if ((self = [super init]) != nil) {
        idx = 0;
        input = theStream;
        nodes = [theStream getNodes];
    }
    return self;
}

- (BOOL) hasNext
{
    return idx < [nodes count];
}

- (id) next
{
    NSInteger current = idx;
    idx++;
    if (current < [nodes count]) {
    }
    return [nodes getEof];
}

- (void) remove
{
	@throw [RuntimeException newException:@"cannot remove nodes from stream"];
}

@end
#endif

@implementation BufferedTreeNodeStream

@synthesize up;
@synthesize down;
@synthesize eof;
@synthesize nodes;
@synthesize root;
@synthesize tokens;
@synthesize adaptor;
@synthesize uniqueNavigationNodes;
@synthesize index;
@synthesize lastMarker;
@synthesize calls;
@synthesize e;
@synthesize currentSymbol;

+ (BufferedTreeNodeStream *) newBufferedTreeNodeStream:(CommonTree *) aTree
{
    return [((BufferedTreeNodeStream *)[BufferedTreeNodeStream alloc]) initWithTree:(CommonTree *)aTree];
}

+ (BufferedTreeNodeStream *) newBufferedTreeNodeStream:(id<TreeAdaptor>)adaptor Tree:(CommonTree *)aTree
{
    return [[BufferedTreeNodeStream alloc] initWithTreeAdaptor:adaptor Tree:(CommonTree *)aTree];
}

+ (BufferedTreeNodeStream *) newBufferedTreeNodeStream:(id<TreeAdaptor>)adaptor Tree:(CommonTree *)aTree withBufferSize:(NSInteger)initialBufferSize
{
    return [[BufferedTreeNodeStream alloc] initWithTreeAdaptor:adaptor Tree:(CommonTree *)aTree WithBufferSize:initialBufferSize];
}

-(BufferedTreeNodeStream *) init
{
	self = [super init];
	if (self) {
		index = -1;
		uniqueNavigationNodes = NO;
        root = [[CommonTree alloc] init];
        //		tokens = tree;
        adaptor = [[CommonTreeAdaptor alloc] init];
        nodes = [AMutableArray arrayWithCapacity:DEFAULT_INITIAL_BUFFER_SIZE];
        down = [adaptor createTree:TokenTypeDOWN Text:@"DOWN"];
        up = [adaptor createTree:TokenTypeUP Text:@"UP"];
        eof = [adaptor createTree:TokenTypeEOF Text:@"EOF"];
    }
	return self;
}

- (BufferedTreeNodeStream *)initWithTree:(CommonTree *) aTree
{
	self = [super init];
	if (self) {
		index = -1;
		uniqueNavigationNodes = NO;
        root = aTree;
        //		tokens = aTree;
        adaptor = [[CommonTreeAdaptor alloc] init];
        nodes = [AMutableArray arrayWithCapacity:DEFAULT_INITIAL_BUFFER_SIZE];
        down = [adaptor createTree:TokenTypeDOWN Text:@"DOWN"];
        up = [adaptor createTree:TokenTypeUP Text:@"UP"];
        eof = [adaptor createTree:TokenTypeEOF Text:@"EOF"];
    }
	return self;
}

-(BufferedTreeNodeStream *) initWithTreeAdaptor:(CommonTreeAdaptor *)anAdaptor Tree:(CommonTree *)aTree
{
	self = [super init];
	if (self) {
		index = -1;
		uniqueNavigationNodes = NO;
        root = aTree;
        //		tokens = aTree;
        adaptor = anAdaptor;
        nodes = [AMutableArray arrayWithCapacity:DEFAULT_INITIAL_BUFFER_SIZE];
        down = [adaptor createTree:TokenTypeDOWN Text:@"DOWN"];
        up = [adaptor createTree:TokenTypeUP Text:@"UP"];
        eof = [adaptor createTree:TokenTypeEOF Text:@"EOF"];
    }
	return self;
}

-(BufferedTreeNodeStream *) initWithTreeAdaptor:(CommonTreeAdaptor *)anAdaptor Tree:(CommonTree *)aTree WithBufferSize:(NSInteger)bufferSize
{
	self = [super init];
	if (self) {
        //		down = [adaptor createToken:TokenTypeDOWN withText:@"DOWN"];
        //		up = [adaptor createToken:TokenTypeDOWN withText:@"UP"];
        //		eof = [adaptor createToken:TokenTypeDOWN withText:@"EOF"];
		index = -1;
		uniqueNavigationNodes = NO;
        root = aTree;
        //		tokens = aTree;
        adaptor = anAdaptor;
        nodes = [AMutableArray arrayWithCapacity:bufferSize];
        down = [adaptor createTree:TokenTypeDOWN Text:@"DOWN"];
        up = [adaptor createTree:TokenTypeUP Text:@"UP"];
        eof = [adaptor createTree:TokenTypeEOF Text:@"EOF"];
	}
	return self;
}

- (void)dealloc
{
#ifdef DEBUG_DEALLOC
    NSLog( @"called dealloc in BufferedTreeNodeStream" );
#endif
    adaptor = nil;
    nodes = nil;
    root = nil;
    down = nil;
    up = nil;
    eof = nil;
}

- (id) copyWithZone:(NSZone *)aZone
{
    BufferedTreeNodeStream *copy;
    
    copy = [[[self class] allocWithZone:aZone] init];
    if ( up )
        copy.up = [up copyWithZone:aZone];
    if ( down )
        copy.down = [down copyWithZone:aZone];
    if ( eof )
        copy.eof = [eof copyWithZone:aZone];
    if ( nodes )
        copy.nodes = [nodes copyWithZone:aZone];
    if ( root )
        copy.root = [root copyWithZone:aZone];
    if ( tokens )
        copy.tokens = [tokens copyWithZone:aZone];
    if ( adaptor )
        copy.adaptor = [adaptor copyWithZone:aZone];
    copy.uniqueNavigationNodes = self.uniqueNavigationNodes;
    copy.index = self.index;
    copy.lastMarker = self.lastMarker;
    if ( calls )
        copy.calls = [calls copyWithZone:aZone];
    return copy;
}

// protected methods. DO NOT USE
#pragma mark Protected Methods
-(void) fillBuffer
{
	[self fillBufferWithTree:root];
	// if (debug > 1) NSLog("revIndex=%@", tokenTypeToStreamIndexesMap);
	index = 0; // buffer of nodes intialized now
}

-(void) fillBufferWithTree:(CommonTree *) aTree
{
	BOOL empty = [adaptor isNil:(id<BaseTree>)aTree];
	if (!empty) {
		[nodes addObject:aTree];
	}
	NSInteger n = [adaptor getChildCount:aTree];
	if (!empty && n > 0) {
		[self addNavigationNode:TokenTypeDOWN];
	}
	for (NSInteger c = 0; c < n; c++) {
		id child = [adaptor getChild:aTree At:c];
		[self fillBufferWithTree:child];
	}
	if (!empty && n > 0) {
		[self addNavigationNode:TokenTypeUP];
	}
}

-(NSInteger) getNodeIndex:(CommonTree *) node
{
	if (index == -1) {
		[self fillBuffer];
	}
	for (NSUInteger i = 0; i < [nodes count]; i++) {
		id t = [nodes objectAtIndex:i];
		if (t == node) {
			return i;
		}
	}
	return -1;
}

-(void) addNavigationNode:(NSInteger) type
{
	id navNode = nil;
	if (type == TokenTypeDOWN) {
		if (self.uniqueNavigationNodes) {
			navNode = [adaptor createToken:TokenTypeDOWN Text:@"DOWN"];
		}
		else {
			navNode = down;
		}

	}
	else {
		if (self.uniqueNavigationNodes) {
			navNode = [adaptor createToken:TokenTypeUP Text:@"UP"];
		}
		else {
			navNode = up;
		}
	}
	[nodes addObject:navNode];
}

-(id) get:(NSUInteger) i
{
	if (index == -1) {
		[self fillBuffer];
	}
	return [nodes objectAtIndex:i];
}

-(id) LT:(NSInteger) k
{
	if (index == -1) {
		[self fillBuffer];
	}
	if (k == 0) {
		return nil;
	}
	if (k < 0) {
		return [self LB:-k];
	}
	if ((index + k - 1) >= [nodes count]) {
		return eof;
	}
	return [nodes objectAtIndex:(index + k - 1)];
}

-(id) getCurrentSymbol
{
	return [self LT:1];
}

-(id) LB:(NSInteger) k
{
	if (k == 0) {
		return nil;
	}
	if ((index - k) < 0) {
		return nil;
	}
	return [nodes objectAtIndex:(index - k)];
}

- (CommonTree *)getTreeSource
{
    return root;
}

-(NSString *)getSourceName
{
	return [[self getTokenStream] getSourceName];
}

- (id<TokenStream>)getTokenStream
{
    return tokens;
}

- (void) setTokenStream:(id<TokenStream>)newtokens
{
    tokens = newtokens;
}

- (CommonTreeAdaptor *)getTreeAdaptor
{
    return adaptor;
}

- (void) setTreeAdaptor:(CommonTreeAdaptor *)anAdaptor
{
    adaptor = anAdaptor;
}

- (BOOL)getUniqueNavigationNodes
{
    return uniqueNavigationNodes;
}

- (void) setUniqueNavigationNodes:(BOOL)aVal
{
    uniqueNavigationNodes = aVal;
}

-(void) consume
{
	if (index == -1) {
		[self fillBuffer];
	}
	index++;
}

-(NSInteger) LA:(NSInteger) i
{
	return [adaptor getType:[self LT:i]];
}

-(NSInteger) mark
{
	if (index == -1) {
		[self fillBuffer];
	}
	lastMarker = self.index;
	return lastMarker;
}

-(void) release:(NSInteger) marker
{
	// do nothing
}

-(void) rewind:(NSInteger) marker
{
	[self seek:marker];
}

-(void) rewind
{
	[self seek:lastMarker];
}

-(void) seek:(NSInteger) i
{
	if (index == -1) {
		[self fillBuffer];
	}
	index = i;
}

-(void) push:(NSInteger) i
{
	if (calls == nil) {
		calls = [IntArray newArrayWithLen:INITIAL_CALL_STACK_SIZE];
	}
	[calls push:index];
	[self seek:i];
}

-(NSInteger) pop
{
	NSInteger ret = [calls pop];
	[self seek:ret];
	return ret;
}

-(void) reset
{
	index = 0;
	lastMarker = 0;
	if (calls != nil) {
		[calls reset];
	}
}

-(NSUInteger) count
{
	if (index == -1) {
		[self fillBuffer];
	}
	return [nodes count];
}

-(NSUInteger) size
{
	return [self count];
}

-(NSEnumerator *) objectEnumerator
{
	if (e == nil) {
		e = [[StreamEnumerator alloc] initWithNodes:nodes andEOF:eof];
	}
	return e;
}

-(void) replaceChildren:(CommonTree *) parent From:(NSInteger)startIdx To:(NSInteger)stopIdx With:(CommonTree *)aTree
{
	if (parent != nil) {
		[adaptor replaceChildren:parent From:startIdx To:stopIdx With:aTree];
	}
}

-(NSString *) description
{
	if (index == -1)
	{
		[self fillBuffer];
	}
	NSMutableString *buf = [NSMutableString stringWithCapacity:10];
	for (NSUInteger i= 0; i < [nodes count]; i++) {
		CommonTree * aTree = (CommonTree *)[self get:i];
		[buf appendFormat:@" %ld", [adaptor getType:aTree]];
	}
	return buf;
}

-(NSString *) description:(NSInteger)aStart ToEnd:(NSInteger)aStop
{
	if (index == -1) {
		[self fillBuffer];
	}
	NSMutableString *buf = [NSMutableString stringWithCapacity:10];
	for (NSUInteger i = aStart; i < [nodes count] && i <= aStop; i++) {
		CommonTree * t = (CommonTree *)[self get:i];
		[buf appendFormat:@" %ld", [adaptor getType:t]];
	}
	return buf;
}

-(NSString *) descriptionFromNode:(id)aStart ToNode:(id)aStop
{
	if (aStart == nil || aStop == nil) {
		return nil;
	}
	if (index == -1) {
		[self fillBuffer];
	}
	
	// if we have a token stream, use that to dump text in order
	if ([self getTokenStream] != nil) {
		NSInteger beginTokenIndex = [adaptor getTokenStartIndex:aStart];
		NSInteger endTokenIndex = [adaptor getTokenStopIndex:aStop];
		
		if ([adaptor getType:aStop] == TokenTypeUP) {
			endTokenIndex = [adaptor getTokenStopIndex:aStart];
		}
		else if ([adaptor getType:aStop] == TokenTypeEOF) {
			endTokenIndex = [self count] - 2; //don't use EOF
		}
        [tokens descriptionFromStart:beginTokenIndex ToEnd:endTokenIndex];
	}
	// walk nodes looking for aStart
	CommonTree * aTree = nil;
	NSUInteger i = 0;
	for (; i < [nodes count]; i++) {
		aTree = [nodes objectAtIndex:i];
		if (aTree == aStart) {
			break;
		}
	}
	NSMutableString *buf = [NSMutableString stringWithCapacity:10];
	aTree = [nodes objectAtIndex:i]; // why?
	while (aTree != aStop) {
		NSString *text = [adaptor getText:aTree];
		if (text == nil) {
			text = [NSString stringWithFormat:@" %ld", [adaptor getType:aTree]];
		}
		[buf appendString:text];
		i++;
		aTree = [nodes objectAtIndex:i];
	}
	NSString *text = [adaptor getText:aStop];
	if (text == nil) {
		text = [NSString stringWithFormat:@" %ld", [adaptor getType:aStop]];
	}
	[buf appendString:text];
	return buf;
}

// getters and setters
- (AMutableArray *) getNodes
{
    return nodes;
}

- (id) eof
{
    return eof;
}

- (void) setEof:(id)theEOF
{
    eof = theEOF;
}

@end
