//
//  ATUtilitiesTests.m
//  ApptentiveConnect
//
//  Created by Andrew Wooster on 4/15/11.
//  Copyright 2011 Apptentive, Inc.. All rights reserved.
//

#import "ATUtilitiesTests.h"


@implementation ATUtilitiesTests
- (void)testEvenRect {
	CGRect testRect1 = CGRectMake(0.0, 0.0, 17.0, 21.0);
	CGRect result1 = ATCGRectOfEvenSize(testRect1);
	XCTAssertEqual(result1.size.width, (CGFloat)18.0, @"");
	XCTAssertEqual(result1.size.height, (CGFloat)22.0, @"");

	CGRect testRect2 = CGRectMake(0.0, 0.0, 18.0, 22.0);
	CGRect result2 = ATCGRectOfEvenSize(testRect2);
	XCTAssertEqual(result2.size.width, (CGFloat)18.0, @"");
	XCTAssertEqual(result2.size.height, (CGFloat)22.0, @"");
}

- (void)testVersionComparisons {
	XCTAssertTrue([ATUtilities versionString:@"6.0" isEqualToVersionString:@"6.0"], @"Should be same");
	XCTAssertTrue([ATUtilities versionString:@"0.0" isEqualToVersionString:@"0.0"], @"Should be same");
	XCTAssertTrue([ATUtilities versionString:@"6.0.1" isEqualToVersionString:@"6.0.1"], @"Should be same");
	XCTAssertTrue([ATUtilities versionString:@"0.0.1" isEqualToVersionString:@"0.0.1"], @"Should be same");
	XCTAssertTrue([ATUtilities versionString:@"10.10.1" isEqualToVersionString:@"10.10.1"], @"Should be same");

	XCTAssertTrue([ATUtilities versionString:@"10.10.1" isGreaterThanVersionString:@"10.10.0"], @"Should be greater");
	XCTAssertTrue([ATUtilities versionString:@"6.0" isGreaterThanVersionString:@"5.0.1"], @"Should be greater");
	XCTAssertTrue([ATUtilities versionString:@"6.0" isGreaterThanVersionString:@"5.1"], @"Should be greater");

	XCTAssertTrue([ATUtilities versionString:@"5.0" isLessThanVersionString:@"5.1"], @"Should be less");
	XCTAssertTrue([ATUtilities versionString:@"5.0" isLessThanVersionString:@"6.0.1"], @"Should be less");
}

- (void)testComplexVersionComparisons {
	NSArray *versions = @[
		@[@"", @"=", @""],
		@[@" ", @"=", @" "],
		@[@"1.0.0.0", @"=", @"1"],
		@[@"1.0.0.0", @"=", @"1.0"],
		@[@"1.0.0.0", @"=", @"1.0.0"],
		@[@"1.0.0.0", @"=", @"1.0.0.0"],
		@[@"1.0.0", @"=", @"1.0.0.0"],
		@[@"1.0.", @"=", @"1.0.0.0"],
		@[@"1", @"=", @"1.0.0.0"],
		@[@"1.00", @"=", @"1.00.00.00"],
		@[@"1.01", @"=", @"1.1"],
		@[@"1.11.111.1111", @"=", @"1.11.111.1111"],
		@[@"1.2.3.4", @"=", @"1.2.3.4"],
		@[@"1.2.3.4", @"<", @"1.2.3.5"],
		@[@"1.2.3", @"<", @"1.2.4"],
		@[@"1.2", @"<", @"1.3"],
		@[@"1", @"<", @"2"],
		@[@"1.2.3.5", @">", @"1.2.3.4"],
		@[@"1.2.4", @">", @"1.2.3"],
		@[@"1.3", @">", @"1.2"],
		@[@"2", @">", @"1"],
		@[@"0", @"=", @"0"],
		@[@"0", @"=", @"0.0"],
		@[@"0", @"=", @"0.0.0"],
		@[@"0", @"=", @"0.0.0.0"],
		@[@"1", @"=", @"01.0.0.0"],
		@[@"0", @"<", @"0.0.0.1"],
		@[@"0", @"<", @"0.0.0.1"],
		@[@"0", @"<", @"1"],
		@[@"0", @"<", @"1"],
		@[@"0", @"=", @"0"],
		@[@"1", @"=", @"1"],
		@[@"1", @">", @"0"],
		@[@"0.0.0.1", @">", @"0"]
	];
	for (NSArray *versionCheck in versions) {
		NSString *left = versionCheck[0];
		NSString *compare = versionCheck[1];
		NSString *right = versionCheck[2];
		if ([compare isEqualToString:@"="]) {
			XCTAssertTrue([ATUtilities versionString:left isEqualToVersionString:right], @"%@ not equal to %@", left, right);
		} else if ([compare isEqualToString:@">"]) {
			XCTAssertTrue([ATUtilities versionString:left isGreaterThanVersionString:right], @"%@ not greater than %@", left, right);
		} else if ([compare isEqualToString:@"<"]) {
			XCTAssertTrue([ATUtilities versionString:left isLessThanVersionString:right], @"%@ not less than %@", left, right);
		}
	}
}

