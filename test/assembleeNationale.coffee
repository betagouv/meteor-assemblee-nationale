TEST_TEXTID = '2447'
TEST_ORGANISMID = 'CSCRACTIV'
TEST_LEGISLATURE = '14'


describe 'AssembleeNationale', ->
	describe 'getAmendementsURL()', ->
		it 'should throw if no textId is given', (test) ->
			test.throws(AssembleeNationale.getAmendementsURL)

		it 'should properly construct an amendments list URL', (test) ->
			actual = AssembleeNationale.getAmendementsURL TEST_TEXTID, TEST_ORGANISMID, TEST_LEGISLATURE

			test.equal actual, 'http://www.assemblee-nationale.fr/14/amendements/2447/CSCRACTIV/liste.xml'

	describe 'getAmendementsXML', ->
		it 'should properly fetch XML', (test, done) ->
			AssembleeNationale.getAmendementsXML TEST_TEXTID, TEST_ORGANISMID, TEST_LEGISLATURE, (error, result) ->
				test.isNull error
				test.notEqual result.content.indexOf('<?xml version="1.0" encoding="UTF-8"?>'), -1
				test.notEqual result.content.indexOf('<amdtsParOrdreDeDiscussion  bibard="' + TEST_TEXTID + '"  bibardSuffixe=""  organe="' + TEST_ORGANISMID + '"  legislature="' + TEST_LEGISLATURE + '"'), -1
				done()

	describe 'getAmendements', ->
		it 'should properly parse XML', (test, done) ->
			AssembleeNationale.getAmendements TEST_TEXTID, TEST_ORGANISMID, TEST_LEGISLATURE, (error, result) ->
				test.isNull error
				test.isNotNull result
				test.isNotNull result.amdtsParOrdreDeDiscussion
				test.isNotNull result.amdtsParOrdreDeDiscussion.$
				test.equal result.amdtsParOrdreDeDiscussion.$.bibard, TEST_TEXTID
				test.equal result.amdtsParOrdreDeDiscussion.$.organe, TEST_ORGANISMID
				test.equal result.amdtsParOrdreDeDiscussion.$.legislature, TEST_LEGISLATURE
				done()


