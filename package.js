Package.describe({
	name: 'sgmap:assemblee-nationale',
	summary: 'Get amendment data from the French Assemblée Nationale',
	version: '0.0.1',
	git: 'git://github.com/sgmap/meteor-assemblee-nationale'
});

Npm.depends({
	xml2js: '0.4.4'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0.1');
	api.use('http', 'server');

	api.addFiles('server/assembleeNationale.js', 'server');

	api.export('AssembleeNationale');
});

Package.onTest(function(api) {
	api.use('coffeescript');
	api.use('tinytest');
	api.use('peterellisjones:describe');
	api.use('sgmap:assemblee-nationale');
	api.addFiles('test/assembleeNationale.coffee');
});