- (void)testCacheControlParsing {
	XCTAssertEqual(0., [ATUtilities maxAgeFromCacheControlHeader:nil], @"Should be same");
	XCTAssertEqual(0., [ATUtilities maxAgeFromCacheControlHeader:@""], @"Should be same");
	XCTAssertEqual(86400., [ATUtilities maxAgeFromCacheControlHeader:@"Cache-Control: max-age=86400, private"], @"Should be same");
	XCTAssertEqual(86400., [ATUtilities maxAgeFromCacheControlHeader:@"max-age=86400, private"], @"Should be same");
	XCTAssertEqual(47.47, [ATUtilities maxAgeFromCacheControlHeader:@"max-age=47.47, private"], @"Should be same");
	XCTAssertEqual(0., [ATUtilities maxAgeFromCacheControlHeader:@"max-age=0, private"], @"Should be same");
}


- (void)testDictionaryEquality {
	NSDictionary *a = nil;
	NSDictionary *b = nil;

	XCTAssertTrue([ATUtilities dictionary:a isEqualToDictionary:b], @"Dictionaries should be equal: %@ v %@", a, b);

	a = @{};
	XCTAssertFalse([ATUtilities dictionary:a isEqualToDictionary:b], @"Dictionaries should not be equal: %@ v %@", a, b);

	a = nil;
	b = @{};
	XCTAssertFalse([ATUtilities dictionary:a isEqualToDictionary:b], @"Dictionaries should not be equal: %@ v %@", a, b);

	a = @{};
	b = @{};
	XCTAssertTrue([ATUtilities dictionary:a isEqualToDictionary:b], @"Dictionaries should be equal: %@ v %@", a, b);

	a = @{ @"foo": @"bar" };
	b = @{ @"foo": @"bar" };
	XCTAssertTrue([ATUtilities dictionary:a isEqualToDictionary:b], @"Dictionaries should be equal: %@ v %@", a, b);

	a = @{ @"foo": @[@1, @2, @3] };
	b = @{ @"foo": @[@1, @2, @4] };
	XCTAssertFalse([ATUtilities dictionary:a isEqualToDictionary:b], @"Dictionaries should not be equal: %@ v %@", a, b);

	a = @{ @"foo": @[@1, @2, @{@"bar": @"yarg"}] };
	b = @{ @"foo": @[@1, @2, @{@"narf": @"fran"}] };
	XCTAssertFalse([ATUtilities dictionary:a isEqualToDictionary:b], @"Dictionaries should not be equal: %@ v %@", a, b);

	a = @{ @"foo": @[@1, @2, @{@"bar": @"yarg"}] };
	b = @{ @"foo": @[@1, @2, @{@"bar": @"yarg"}] };
	XCTAssertTrue([ATUtilities dictionary:a isEqualToDictionary:b], @"Dictionaries should be equal: %@ v %@", a, b);
}

