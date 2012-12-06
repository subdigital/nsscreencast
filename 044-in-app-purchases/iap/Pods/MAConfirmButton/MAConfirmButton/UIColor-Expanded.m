#import "UIColor-Expanded.h"

/*
 
 Thanks to Poltras, Millenomi, Eridius, Nownot, WhatAHam, jberry,
 and everyone else who helped out but whose name is inadvertantly omitted
 
*/

/*
 Current outstanding request list:
 
 - PolarBearFarm - color descriptions ([UIColor warmGrayWithHintOfBlueTouchOfRedAndSplashOfYellowColor])
 - Eridius - UIColor needs a method that takes 2 colors and gives a third complementary one
 - Consider UIMutableColor that can be adjusted (brighter, cooler, warmer, thicker-alpha, etc)
 */

/*
 FOR REFERENCE: Color Space Models: enum CGColorSpaceModel {
	kCGColorSpaceModelUnknown = -1,
	kCGColorSpaceModelMonochrome,
	kCGColorSpaceModelRGB,
	kCGColorSpaceModelCMYK,
	kCGColorSpaceModelLab,
	kCGColorSpaceModelDeviceN,
	kCGColorSpaceModelIndexed,
	kCGColorSpaceModelPattern
};
*/

static const char *colorNameDB;
static const char *crayolaNameDB;

// Complete dictionary of color name -> color mappings, generated
// by a call to +namedColors or +colorWithName:
static NSDictionary *colorNameCache = nil;
static NSDictionary *crayolaNameCache = nil;
static NSLock *colorNameCacheLock;
static NSLock *crayolaNameCacheLock;

#if SUPPORTS_UNDOCUMENTED_API
// UIColor_Undocumented
// Undocumented methods of UIColor
@interface UIColor (UIColor_Undocumented)
- (NSString *)styleString;
@end
#endif // SUPPORTS_UNDOCUMENTED_API

@interface UIColor (UIColor_Expanded_Support)
+ (void)populateColorNameCache;
+ (void)populateCrayolaNameCache;
@end

#pragma mark -

@implementation UIColor (UIColor_Expanded)

- (CGColorSpaceModel)colorSpaceModel {
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)colorSpaceString {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelUnknown:
			return @"kCGColorSpaceModelUnknown";
		case kCGColorSpaceModelMonochrome:
			return @"kCGColorSpaceModelMonochrome";
		case kCGColorSpaceModelRGB:
			return @"kCGColorSpaceModelRGB";
		case kCGColorSpaceModelCMYK:
			return @"kCGColorSpaceModelCMYK";
		case kCGColorSpaceModelLab:
			return @"kCGColorSpaceModelLab";
		case kCGColorSpaceModelDeviceN:
			return @"kCGColorSpaceModelDeviceN";
		case kCGColorSpaceModelIndexed:
			return @"kCGColorSpaceModelIndexed";
		case kCGColorSpaceModelPattern:
			return @"kCGColorSpaceModelPattern";
		default:
			return @"Not a valid color space";
	}
}

- (BOOL)canProvideRGBComponents {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
		case kCGColorSpaceModelMonochrome:
			return YES;
		default:
			return NO;
	}
}

- (NSArray *)arrayFromRGBAComponents {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -arrayFromRGBAComponents");

	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [NSArray arrayWithObjects:
			[NSNumber numberWithFloat:r],
			[NSNumber numberWithFloat:g],
			[NSNumber numberWithFloat:b],
			[NSNumber numberWithFloat:a],
			nil];
}

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	
	CGFloat r,g,b,a;
	
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			a = components[1];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			a = components[3];
			break;
		default:	// We don't know how to handle this model
			return NO;
	}
	
	if (red) *red = r;
	if (green) *green = g;
	if (blue) *blue = b;
	if (alpha) *alpha = a;
	
	return YES;
}

- (BOOL)hue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha {
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return NO;
	
	[UIColor red:r green:g blue:b toHue:hue saturation:saturation brightness:brightness];
	
	if (alpha) *alpha = a;
	
	return YES;
}

- (CGFloat)red {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)green {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[1];
}

- (CGFloat)blue {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[2];
}

- (CGFloat)white {
	NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)hue {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -hue");
	CGFloat h = 0.0f;
	[self hue:&h saturation:nil brightness:nil alpha:nil];
	return h;
}

