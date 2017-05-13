Package.describe({
  name: 'retronator:landsofillusions-construct',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('retronator:landsofillusions');
  api.use('retronator:retronator-hq');

  api.export('LandsOfIllusions');

  api.addFiles('construct.coffee');

  // Actors

  api.addFiles('actors/actors.coffee');
  api.addFiles('actors/captain.coffee');

  // Items

  api.addFiles('items/items.coffee');

  // Locations

  api.addFile('loading/loading');
  api.addStyle('loading/loading');
  api.addComponent('loading/tv/tv');
});
