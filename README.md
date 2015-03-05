# Assemblée Nationale Meteor package

Get amendment data from the French National Assembly in Meteor

> Accéder à des données d'amendements de l'Assemblée Nationale depuis Meteor.


## Usage

	meteor add sgmap:assemblee-nationale

Then, on the server, you get access to a global `AssembleeNationale` namespace, which gives you the ability to asynchronously retrieve an array of amendments descriptions based on a law project identifier with the following function call:

```javascript
AssembleeNationale.getAmendements(textId, organismId, legislature, callback);
```

Your callback will be called with two parameters: an error or null if none occurred, and an array containing [amendment descriptions](#amendments-descriptions), sorted by examination order.


### Identifying a project law

A law project is identified by the combination of three codes.


#### textId

The identifier for the text itself (_“numéro du texte”_). This identifier is coded on four characters that are arbitrarily attributed by the Assembly, and an optional fifth according to the following rules (in French):

- `''` : texte hors Projet de Loi de Finances, première délibération
- `'S'` : texte hors Projet de Loi de Finances, seconde délibération
- `'A'` : Projet de Loi de Finances, première partie, première délibération
- `'B'` : Projet de Loi de Finances, première partie, seconde délibération
- `'C'` : Projet de Loi de Finances, deuxième partie, première délibération
- `'D'` : Projet de Loi de Finances, deuxième partie, seconde délibération

**Example**: the first Macron law project text identifier is `2447`.


#### organismId

The identifier of the legislative organism in charge of examining the law project (_“abréviation tribun de l’organe examinant”_). This identifier is usually one of the following (in French), but the Assembly may name special commissions, and we can't predict these names…

- organe de type Assemblée Nationale : `'AN'`
- organe de type commission permanente législative :
	- Défense : `'CION_DEF'`
	- Affaires étrangères : `'CION_AFETR'`
	- Finances : `'CION_FIN'`
	- Lois : `'CION_LOIS'`
	- Affaires culturelles et éducation : `'CION-CEDU'`
	- Affaires économiques : `'CION-ECO'`
	- Développement durable : `'CION-DVP'`
	- Affaires sociales : `'CION-SOC'`
- organe de type commission spéciale : `'CION_SPE'`

**Example**: the first Macron law project organism identifier is `'CSCRACTIV'`.


#### legislature

The identifier of the legislature that will examine the law project. This number was [14](https://fr.wikipedia.org/wiki/XIVe_législature_de_la_Cinquième_République_française) in 2012 and is incremented by 1 each time a new Assembly is elected. Under French law at time of writing, this is every 5 years, unless it is dissolved.

**Example**: the first Macron law project legislature identifier is `14`.


### Amendments descriptions

The resulting amendments descriptions are basically a dump of what the National Assembly sends (typos included), with a few fields normalised. Please add your own [normalisers](https://github.com/sgmap/meteor-assemblee-nationale/blob/master/server/normalizers.js) if you feel like it!

Here is an example amendment description:

```json
{
	"alineaLabel": "av 1",
	"auteurGroupe": "UDI",
	"auteurLabel": "M. PANCHER",
	"auteurLabelFull": "M. PANCHER Bertrand",
	"discussionCommune": "",
	"discussionCommuneAmdtPositon": "",
	"discussionCommuneSsAmdtPositon": "",
	"discussionIdentique": "",
	"discussionIdentiqueAmdtPositon": "",
	"discussionIdentiqueSsAmdtPositon": "",
	"missionLabel": "",
	"numero": "SPE862",
	"parentNumero": "",
	"place": {
		"article": 1,
		"raw": "Article PREMIER",
		"type": "article",
	},
	"position": 1,
	"sort": "Adopté"
}
```

The more interesting parts are:

- `auteurGroupe`: the political group of the author of this amendment.
- `auteurLabel`: the name of the author of this amendment.
- `numero`: the ID of this amendment.
- `position`: the index of this amendment in the discussion.
- `sort`: result of the vote. For past project laws, may be one of `Rejeté` (rejected) or `Adopté` (adopted).
- `place`: an object describing the placement of this amendment in the project law. Contains:
	- `type`: the kind of text that is modified by this amendment. May be, for example, `article`, `titre` or `chapitre`.
	- `article`: the index of the modified article or chapter.
	- `placement`: an amendment may modify an article directly, in which case this field will be absent. It may also be an addition before or after an article, in which case this field will be respectively `AssembleeNationale.BEFORE` or `AssembleeNationale.AFTER`.
	- `raw`: the textual value sent by the Assembly from which the above fields were parsed.


## Licence

**MIT**: do what you want as long as you don't sue us nor prevent others to use all or parts of this piece of software. Oh hey, it's not required but if you want to support those digitally modernising the state, give credit! The more we get known, the more open-source software we can publish — pretty much your average startup, save for the business model  ;)
