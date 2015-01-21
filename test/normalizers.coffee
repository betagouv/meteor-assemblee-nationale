describe 'Normalizers', ->
	describe 'position()', ->
		it 'should transform the String to a Number', (test) ->
			test.equal Normalizers.position("0002/1731"), 2

	describe 'place()', ->
		KEYS = [ 'article', 'placement', 'name', 'raw' ]

		describe 'with an article reference', ->
			TESTS =
				'Article PREMIER':
					article: 1
				'Article 2':
					article: 2
				"Avant l'article 23":
					article: 23
					placement: AssembleeNationale.BEFORE
				"Après l'article 47":
					article: 47
					placement: AssembleeNationale.AFTER

			_.each TESTS, (expected, source) ->
				describe "#{source}", (test) ->
					expected.name = 'article'
					expected.raw = source
					actual = Normalizers.place source

					KEYS.forEach (key) ->
						it "should properly set #{key}", (test) ->
							test.equal actual[key], expected[key]

		describe 'with a chapter reference', ->
			actual = Normalizers.place 'Chapitre IV'

			expected =
				name: 'chapitre'
				raw: 'Chapitre IV'

			KEYS.forEach (key) ->
				it "should properly set #{key}", (test) ->
					test.equal actual[key], expected[key]
