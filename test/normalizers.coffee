describe 'Normalizers', ->
	describe 'position()', ->
		it 'should transform the String to a Number', (test) ->
			test.equal Normalizers.position("0002/1731"), 2

	describe 'place()', ->
		KEYS = [ 'article', 'placement', 'type', 'raw' ]

		describe 'with an article reference', ->
			TESTS =
				'Article PREMIER':
					article: 1
				'Article 2':
					article: 2
				"Avant l'article 23":
					article: 23
					placement: AssembleeNationale.BEFORE
				"Article 33 septiès":
					article: 33
				"Après l'article 47":
					article: 47
					placement: AssembleeNationale.AFTER
				"Article 52 B":
					article: 52
				"Après l'article 53 C":
					article: 53
					placement: AssembleeNationale.AFTER

			_.each TESTS, (expected, source) ->
				describe "#{source}", (test) ->
					expected.type = 'article'
					expected.raw = source
					actual = Normalizers.place source

					KEYS.forEach (key) ->
						it "should properly set #{key}", (test) ->
							test.equal actual[key], expected[key]

		describe 'with a chapter reference', ->
			actual = Normalizers.place 'Chapitre IV'

			expected =
				type: 'chapitre'
				raw: 'Chapitre IV'

			KEYS.forEach (key) ->
				it "should properly set #{key}", (test) ->
					test.equal actual[key], expected[key]

		describe 'with a title reference', ->
			actual = Normalizers.place 'Titre'

			expected =
				type: 'titre'
				raw: 'Titre'

			KEYS.forEach (key) ->
				it "should properly set #{key}", (test) ->
					test.equal actual[key], expected[key]

