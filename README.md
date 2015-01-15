# Get amendment data from the French National Assembly in Meteor

Accéder à des données d'amendements de l'Assemblée Nationale depuis Meteor.

## Usage

	meteor add sgmap:assemblee-nationale

The, on the server, you get access to a global `AssembleeNationale` namespace, from which you can call `AssembleeNationale.getAmendements(textId, [organismId], [legislature])`.

These parameters are described in the `server/assembleeNationale.js` file.
