Package.describe({
  name: 'retronator:landsofillusions',
  version: '0.1.0',
  // Brief, one-line summary of the package.
  summary: 'Game engine for Pixel Art Academy, Retropolis and beyond.',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/Retronator/Lands-of-Illusions.git',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('retronator:artificialengines');
  api.use('retronator:accounts');

  api.imply('retronator:artificialengines');
  api.imply('retronator:accounts');

  api.export('LandsOfIllusions');

  api.addFiles('landsofillusions.coffee');

  // Authorize

  api.addFiles('authorize/authorize.coffee');
  api.addFiles('authorize/user.coffee');
  api.addFiles('authorize/character.coffee');

  // Character

  api.addFiles('character/spacebars.coffee', 'client');
  api.addFiles('character/character.coffee');
  api.addFiles('character/methods.coffee');
  api.addFiles('character/subscriptions.coffee', 'server');

  // Assets

  api.addFiles('assets/assets.coffee');
  api.addFiles('assets/server.coffee');

  api.addFiles('assets/palette/palette.coffee');
  api.addFiles('assets/palette/atari2600.coffee', 'server');
  api.addFiles('assets/palette/subscriptions.coffee', 'server');

  api.addFiles('assets/sprite/sprite.coffee');

  api.addFiles('assets/mesh/mesh.coffee');

  // Adventure

  api.addFiles('adventure/adventure.html');
  api.addFiles('adventure/adventure.styl');
  api.addFiles('adventure/adventure.coffee');

  api.addFiles('adventure/item.coffee');
  api.addFiles('adventure/director.coffee');

  api.addFiles('adventure/location/location.coffee');
  api.addFiles('adventure/location/location.html');
  api.addFiles('adventure/location/location.styl');

  api.addFiles('adventure/actor/actor.coffee');
  api.addFiles('adventure/actor/actor.html');

  api.addFiles('adventure/actor/ability.coffee');
  api.addFiles('adventure/actor/abilities/abilities.coffee');

  api.addFiles('adventure/actor/abilities/action.coffee');
  api.addFiles('adventure/actor/abilities/action.html');

  api.addFiles('adventure/actor/abilities/talking.coffee');
  api.addFiles('adventure/actor/abilities/talking.html');
  api.addFiles('adventure/actor/abilities/talking.styl');

  api.addFiles('adventure/script/script.coffee');
  api.addFiles('adventure/script/node.coffee');
  api.addFiles('adventure/script/nodes/nodes.coffee');
  api.addFiles('adventure/script/nodes/dialogline.coffee');

  // Conversations

  api.addFiles('conversations/conversations.coffee');
  api.addFiles('conversations/conversation.coffee');
  api.addFiles('conversations/line.coffee');
  api.addFiles('conversations/methods.coffee');
  api.addFiles('conversations/subscriptions.coffee', 'server');

  // Typography

  api.addFiles('typography/typography.css', 'client');
  api.addFiles('typography/typography.styl', 'client');
  api.addFiles('typography/typography.import.styl', 'client', {isImport:true});

  // Styles

  api.addFiles('styles/styles.coffee');
  api.addFiles('styles/console.coffee');
  api.addFiles('styles/console.html');
  api.addFiles('styles/console.styl');
  api.addFiles('styles/console-accountsui.styl');
  api.addFiles('styles/helpers.import.styl', 'client', {isImport:true});
  api.addFiles('styles/atari2600.import.styl', 'client', {isImport:true});

});
