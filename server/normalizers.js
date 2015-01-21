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
	*	name:	[String]	The type of amended section. For example: "article", "titre", "chapitre"…
	*	raw:	[String]	The original, XML-provided "place" value, in case these parsers fail.
	*/
	place: function normalizePlace(place) {
		return Number(place.split('/')[0]);
	},
}