- (void)testEmailValidation {
	XCTAssertTrue([ATUtilities emailAddressIsValid:@"andrew@example.com"], @"Should be valid");
	XCTAssertTrue([ATUtilities emailAddressIsValid:@" andrew+spam@foo.md "], @"Should be valid");
	XCTAssertTrue([ATUtilities emailAddressIsValid:@"a_blah@a.co.uk"], @"Should be valid");
	XCTAssertTrue([ATUtilities emailAddressIsValid:@"☃@☃.net"], @"Snowman! Valid!");
	XCTAssertTrue([ATUtilities emailAddressIsValid:@"andrew@example.com"], @"Should be valid");
	//	XCTAssertTrue([ATUtilities emailAddressIsValid:@" foo@bar.com yarg@blah.com"], @"May as well accept multiple");
	//	XCTAssertTrue([ATUtilities emailAddressIsValid:@"Andrew Wooster <andrew@example.com>"], @"Accept contact emails");
	XCTAssertTrue([ATUtilities emailAddressIsValid:@"foo/bar=blah@example.com"], @"Accept department emails");
	XCTAssertTrue([ATUtilities emailAddressIsValid:@"!hi!%blah@example.com"], @"Should be valid");
	XCTAssertTrue([ATUtilities emailAddressIsValid:@"m@example.com"], @"Should be valid");

	XCTAssertFalse([ATUtilities emailAddressIsValid:@"blah"], @"Shouldn't be valid");
	//	XCTAssertFalse([ATUtilities emailAddressIsValid:@"andrew@example,com"], @"Shouldn't be valid");
	XCTAssertFalse([ATUtilities emailAddressIsValid:@""], @"Shouldn't be valid");
	XCTAssertFalse([ATUtilities emailAddressIsValid:@"@"], @"Shouldn't be valid");
	XCTAssertFalse([ATUtilities emailAddressIsValid:@".com"], @"Shouldn't be valid");
	XCTAssertFalse([ATUtilities emailAddressIsValid:@"\n"], @"Shouldn't be valid");
	//	XCTAssertFalse([ATUtilities emailAddressIsValid:@"foo@yarg"], @"Shouldn't be valid");
	XCTAssertFalse([ATUtilities emailAddressIsValid:@""], @"empty string email shouldn't be valid");
	XCTAssertFalse([ATUtilities emailAddressIsValid:nil], @"nil email shouldn't be valid");
}

- (void)testStringEscaping {
	NSString *aString = @"foo% bar/#haha";
	NSString *result = [ATUtilities stringByEscapingForURLArguments:aString];
	XCTAssertEqualObjects(@"foo%25%20bar%2F%23haha", result, @"Unexpected result: %@", result);
}

// The JSON blobs loaded here should be identical to those for the Android SDK.
- (NSDictionary *)loadJSONBlobsWithNames:(NSArray *)names {
	NSMutableDictionary *result = [NSMutableDictionary dictionary];

	for (NSString *name in names) {
		NSString *fullName = [NSString stringWithFormat:@"testJsonDiffing.%@", name];
		NSURL *JSONURL = [[NSBundle bundleForClass:[self class]] URLForResource:fullName withExtension:@"json"];
		NSData *JSONData = [NSData dataWithContentsOfURL:JSONURL];
		NSError *error = nil;
		NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
		XCTAssertNotNil(dictionary, @"Error parsing JSON: %@", error);
		result[name] = dictionary;
	}

	return result;
}

- (void)testDictionaryDiff1 {
	NSDictionary *JSONBlobs = [self loadJSONBlobsWithNames:@[@"1.new", @"1.old", @"1.expected"]];

	NSDictionary *result = [ATUtilities diffDictionary:JSONBlobs[@"1.new"] againstDictionary:JSONBlobs[@"1.old"]];

	XCTAssertEqualObjects(result, JSONBlobs[@"1.expected"]);
}

- (void)testDictionaryDiff2 {
	NSDictionary *JSONBlobs = [self loadJSONBlobsWithNames:@[@"2.new", @"2.old"]];

	NSDictionary *result = [ATUtilities diffDictionary:JSONBlobs[@"2.new"] againstDictionary:JSONBlobs[@"2.old"]];

	XCTAssertEqualObjects(result, @{});
}

- (void)testDictionaryDiff4 {
	NSDictionary *oldPerson = nil;
	NSDictionary *newPerson = @{ @"custom_data": @{@"pet_name": @"Sumo"} };
	;

	NSDictionary *result = [ATUtilities diffDictionary:newPerson againstDictionary:oldPerson];

	XCTAssertEqualObjects(result, newPerson);
}

@end
