Package.describe({
  name: 'practice',
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
  api.use('pixelartacademy');
  api.use('edgee:slingshot');

  api.export('PixelArtAcademy');

  api.addFiles('practice.coffee');
  api.addFiles('server.coffee', 'server');
  api.addFiles('client.coffee', 'client');

  api.addFiles('checkin/checkin.coffee');
  api.addFiles('checkin/methods.coffee', 'server');
  api.addFiles('checkin/subscriptions.coffee', 'server');

  api.addFiles('calendar/checkinsprovider.coffee');
  
  api.addFiles('calendar/checkincomponent.html');
  api.addFiles('calendar/checkincomponent.coffee');
  api.addFiles('calendar/checkincomponent.styl');
});
