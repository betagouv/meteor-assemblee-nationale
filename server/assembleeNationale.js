var xml2js = Npm.require('xml2js');


AssembleeNationale = {};

/**
*@param	{Number}	legislature	Numéro de la législature.
*@param	{String}	textId	Numéro du texte codé sur 4 caractères + suffixe :
*	- ''  : texte hors PLF, première délibération
*	- 'S' : texte hors PLF, seconde délibération
*	- 'A' : PLF, première partie, première délibération
*	- 'B' : PLF, première partie, seconde délibération
*	- 'C' : PLF, deuxième partie, première délibération
*	- 'D' : PLF, deuxième partie, seconde délibération
*@param	{String}	organismId	Abréviation tribun de l’organe examinant :
*	- organe de type Assemblée nationale : AN
*	- organe de type commission permanente législative :
*		- Défense	'CION_DEF'
*		- Affaires étrangères	'CION_AFETR'
*		- Finances	'CION_FIN'
*		- Lois	'CION_LOIS'
*		- Affaires culturelles et éducation	'CION-CEDU'
*		- Affaires économiques	'CION-ECO'
*		- Développement durable	 'CION-DVP'
*		- Affaires sociales	'CION-SOC'
*	- organe de type commission spéciale :	'CION_SPE'
*/
AssembleeNationale.getAmendementsURL = function(textId, organismId, legislature) {
	if (! textId)
		throw new ReferenceError('You need to specify a text number.');

	organismId = organismId || 'AN';
	legislature = legislature || 14;	// unless unexpected surprise, will be 14 from 2012 to 2017

	return [ 'http://www.assemblee-nationale.fr', legislature, 'amendements', textId, organismId, 'liste.xml' ].join('/');
}

AssembleeNationale.getAmendementsXML = function(textId, organismId, legislature, callback) {
	HTTP.get(AssembleeNationale.getAmendementsURL(textId, organismId, legislature), { timeout: 20 * 1000 }, callback);
}

AssembleeNationale.getAmendements = function(textId, organismId, legislature, callback) {
	AssembleeNationale.getAmendementsXML(textId, organismId, legislature, function(error, result) {
		if (error)
			return callback(error);

		xml2js.parseString(result.content, callback);
	});
}
