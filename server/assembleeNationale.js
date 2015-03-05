var xml2js = Npm.require('xml2js');


AssembleeNationale = {
	/** Defines placement for article-related amendments.
	*
	*@constant
	*@see	Normalizers.place
	*/
	BEFORE	: -1,	// Symbol, do NOT rely on this value

	/** Defines placement for article-related amendments
	*
	*@constant
	*@see	Normalizers.place
	*/
	AFTER	: 1,	// Symbol, do NOT rely on this value


	/** Retrieve and normalize all amendments from the given law project.
	*
	*@param	{String}	textId	Project law number.
	*@param	{String}	organismId	Identifier of the legislative organism in charge of examining the law project.
	*@param	{Number}	legislature	Legislature number.
	*@param	{Function<Error|null,Array<Object>>}	A callback that will be passed the normalized amendments as a second argument or, if an error occurred, this error as a first argument.
	*/
	getAmendements: function getAmendements(textId, organismId, legislature, callback) {
		AssembleeNationale.getAmendementsJSON(textId, organismId, legislature, function(error, result) {
			if (error)
				return callback(error);

			callback(null, AssembleeNationale.normalizeAmendements(result));
		});
	},

	/** Construct the URL to the XML amendments list based on the given law project identifiers.
	*
	*@param	{String}	textId	Project law number.
	*@param	{String}	[organismId = 'AN']	Identifier of the legislative organism in charge of examining the law project.
	*@param	{Number}	[legislature = 14]	Legislature number.
	*@returns	{String}	The URL to the XML file listing all amendments for the given law project.
	*/
	getAmendementsURL: function getAmendementsURL(textId, organismId, legislature) {
		if (! textId)
			throw new ReferenceError('You need to specify a text number.');

		organismId = organismId || 'AN';
		legislature = legislature || 14;	// unless the Assembly is dissolved, will be 14 from 2012 to 2017

		return [ 'http://www.assemblee-nationale.fr', legislature, 'amendements', textId, organismId, 'liste.xml' ].join('/');
	},

	/** Retrieve the XML file listing all amendments for the given law project.
	*
	*@see	getAmendementsURL
	*@private
	*/
	getAmendementsXML: function getAmendementsXML(textId, organismId, legislature, callback) {
		HTTP.get(AssembleeNationale.getAmendementsURL(textId, organismId, legislature), { timeout: 20 * 1000 }, callback);
	},

	/** Retrieve the XML file listing all amendments for the given law project and convert it to JSON.
	*
	*@see	getAmendementsURL
	*@private
	*/
	getAmendementsJSON: function getAmendementsJSON(textId, organismId, legislature, callback) {
		AssembleeNationale.getAmendementsXML(textId, organismId, legislature, function(error, result) {
			if (error)
				return callback(error);

			xml2js.parseString(result.content, callback);
		});
	},

	/** Normalize raw amendments file to an array of amendments descriptions, sorted by order of examination.
	*
	*@param	{Array<Object<String,String>>}
	*@returns	{Array<Object>}	A list of all passed amendments, normalized by calling all functions in Normalizers on the matching property.
	*@see	Normalizers
	*@private
	*/
	normalizeAmendements: function normalizeAmendements(data) {
		return data.amdtsParOrdreDeDiscussion.amendements[0].amendement.map(function(amendementWrapper) {
			var result = amendementWrapper['$'];

			for (var propertyToNormalize in Normalizers)
				result[propertyToNormalize] = Normalizers[propertyToNormalize](result[propertyToNormalize]);

			return result;
		});
	}
}