- (CGFloat)saturation {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -saturation");
	CGFloat s = 0.0f;
	[self hue:nil saturation:&s brightness:nil alpha:nil];
	return s;
}

- (CGFloat)brightness {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -brightness");
	CGFloat v = 0.0f;
	[self hue:nil saturation:nil brightness:&v alpha:nil];
	return v;
}

- (CGFloat)alpha {
	return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)luminance {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use luminance");

	CGFloat r,g,b;
	if (![self red:&r green:&g blue:&b alpha:nil]) return 0.0f;
	
	// http://en.wikipedia.org/wiki/Luma_(video)
	// Y = 0.2126 R + 0.7152 G + 0.0722 B
	
	return r*0.2126f + g*0.7152f + b*0.0722f;
}

- (UInt32)rgbHex {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use rgbHex");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return 0;
	
	r = MIN(MAX(r, 0.0f), 1.0f);
	g = MIN(MAX(g, 0.0f), 1.0f);
	b = MIN(MAX(b, 0.0f), 1.0f);
	
	return (((int)roundf(r * 255)) << 16)
	     | (((int)roundf(g * 255)) << 8)
	     | (((int)roundf(b * 255)));
}

#pragma mark Arithmetic operations

- (UIColor *)colorByLuminanceMapping {
	return [UIColor colorWithWhite:self.luminance alpha:1.0f];
}

- (UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");

	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
		
	return [UIColor colorWithRed:MAX(0.0, MIN(1.0, r * red))
						   green:MAX(0.0, MIN(1.0, g * green)) 
							blue:MAX(0.0, MIN(1.0, b * blue))
						   alpha:MAX(0.0, MIN(1.0, a * alpha))];
}

- (UIColor *)colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [UIColor colorWithRed:MAX(0.0, MIN(1.0, r + red))
						   green:MAX(0.0, MIN(1.0, g + green)) 
							blue:MAX(0.0, MIN(1.0, b + blue))
						   alpha:MAX(0.0, MIN(1.0, a + alpha))];
}

- (UIColor *)colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
		
	return [UIColor colorWithRed:MAX(r, red)
						   green:MAX(g, green)
							blue:MAX(b, blue)
						   alpha:MAX(a, alpha)];
}

- (UIColor *)colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [UIColor colorWithRed:MIN(r, red)
						   green:MIN(g, green)
							blue:MIN(b, blue)
						   alpha:MIN(a, alpha)];
}

- (UIColor *)colorByMultiplyingBy:(CGFloat)f {
	return [self colorByMultiplyingByRed:f green:f blue:f alpha:1.0f];
}

- (UIColor *)colorByAdding:(CGFloat)f {
	return [self colorByMultiplyingByRed:f green:f blue:f alpha:0.0f];
}

- (UIColor *)colorByLighteningTo:(CGFloat)f {
	return [self colorByLighteningToRed:f green:f blue:f alpha:0.0f];
}

- (UIColor *)colorByDarkeningTo:(CGFloat)f {
	return [self colorByDarkeningToRed:f green:f blue:f alpha:1.0f];
}

- (UIColor *)colorByMultiplyingByColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [self colorByMultiplyingByRed:r green:g blue:b alpha:1.0f];
}

- (UIColor *)colorByAddingColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [self colorByAddingRed:r green:g blue:b alpha:0.0f];
}

- (UIColor *)colorByLighteningToColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
		
	return [self colorByLighteningToRed:r green:g blue:b alpha:0.0f];
}

- (UIColor *)colorByDarkeningToColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [self colorByDarkeningToRed:r green:g blue:b alpha:1.0f];
}

#pragma mark Complementary Colors, etc

// Pick a color that is likely to contrast well with this color
- (UIColor *)contrastingColor {
	return (self.luminance > 0.5f) ? [UIColor blackColor] : [UIColor whiteColor];
}

// Pick the color that is 180 degrees away in hue
- (UIColor *)complementaryColor {
	
	// Convert to HSB
	CGFloat h,s,v,a;
	if (![self hue:&h saturation:&s brightness:&v alpha:&a]) return nil;
		
	// Pick color 180 degrees away
	h += 180.0f;
	if (h > 360.f) h -= 360.0f;
	
	// Create a color in RGB
	return [UIColor colorWithHue:h saturation:s brightness:v alpha:a];
}

