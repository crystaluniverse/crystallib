module texttools

fn test_tokens() {
	mut text := '
	these; Are Some ramdom words!
	blue lagoon
	Blue lagoon
	blue_lagoon
	blue_Lagoon
	lagoon
    blueLagoon
	&redlagoon

	'
	r := tokenize(text)
	println(r)

	r2 := TokenizerResult{
		items: [TokenizerItem{
			toreplace: 'ramdom'
			matchstring: 'ramdom'
		}, TokenizerItem{
			toreplace: 'words'
			matchstring: 'words'
		}, TokenizerItem{
			toreplace: 'blue'
			matchstring: 'blue'
		}, TokenizerItem{
			toreplace: 'lagoon'
			matchstring: 'lagoon'
		}, TokenizerItem{
			toreplace: 'Blue'
			matchstring: 'blue'
		}, TokenizerItem{
			toreplace: 'blue_lagoon'
			matchstring: 'bluelagoon'
		}, TokenizerItem{
			toreplace: 'blue_Lagoon'
			matchstring: 'bluelagoon'
		}, TokenizerItem{
			toreplace: 'blueLagoon'
			matchstring: 'bluelagoon'
		}]
	}

	assert r == r2
}

fn test_tokens2() {
	mut text := '
	these; Are Some ramdom words!
	blue lagoon
	Blue lagoon
	red_dragon
	reddragon
	blue_lagoon
	blue_Lagoon
	lagoon
	;bluelagoon

	'

	mut ri := regex_instructions_new()
	ri.add(['bluelagoon:red_dragon:ThreeFold']) or { panic(err) }

	mut text_out2 := ri.replace(text) or { panic(err) }

	compare := '
	these; Are Some ramdom words!
	blue lagoon
	Blue lagoon
	ThreeFold
	ThreeFold
	ThreeFold
	ThreeFold
	lagoon
	;ThreeFold

	'

	println(text_out2)

	assert dedent(text_out2).trim(' \n') == dedent(compare).trim(' \n')
}

fn test_tokens3() {
	mut text := '
    - [Definitions](tftech:definitions)
    (koekoe)
    (great )
        {great }
    - [Disclaimer](disclaimer)
    - [farmer_terms_conditions](terms_conditions_farmer)
    - [terms_conditions_websites](terms_conditions_websites) test
    - [terms_conditions_griduser](terms_conditions_griduser)
    - [privacypolicy](privacypolicy)

    http://localhost:9998/threefold/#/farming_certification
    https://greencloud

	'

	r := tokenize(text)
	println(r)

	assert r == TokenizerResult{
		items: [TokenizerItem{
			toreplace: 'test'
			matchstring: 'test'
		}]
	}

	// panic('s')
}
