Package.describe({
  name: 'retronator:landsofillusions',
  version: '0.1.0',
  // Brief, one-line summary of the package.
  summary: 'Game engine for Pixel Art Academy, Retropolis and beyond.',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/Retronator/Landsofillusions.git',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('retronator:artificialengines');
  api.use('retronator:retronator-accounts');
  api.use('promise');
  api.use('modules');

  api.imply('retronator:artificialengines');
  api.imply('retronator:retronator-accounts');

  api.export('LandsOfIllusions');

  api.addFiles('landsofillusions.coffee');

  // Authorize

  api.addFiles('authorize/authorize.coffee');
  api.addFiles('authorize/user.coffee');
  api.addFiles('authorize/character.coffee');

  // Game state

  api.addFile('state/gamestate');
  api.addServerFile('state/gamestate-events-server');
  api.addFile('state/localgamestate');
  api.addFile('state/methods');
  api.addServerFile('state/subscriptions');
  api.addFile('state/stateobject');
  api.addFile('state/statefield');
  api.addFile('state/stateaddress');
  api.addFile('state/stateinstances');
  api.addFile('state/ephemeralstateobject');
  api.addFile('state/localsavegames');

  api.addServerFile('state/migrations/0000-immersionrevamp');
  api.addServerFile('state/migrations/0001-renamecollection');
  api.addServerFile('state/migrations/0002-addinggamestatefields');

  // Avatar

  api.addFile('avatar/avatar');
  api.addFile('avatar/humanavatar');

  // Character

  api.addFile('character/character');
  api.addFile('character/methods');
  api.addServerFile('character/subscriptions');
  api.addServerFile('character/migrations/0000-renamecollection');
  api.addServerFile('character/migrations/0001-userpublicname');
  api.addServerFile('character/migrations/0002-ownername');
  api.addServerFile('character/migrations/0003-migrateavatarfields');
  api.addServerFile('character/migrations/0004-displayname');
  api.addServerFile('character/migrations/0005-usercharactersupdate');
  api.addClientFile('character/spacebars');
  
  // Part system

  api.addFile('character/part/part');
  api.addFile('character/part/template');
  api.addFile('character/part/methods');
  api.addServerFile('character/part/subscriptions');
  
  api.addServerFile('character/part/migrations/0000-embeddedtranslations');
  api.addServerFile('character/part/migrations/0001-spriteids');

  api.addFile('character/part/property');
  api.addFile('character/part/properties/oneof');
  api.addFile('character/part/properties/array');
  api.addFile('character/part/properties/integer');
  api.addFile('character/part/properties/string');
  api.addFile('character/part/properties/boolean');
  
  // Avatar parts

  api.addFile('character/avatar/avatar');
  api.addFile('character/avatar/landmark');

  api.addFile('character/avatar/parts/parts');
  api.addFile('character/avatar/parts/shape');
  api.addFile('character/avatar/parts/skinshape');
  api.addFile('character/avatar/parts/partwithcustomcolors');

  api.addFile('character/avatar/properties/properties');
  api.addFile('character/avatar/properties/color');
  api.addFile('character/avatar/properties/relativecolorshade');
  api.addFile('character/avatar/properties/sprite');

  api.addFile('character/avatar/renderers/renderers');
  api.addFile('character/avatar/renderers/renderer');
  api.addFile('character/avatar/renderers/shape');
  api.addFile('character/avatar/renderers/default');
  api.addFile('character/avatar/renderers/humanavatar');
  api.addFile('character/avatar/renderers/mappedshape');
  api.addFile('character/avatar/renderers/bodypart');
  api.addFile('character/avatar/renderers/body');
  api.addFile('character/avatar/renderers/head');
  api.addFile('character/avatar/renderers/chest');
  api.addFile('character/avatar/renderers/breasts');

  api.addFile('character/avatar/landmarks/position');

  api.addFile('character/avatar/initialize/body');
  api.addFile('character/avatar/initialize/outfit');

  // Behavior parts

  api.addFile('character/behavior/behavior');
  
  api.addFile('character/behavior/parts/parts');
  api.addFile('character/behavior/parts/personality');
  api.addFile('character/behavior/parts/personality-factor');
  api.addFile('character/behavior/parts/trait');
  api.addFile('character/behavior/parts/activity');
  api.addFile('character/behavior/parts/environment');
  api.addFile('character/behavior/parts/perk');

  api.addFile('character/behavior/properties/activities');
  api.addFile('character/behavior/properties/people');
  api.addFile('character/behavior/properties/perks');
  api.addFile('character/behavior/properties/traits');

  api.addFile('character/behavior/initialize/behavior');
  api.addFile('character/behavior/initialize/personality');
  api.addFile('character/behavior/initialize/traits-data');
  api.addFile('character/behavior/initialize/traits');
  api.addFile('character/behavior/initialize/activities');

  // Perk definitions must come after properties/perks and initialize/behavior.
  api.addFile('character/behavior/parts/perks/deadendjob');
  api.addFile('character/behavior/parts/perks/creativemess');
  api.addFile('character/behavior/parts/perks/minimalist');
  api.addFile('character/behavior/parts/perks/nothingtoclean');
  api.addFile('character/behavior/parts/perks/nofreetime');
  api.addFile('character/behavior/parts/perks/renaissancesoul');
  api.addFile('character/behavior/parts/perks/focused');
  api.addFile('character/behavior/parts/perks/spontaneous');
  api.addFile('character/behavior/parts/perks/organized');
  api.addFile('character/behavior/parts/perks/introvert');
  api.addFile('character/behavior/parts/perks/socializer');
  api.addFile('character/behavior/parts/perks/competitor');
  api.addFile('character/behavior/parts/perks/teammate');

  // User

  api.addFile('user/user');
  api.addServerFile('user/subscriptions');

  // Memories

  api.addFile('memory..');
  api.addFile('memory/methods');
  api.addServerFile('memory/subscriptions');
  api.addServerFile('memory/migrations/0000-renamecollection');
  api.addServerFile('memory/migrations/0001-linesreversereferencefieldsupdate');
  api.addServerFile('memory/migrations/0002-renamecollection');
  api.addServerFile('memory/migrations/0003-changetomemories');
  api.addServerFile('memory/migrations/0004-actionsreversereferencefieldadded');

  api.addFile('memory/action..');
  api.addFile('memory/action/methods');
  api.addServerFile('memory/action/subscriptions');
  api.addServerFile('memory/action/migrations/0000-renamecollection');
  api.addServerFile('memory/action/migrations/0001-characterreferencefieldsupdate');
  api.addServerFile('memory/action/migrations/0002-removecharacternamefield');
  api.addServerFile('memory/action/migrations/0003-renamecollection');
  api.addServerFile('memory/action/migrations/0004-changetomemories');

  api.addFile('memory/actions..');
  api.addFile('memory/actions/move');
  api.addFile('memory/actions/leave');
  api.addFile('memory/actions/say');

  api.addFile('memory/progress..');
  api.addFile('memory/progress/methods');
  api.addServerFile('memory/progress/subscriptions');

  // Parser

  api.addFile('parser..');
  api.addFile('parser/parser-likelyactions');
  api.addFile('parser/command');
  api.addFile('parser/commandresponse');
  api.addFile('parser/enterresponse');
  api.addFile('parser/exitresponse');

  api.addFile('parser/vocabulary/vocabulary');
  api.addFile('parser/vocabulary/vocabularykeys');
  api.addServerFile('parser/vocabulary/english-server');

  // Director

  api.addFile('director..');

  // Adventure

  api.addComponent('adventure..');
  api.addFile('adventure/adventure-routing');
  api.addFile('adventure/adventure-state');
  api.addFile('adventure/adventure-memories');
  api.addFile('adventure/adventure-location');
  api.addFile('adventure/adventure-context');
  api.addFile('adventure/adventure-timeline');
  api.addFile('adventure/adventure-item');
  api.addFile('adventure/adventure-inventory');
  api.addFile('adventure/adventure-episodes');
  api.addFile('adventure/adventure-things');
  api.addFile('adventure/adventure-listeners');
  api.addFile('adventure/adventure-time');
  api.addFile('adventure/adventure-dialogs');
  api.addFile('adventure/adventure-assets');

  // Initalization gets included last because it does component registering as the last child in the chain.
  api.addFile('adventure/adventure-initialization');

  // Situations

  api.addFile('adventure/situation..');
  api.addFile('adventure/situation/circumstance');

  // Listener

  api.addFile('adventure/listener..');
  
  // Thing

  api.addUnstyledComponent('adventure/thing/thing');
  api.addFile('adventure/thing/avatar');

  // Item

  api.addFile('adventure/item/item');

  // Script

  api.addFiles('adventure/script/scriptfile.coffee');
  api.addFiles('adventure/script/script.coffee');

  api.addFiles('adventure/script/helpers/helpers.coffee');
  api.addFiles('adventure/script/helpers/iteminteraction.coffee');

  api.addFiles('adventure/script/node.coffee');
  api.addFiles('adventure/script/nodes/nodes.coffee');
  api.addFiles('adventure/script/nodes/script.coffee');
  api.addFiles('adventure/script/nodes/label.coffee');
  api.addFiles('adventure/script/nodes/callback.coffee');
  api.addFiles('adventure/script/nodes/dialogueline.coffee');
  api.addFiles('adventure/script/nodes/narrativeline.coffee');
  api.addFiles('adventure/script/nodes/interfaceline.coffee');
  api.addFiles('adventure/script/nodes/commandline.coffee');
  api.addFiles('adventure/script/nodes/code.coffee');
  api.addFiles('adventure/script/nodes/conditional.coffee');
  api.addFiles('adventure/script/nodes/jump.coffee');
  api.addFiles('adventure/script/nodes/choice.coffee');
  api.addFiles('adventure/script/nodes/choiceplaceholder.coffee');
  api.addFiles('adventure/script/nodes/timeout.coffee');
  api.addFiles('adventure/script/nodes/pause.coffee');

  api.addFiles('adventure/script/parser/parser.coffee');

  // Character instance (inherits from Thing and uses Script) and derivatives

  api.addFile('character/instance');
  api.addFile('character/person');

  // Storylines

  api.addFile('adventure/global..');
  api.addFile('adventure/episode..');
  api.addFile('adventure/section..');
  api.addComponent('adventure/chapter..');
  api.addFile('adventure/scene..');

  // Locations and inventory

  api.addFile('adventure/region..');
  api.addFile('adventure/location..');
  api.addFile('adventure/location/inventory');

  // Context

  api.addFile('adventure/context..');

  api.addFile('memory/context');

  // Events
  
  api.addFile('adventure/event..');
  api.addFile('adventure/event/stopevent');

  // Parser Listeners

  api.addFiles('parser/listeners/debug.coffee');
  api.addFiles('parser/listeners/navigation.coffee');
  api.addFiles('parser/listeners/description.coffee');
  api.addFiles('parser/listeners/looklocation.coffee');

  // Interface

  api.addFiles('interface/interface.coffee');

  api.addFiles('interface/components/components.coffee');
  api.addFiles('interface/components/narrative.coffee');
  api.addFiles('interface/components/commandinput.coffee');
  api.addFiles('interface/components/dialogueselection.coffee');

  api.addFiles('interface/text/text.coffee');
  api.addFiles('interface/text/text.html');
  api.addFiles('interface/text/text.styl');
  api.addFiles('interface/text/text-initialization.coffee');
  api.addFiles('interface/text/text-narrative.coffee');
  api.addFiles('interface/text/text-handlers.coffee');
  api.addFiles('interface/text/text-nodehandling.coffee');
  api.addFiles('interface/text/text-resizing.coffee');
  api.addFiles('interface/text/text-scrolling.coffee');

  // Pages

  api.addFiles('pages/pages.coffee');
  api.addFiles('pages/loading/loading.coffee');
  api.addFiles('pages/loading/loading.html');
  api.addFiles('pages/loading/loading.styl');

  // Components

  api.addFile('components..');

  api.addFile('components/mixins..');
  api.addFile('components/mixins/activatable..');

  api.addComponent('components/overlay..');
  api.addComponent('components/backbutton..');
  api.addComponent('components/signin..');
  api.addComponent('components/storylinetitle..');
  api.addComponent('components/hand..');

  api.addComponent('components/menu..');
  api.addComponent('components/menu/items..');

  api.addComponent('components/account..');
  api.addFile('components/account/account-page');
  api.addStyle('components/account/account-pagecontent');

  api.addComponent('components/account/contents..');
  api.addComponent('components/account/general..');
  api.addComponent('components/account/services..');
  api.addComponent('components/account/characters..');
  api.addComponent('components/account/inventory..');
  api.addComponent('components/account/transactions..');
  api.addComponent('components/account/paymentmethods..');

  api.addStyle('components/dialogs/accounts');
  api.addComponent('components/dialogs/dialog');
  
  api.addComponent('components/translationinput..');
  api.addUnstyledComponent('components/sprite..');
  api.addUnstyledComponent('components/computer..');

  api.addUnstyledComponent('components/embeddedwebpage..');

  // Typography

  api.addCss('typography..');
  api.addStyleImport('typography..');

  // Styles

  api.addStyleImport('style..');
  api.addStyleImport('style/atari2600');
  api.addStyleImport('style/cursors');
  api.addStyle('style/cursors');
  api.addStyle('style/defaults');

  // Helpers

  api.addFile('helpers/spacebars');
  api.addFile('helpers/lodash');
  
  // Emails

  api.addFile('emails..');
  api.addFile('emails/email');
  api.addFile('emails/inbox');

  // Time

  api.addFile('time..');
  api.addFile('time/gamedate');

  // Simulation

  api.addFile('simulation..');
  api.addServerFile('simulation/server');

});