// Pick two colors more colors such that all three are equidistant on the color wheel
// (120 degrees and 240 degress difference in hue from self)
- (NSArray*)triadicColors {
	return [self analogousColorsWithStepAngle:120.0f pairCount:1];
}

// Pick n pairs of colors, stepping in increasing steps away from this color around the wheel
- (NSArray*)analogousColorsWithStepAngle:(CGFloat)stepAngle pairCount:(int)pairs {
	// Convert to HSB
	CGFloat h,s,v,a;
	if (![self hue:&h saturation:&s brightness:&v alpha:&a]) return nil;
	
	NSMutableArray* colors = [NSMutableArray arrayWithCapacity:pairs * 2];
	
	if (stepAngle < 0.0f)
		stepAngle *= -1.0f;
	
	for (int i = 1; i <= pairs; ++i) {
		CGFloat a = fmodf(stepAngle * i, 360.0f);
		
		CGFloat h1 = fmodf(h + a, 360.0f);
		CGFloat h2 = fmodf(h + 360.0f - a, 360.0f);
		
		[colors addObject:[UIColor colorWithHue:h1 saturation:s brightness:v alpha:a]];
		[colors addObject:[UIColor colorWithHue:h2 saturation:s brightness:v alpha:a]];
	}
	
	return [[colors copy] autorelease];
}

#pragma mark String utilities

- (NSString *)stringFromColor {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -stringFromColor");
	NSString *result;
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
			result = [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
			break;
		case kCGColorSpaceModelMonochrome:
			result = [NSString stringWithFormat:@"{%0.3f, %0.3f}", self.white, self.alpha];
			break;
		default:
			result = nil;
	}
	return result;
}

- (NSString *)hexStringFromColor {
	return [NSString stringWithFormat:@"%0.6X", self.rgbHex];
}

- (NSString *)closestColorNameFor: (const char *) aColorDatabase {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use closestColorName");
	
	int targetHex = self.rgbHex;
	int rInt = (targetHex >> 16) & 0x0ff;
	int gInt = (targetHex >> 8) & 0x0ff;
	int bInt = (targetHex >> 0) & 0x0ff;
	
	float bestScore = MAXFLOAT;
	const char* bestPos = nil;
	
	// Walk the name db string looking for the name with closest match
	for (const char* p = aColorDatabase; (p = strchr(p, '#')); ++p) {
		int r,g,b;
		if (sscanf(p+1, "%2x%2x%2x", &r, &g, &b) == 3) {
			// Calculate difference between this color and the target color
			int rDiff = abs(rInt - r);
			int gDiff = abs(gInt - g);
			int bDiff = abs(bInt - b);
			float score = logf(rDiff+1) + logf(gDiff+1) + logf(bDiff+1);
			
			// Track the best score/name seen
			if (score < bestScore) {
				bestScore = score;
				bestPos = p;
			}
		}
	}
	
	// bestPos now points to the # following the best name seen
	// Backup to the start of the name and return it
	const char* name;
	for (name = bestPos-1; *name != ','; --name)
		;
	++name;
	NSString *result = [[[NSString alloc] initWithBytes:name length:bestPos - name encoding:NSUTF8StringEncoding] autorelease];
	
	return result;
}


- (NSString *)closestColorName {
	return [self closestColorNameFor:colorNameDB];
}

- (NSString *)closestCrayonName {
	return [self closestColorNameFor:crayolaNameDB];
}

+ (UIColor *)colorWithString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	if (![scanner scanString:@"{" intoString:NULL]) return nil;
	const NSUInteger kMaxComponents = 4;
	CGFloat c[kMaxComponents];
	NSUInteger i = 0;
	if (![scanner scanFloat:&c[i++]]) return nil;
	while (1) {
		if ([scanner scanString:@"}" intoString:NULL]) break;
		if (i >= kMaxComponents) return nil;
		if ([scanner scanString:@"," intoString:NULL]) {
			if (![scanner scanFloat:&c[i++]]) return nil;
		} else {
			// either we're at the end of there's an unexpected character here
			// both cases are error conditions
			return nil;
		}
	}
	if (![scanner isAtEnd]) return nil;
	UIColor *color;
	switch (i) {
		case 2: // monochrome
			color = [UIColor colorWithWhite:c[0] alpha:c[1]];
			break;
		case 4: // RGB
			color = [UIColor colorWithRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
			break;
		default:
			color = nil;
	}
	return color;
}

