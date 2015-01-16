TEST_TEXTID = '2447'
TEST_ORGANISMID = 'CSCRACTIV'
TEST_LEGISLATURE = '14'


describe 'AssembleeNationale', ->
	FIRST_AMENDEMENT = {
		"place": "Article PREMIER",
		"numero": "SPE862",
		"sort": "Adopté",
		"parentNumero": "",
		"auteurLabel": "M. PANCHER",
		"auteurLabelFull": "M. PANCHER Bertrand",
		"auteurGroupe": "UDI",
		"alineaLabel": "av 1",
		"missionLabel": "",
		"discussionCommune": "",
		"discussionCommuneAmdtPositon": "",
		"discussionCommuneSsAmdtPositon": "",
		"discussionIdentique": "",
		"discussionIdentiqueAmdtPositon": "",
		"discussionIdentiqueSsAmdtPositon": "",
		"position": "0001/1731"
	}

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

	describe 'getAmendementsJSON', ->
		it 'should properly parse XML', (test, done) ->
			AssembleeNationale.getAmendementsJSON TEST_TEXTID, TEST_ORGANISMID, TEST_LEGISLATURE, (error, result) ->
				test.isNull error
				test.isNotNull result
				test.isNotNull result.amdtsParOrdreDeDiscussion
				test.isNotNull result.amdtsParOrdreDeDiscussion.$
				test.equal result.amdtsParOrdreDeDiscussion.$.bibard, TEST_TEXTID
				test.equal result.amdtsParOrdreDeDiscussion.$.organe, TEST_ORGANISMID
				test.equal result.amdtsParOrdreDeDiscussion.$.legislature, TEST_LEGISLATURE
				done()

	describe 'normalizeAmendements', ->
		SOURCE = {
			"amdtsParOrdreDeDiscussion": {
				"$": {
					"bibard": "2447",
					"bibardSuffixe": "",
					"organe": "CSCRACTIV",
					"legislature": "14",
					"titre": "La croissance et l'activité",
					"type": "projet de loi"
				},
				"amendements": [
					{
						"amendement": [
							{
								"$": FIRST_AMENDEMENT
							},
							{
								"$": {
									"place": "Article PREMIER",
									"numero": "SPE1263",
									"sort": "Rejeté",
									"parentNumero": "",
									"auteurLabel": "M. GIRAUD",
									"auteurLabelFull": "M. GIRAUD Joël",
									"auteurGroupe": "RRDP",
									"alineaLabel": "av 1",
									"missionLabel": "",
									"discussionCommune": "",
									"discussionCommuneAmdtPositon": "",
									"discussionCommuneSsAmdtPositon": "",
									"discussionIdentique": "",
									"discussionIdentiqueAmdtPositon": "",
									"discussionIdentiqueSsAmdtPositon": "",
									"position": "0002/1731"
								}
							}
						]
					}
				]
			}
		}

		it 'should properly unwrap amendements', (test) ->
			actual = AssembleeNationale.normalizeAmendements SOURCE

			expected = JSON.parse JSON.stringify FIRST_AMENDEMENT	# copy
			expected.position = 1

			test.instanceOf actual, Array
			test.length actual, 2
			test.equal actual[0], expected

	describe 'getAmendements', ->
		it 'should properly fetch and present amendements', (test, done) ->
			AssembleeNationale.getAmendements TEST_TEXTID, TEST_ORGANISMID, TEST_LEGISLATURE, (error, result) ->
				test.isNull error
				test.equal Object.keys(result[0]), Object.keys(FIRST_AMENDEMENT)	# we don't compare values as they are subject to change
				done()
