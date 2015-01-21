/**
*@private
*/
function parsePlacePart(part) {
	part = part.toLowerCase();

	if (Number(part) > 0)
		return { article: Number(part) };
	if (part == 'avant')
		return { placement: AssembleeNationale.BEFORE };
	if (part == 'après')
		return { placement: AssembleeNationale.AFTER };
	if (part == 'premier')
		return { article: 1 };

	return { type: part.replace("l'", '') };
}


/**A collection of helper functions for each field imported from the Assemblée Nationale XML.
*/
Normalizers = {
	/** The index at which this amendment will be examined.
	*
	*@param	{String}	position	Of type '0001/1737'.
	*@returns	{Number}	The position, as a number.
	*/
	position: function normalizePosition(position) {
		return Number(position.split('/')[0]);
	},

	/** The place in the original text which this amendment amends.
	*
	*@param	{String}	article	Of type 'Article PREMIER', or 'Après l'article 2', or 'Titre', or…
	*@returns	{Object<String, ?>}	A descriptor with the following keys and values:
	*	article:	[Number]	If defined, the number of the amended article. If not defined, the amendment does not refer to an article.
	*	placement:	[Symbol]	If defined, may be one of AssembleeNationale.BEFORE or AssembleeNationale.AFTER. If not defined, then the article itself is amended. The actual type is not Symbol in ES<6, but you must rely on constants and not on Number values.
	*	type:	[String]	The type of amended section. For example: "article", "titre", "chapitre"…
	*	raw:	[String]	The original, XML-provided "place" value, in case these parsers fail.
	*/
	place: function normalizePlace(place) {
		return place.split(' ').reduce(function(result, part) {
			var parsedProperties = parsePlacePart(part);

			for (var parsedProperty in parsedProperties)
				result[parsedProperty] = result[parsedProperty] || parsedProperties[parsedProperty];	// do not allow overrides: the first words are less ambiguous

			return result;
		}, { raw: place });
	}
}