#pragma mark Class methods

+ (UIColor *)randomColor {
	return [UIColor colorWithRed:random() / (CGFloat)RAND_MAX
						   green:random() / (CGFloat)RAND_MAX
							blue:random() / (CGFloat)RAND_MAX
						   alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [UIColor colorWithRGBHex:hexNum];
}

// Lookup a color using css 3/svg color name
+ (UIColor *)colorWithName:(NSString *)cssColorName {
	return [[UIColor namedColors] objectForKey:cssColorName];
}

// Lookup a color using a crayola name
+ (UIColor *)crayonWithName:(NSString *)crayolaColorName {
	return [[UIColor namedCrayons] objectForKey:crayolaColorName];
}

// Return complete mapping of css3/svg color names --> colors
+ (NSDictionary *)namedColors {
	[colorNameCacheLock lock];
	if (colorNameCache == nil) [UIColor populateColorNameCache];
	[colorNameCacheLock unlock];
	return colorNameCache;
}

+ (NSDictionary *)namedCrayons {
	[crayolaNameCacheLock lock];
	if (crayolaNameCache == nil) [UIColor populateCrayolaNameCache];
	[crayolaNameCacheLock unlock];
	return crayolaNameCache;
}

+ (UIColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha {
	// Convert hsb to rgb
	CGFloat r,g,b;
	[self hue:hue saturation:saturation brightness:brightness toRed:&r green:&g blue:&b];
	
	// Create a color with rgb
	return [self colorWithRed:r green:g blue:b alpha:alpha];
}


#pragma mark Color Space Conversions

+ (void)hue:(CGFloat)h saturation:(CGFloat)s brightness:(CGFloat)v toRed:(CGFloat *)pR green:(CGFloat *)pG blue:(CGFloat *)pB {
	CGFloat r,g,b;
	
	// From Foley and Van Dam
	
	if (s == 0.0f) {
		// Achromatic color: there is no hue
		r = g = b = v;
	} else {
		// Chromatic color: there is a hue
		if (h == 360.0f) h = 0.0f;
		h /= 60.0f;										// h is now in [0, 6)
		
		int i = floorf(h);								// largest integer <= h
		CGFloat f = h - i;								// fractional part of h
		CGFloat p = v * (1 - s);
		CGFloat q = v * (1 - (s * f));
		CGFloat t = v * (1 - (s * (1 - f)));
		
		switch (i) {
			case 0:	r = v; g = t; b = p;	break;
			case 1:	r = q; g = v; b = p;	break;
			case 2:	r = p; g = v; b = t;	break;
			case 3:	r = p; g = q; b = v;	break;
			case 4:	r = t; g = p; b = v;	break;
			case 5:	r = v; g = p; b = q;	break;
		}
	}
	
	if (pR) *pR = r;
	if (pG) *pG = g;
	if (pB) *pB = b;
}


+ (void)red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b toHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV {
	CGFloat h,s,v;
	
	// From Foley and Van Dam
	
	CGFloat max = MAX(r, MAX(g, b));
	CGFloat min = MIN(r, MIN(g, b));
	
	// Brightness
	v = max;
	
	// Saturation
	s = (max != 0.0f) ? ((max - min) / max) : 0.0f;
	
	if (s == 0.0f) {
		// No saturation, so undefined hue
		h = 0.0f;
	} else {
		// Determine hue
		CGFloat rc = (max - r) / (max - min);		// Distance of color from red
		CGFloat gc = (max - g) / (max - min);		// Distance of color from green
		CGFloat bc = (max - b) / (max - min);		// Distance of color from blue
		
		if (r == max) h = bc - gc;					// resulting color between yellow and magenta
		else if (g == max) h = 2 + rc - bc;			// resulting color between cyan and yellow
		else /* if (b == max) */ h = 4 + gc - rc;	// resulting color between magenta and cyan
		
		h *= 60.0f;									// Convert to degrees
		if (h < 0.0f) h += 360.0f;					// Make non-negative
	}
	
	if (pH) *pH = h;
	if (pS) *pS = s;
	if (pV) *pV = v;
}


#pragma mark UIColor_Expanded initialization

+ (void)load {
	colorNameCacheLock = [[NSLock alloc] init];
	crayolaNameCacheLock = [[NSLock alloc] init];
}

@end

#pragma mark -

#if SUPPORTS_UNDOCUMENTED_API
@implementation UIColor (UIColor_Undocumented_Expanded)
- (NSString *)fetchStyleString {
	return [self styleString];
}

// Convert a color into RGB Color space, courtesy of Poltras
// via http://ofcodeandmen.poltras.com/2009/01/22/convert-a-cgcolorref-to-another-cgcolorspaceref/
//
- (UIColor *)rgbColor {
	// Call to undocumented method "styleString".
	NSString *style = [self styleString];
	NSScanner *scanner = [NSScanner scannerWithString:style];
	CGFloat red, green, blue;
	if (![scanner scanString:@"rgb(" intoString:NULL]) return nil;
	if (![scanner scanFloat:&red]) return nil;
	if (![scanner scanString:@"," intoString:NULL]) return nil;
	if (![scanner scanFloat:&green]) return nil;
	if (![scanner scanString:@"," intoString:NULL]) return nil;
	if (![scanner scanFloat:&blue]) return nil;
	if (![scanner scanString:@")" intoString:NULL]) return nil;
	if (![scanner isAtEnd]) return nil;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:self.alpha];
}
@end
#endif // SUPPORTS_UNDOCUMENTED_API

@implementation UIColor (UIColor_Expanded_Support)
/*
 * Database of color names and hex rgb values, derived
 * from the css 3 color spec:
 *	http://www.w3.org/TR/css3-color/
 *
 * We think this is a very compact way of storing
 * this information, and relatively cheap to lookup.
 *
 * Note that we search for color names starting with ','
 * and terminated by '#', so that we don't get false matches.
 * For this reason, the database begins with ','.
 */
static const char *colorNameDB = ","
	"aliceblue#f0f8ff,antiquewhite#faebd7,aqua#00ffff,aquamarine#7fffd4,azure#f0ffff,"
	"beige#f5f5dc,bisque#ffe4c4,black#000000,blanchedalmond#ffebcd,blue#0000ff,"
	"blueviolet#8a2be2,brown#a52a2a,burlywood#deb887,cadetblue#5f9ea0,chartreuse#7fff00,"
	"chocolate#d2691e,coral#ff7f50,cornflowerblue#6495ed,cornsilk#fff8dc,crimson#dc143c,"
	"cyan#00ffff,darkblue#00008b,darkcyan#008b8b,darkgoldenrod#b8860b,darkgray#a9a9a9,"
	"darkgreen#006400,darkgrey#a9a9a9,darkkhaki#bdb76b,darkmagenta#8b008b,"
	"darkolivegreen#556b2f,darkorange#ff8c00,darkorchid#9932cc,darkred#8b0000,"
	"darksalmon#e9967a,darkseagreen#8fbc8f,darkslateblue#483d8b,darkslategray#2f4f4f,"
	"darkslategrey#2f4f4f,darkturquoise#00ced1,darkviolet#9400d3,deeppink#ff1493,"
	"deepskyblue#00bfff,dimgray#696969,dimgrey#696969,dodgerblue#1e90ff,"
	"firebrick#b22222,floralwhite#fffaf0,forestgreen#228b22,fuchsia#ff00ff,"
	"gainsboro#dcdcdc,ghostwhite#f8f8ff,gold#ffd700,goldenrod#daa520,gray#808080,"
	"green#008000,greenyellow#adff2f,grey#808080,honeydew#f0fff0,hotpink#ff69b4,"
	"indianred#cd5c5c,indigo#4b0082,ivory#fffff0,khaki#f0e68c,lavender#e6e6fa,"
	"lavenderblush#fff0f5,lawngreen#7cfc00,lemonchiffon#fffacd,lightblue#add8e6,"
	"lightcoral#f08080,lightcyan#e0ffff,lightgoldenrodyellow#fafad2,lightgray#d3d3d3,"
	"lightgreen#90ee90,lightgrey#d3d3d3,lightpink#ffb6c1,lightsalmon#ffa07a,"
	"lightseagreen#20b2aa,lightskyblue#87cefa,lightslategray#778899,"
	"lightslategrey#778899,lightsteelblue#b0c4de,lightyellow#ffffe0,lime#00ff00,"
	"limegreen#32cd32,linen#faf0e6,magenta#ff00ff,maroon#800000,mediumaquamarine#66cdaa,"
	"mediumblue#0000cd,mediumorchid#ba55d3,mediumpurple#9370db,mediumseagreen#3cb371,"
	"mediumslateblue#7b68ee,mediumspringgreen#00fa9a,mediumturquoise#48d1cc,"
	"mediumvioletred#c71585,midnightblue#191970,mintcream#f5fffa,mistyrose#ffe4e1,"
	"moccasin#ffe4b5,navajowhite#ffdead,navy#000080,oldlace#fdf5e6,olive#808000,"
	"olivedrab#6b8e23,orange#ffa500,orangered#ff4500,orchid#da70d6,palegoldenrod#eee8aa,"
	"palegreen#98fb98,paleturquoise#afeeee,palevioletred#db7093,papayawhip#ffefd5,"
	"peachpuff#ffdab9,peru#cd853f,pink#ffc0cb,plum#dda0dd,powderblue#b0e0e6,"
	"purple#800080,red#ff0000,rosybrown#bc8f8f,royalblue#4169e1,saddlebrown#8b4513,"
	"salmon#fa8072,sandybrown#f4a460,seagreen#2e8b57,seashell#fff5ee,sienna#a0522d,"
	"silver#c0c0c0,skyblue#87ceeb,slateblue#6a5acd,slategray#708090,slategrey#708090,"
	"snow#fffafa,springgreen#00ff7f,steelblue#4682b4,tan#d2b48c,teal#008080,"
	"thistle#d8bfd8,tomato#ff6347,turquoise#40e0d0,violet#ee82ee,wheat#f5deb3,"
	"white#ffffff,whitesmoke#f5f5f5,yellow#ffff00,yellowgreen#9acd32";

static const char *crayolaNameDB = ","
	"Almond#EED9C4,Antique Brass#C88A65,Apricot#FDD5B1,Aquamarine#71D9E2,Asparagus#7BA05B,"
	"Atomic Tangerine#FF9966,Banana Mania#FBE7B2,Beaver#926F5B,Bittersweet#FE6F5E,Black#000000,"
	"Blizzard Blue#A3E3ED,Blue#0066FF,Blue Bell#9999CC,Blue Green#0095B6,Blue Violet#6456B7,"
	"Brick Red#C62D42,Brink Pink#FB607F,Brown#AF593E,Burnt Orange#FF7034,Burnt Sienna#E97451,"
	"Cadet Blue#A9B2C3,Canary#FFFF99,Caribbean Green#00CC99,Carnation Pink#FFA6C9,Cerise#DA3287,"
	"Cerulean#02A4D3,Chartreuse#FF9966,Chestnut#B94E48,Copper#DA8A67,Cornflower#93CCEA,Cotton Candy#FFB7D5,"
	"Cranberry#DB5079,Dandelion#FED85D,Denim#1560BD,Desert Sand#EDC9AF,Eggplant#614051,Electric Lime#CCFF00,"
	"Fern#63B76C,Flesh#FFCBA4,Forest Green#5FA777,Fuchsia#C154C1,Fuzzy Wuzzy Brown#C45655,Gold#E6BE8A,Goldenrod#FCD667,"
	"Granny Smith Apple#9DE093,Gray#8B8680,Green#01A368,Green Yellow#F1E788,Happy Ever After#6CDA37,Hot Magenta#FF00CC,"
	"Inch Worm#B0E313,Indian Red#B94E48,Indigo#4F69C6,Jazzberry Jam#A50B5E,Jungle Green#29AB87,Laser Lemon#FFFF66,"
	"Lavender#FBAED2,Macaroni And Cheese#FFB97B,Magenta#F653A6,Magic Mint#AAF0D1,Mahogany#CA3435,Manatee#8D90A1,"
	"Mango Tango#E77200,Maroon#C32148,Mauvelous#F091A9,Melon#FEBAAD,Midnight Blue#003366,Mountain Meadow#1AB385,"
	"Mulberry#C54B8C,Navy Blue#0066CC,Neon Carrot#FF9933,Olive Green#B5B35C,Orange#FF681F,Orchid#E29CD2,Outer Space#2D383A,"
	"Outrageous Orange#FF6037,Pacific Blue#009DC4,Peach#FFCBA4,Periwinkle#C3CDE6,Pig Pink#FDD7E4,Pine Green#01796F,"
	"Pink Flamingo#FF66FF,Plum#843179,Prussian Blue#003366,Purple Heart#652DC1,Purple Mountain's Majesty#9678B6,"
	"Purple Pizzazz#FF00CC,Radical Red#FF355E,Raw Sienna#D27D46,Razzle Dazzle Rose#FF33CC,Razzmatazz#E30B5C,Red#ED0A3F,"
	"Red Orange#FF3F34,Red Violet#BB3385,Robin's Egg Blue#00CCCC,Royal Purple#6B3FA0,Salmon#FF91A4,Scarlet#FD0E35,"
	"Screamin' Green#66FF66,Sea Green#93DFB8,Sepia#9E5B40,Shadow#837050,Shamrock#33CC99,Shocking Pink#FF6FFF,Silver#C9C0BB,"
	"Sky Blue#76D7EA,Spring Green#ECEBBD,Sunglow#FFCC33,Sunset Orange#FE4C40,Tan#FA9D5A,Tickle Me Pink#FC80A5,Timberwolf#D9D6CF,"
	"Torch Red#FD0E35,Tropical Rain Forest#00755E,Tumbleweed#DEA681,Turquoise Blue#6CDAE7,Ultra Green#66FF66,Ultra Orange#FF6037,"
	"Ultra Pink#FF6FFF,Ultra Red#FD5B78,Ultra Yellow#FFFF66,Unmellow Yellow#FFFF66,Violet (purple)#8359A3,Violet Red#F7468A,"
	"Vivid Tangerine#FF9980,Vivid Violet#803790,White#FFFFFF,Wild Blue Yonder#7A89B8,Wild Strawberry#FF3399,Wild Watermelon#FD5B78,"
	"Wisteria#C9A0DC,Yellow#FBE870,Yellow Green#C5E17A,Yellow Orange#FFAE42";


+ (void)populateColorNameCache {
	NSAssert(colorNameCache == nil, @"+pouplateColorNameCache was called when colorNameCache was not nil");
	NSMutableDictionary *cache = [NSMutableDictionary dictionary];
	for (const char* entry = colorNameDB; entry = strchr(entry, ','); ) {
		
		// Step forward to the start of the name
		++entry;
		
		// Find the following hash
		const char* h = strchr(entry, '#');
		NSAssert(h, @"Malformed colorNameDB");
		
		// Get the name
		NSString* name = [[NSString alloc] initWithBytes:entry length:h - entry encoding:NSUTF8StringEncoding];
		
		// Get the color, and add to the dictionary
		int hex, increment;
		if (sscanf(++h, "%x%n", &hex, &increment) != 1) {[name release]; break;} // thanks Curtis Duhn
		[cache setObject:[self colorWithRGBHex:hex] forKey:name];
		
		// Cleanup and move to the next item
		[name release];
		entry = h + increment;
	}
	colorNameCache = [cache copy];
}

+ (void)populateCrayolaNameCache {
	NSAssert(crayolaNameCache == nil, @"+pouplateCrayolaNameCache was called when crayolaNameCache was not nil");
	NSMutableDictionary *cache = [NSMutableDictionary dictionary];
	for (const char* entry = crayolaNameDB; entry = strchr(entry, ','); ) {
		
		// Step forward to the start of the name
		++entry;
		
		// Find the following hash
		const char* h = strchr(entry, '#');
		NSAssert(h, @"Malformed crayolaNameDB");
		
		// Get the name
		NSString* name = [[NSString alloc] initWithBytes:entry length:h - entry encoding:NSUTF8StringEncoding];
		
		// Get the color, and add to the dictionary
		int hex, increment;
		if (sscanf(++h, "%x%n", &hex, &increment) != 1) {[name release]; break;} // thanks Curtis Duhn
		[cache setObject:[self colorWithRGBHex:hex] forKey:name];
		
		// Cleanup and move to the next item
		[name release];
		entry = h + increment;
	}
	crayolaNameCache = [cache copy];
}
@end
