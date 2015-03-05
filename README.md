# Get amendment data from the French National Assembly in Meteor

Accéder à des données d'amendements de l'Assemblée Nationale depuis Meteor.

## Usage

	meteor add sgmap:assemblee-nationale

The, on the server, you get access to a global `AssembleeNationale` namespace, from which you can call `AssembleeNationale.getAmendements(textId, [organismId], [legislature])`.

These parameters are described in the `server/assembleeNationale.js` file.


## Licence

**MIT**: do what you want as long as you don't sue us nor prevent others to use all or parts of this piece of software. Oh hey, it's not required but if you want to support those digitally modernising the state, give credit! The more we get known, the more open-source software we can publish — pretty much your average startup, save for the business model  ;)
