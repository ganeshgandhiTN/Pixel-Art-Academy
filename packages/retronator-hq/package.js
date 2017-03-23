Package.describe({
  name: 'retronator:retronator-hq',
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
  api.use('retronator:retronator');
  api.use('retronator:retronator-store');
  api.use('retronator:pixelartacademy-cast');

  api.export('Retronator');

  api.addFile('hq');
  
  // Locations

  api.addFile('floor1/cafe/cafe');
  api.addFile('floor1/cafe/artworks');
  api.addScript('floor1/cafe/burra');
  api.addComponent('floor1/cafe/display/display');

  api.addFile('floor1/passage/passage');
  api.addFile('floor1/restroom/restroom');

  /*
  api.addFiles('1stfloor/entrance/entrance.coffee');
  api.addFiles('1stfloor/entrance/sign.coffee');

  api.addFiles('1stfloor/lobby/lobby.coffee');
  api.addAssets('1stfloor/lobby/tablet.script', ['client', 'server']);

  api.addFiles('1stfloor/lobby/display/display.coffee');
  api.addFiles('1stfloor/lobby/display/display.html');
  api.addFiles('1stfloor/lobby/display/display.styl');

  api.addFiles('1stfloor/reception/reception.coffee');
  api.addAssets('1stfloor/reception/burra.script', ['client', 'server']);

  api.addFiles('1stfloor/restroom/restroom.coffee');

  api.addFiles('1stfloor/gallery/gallery.coffee');

  api.addFiles('elevator/elevator.coffee');
  api.addFiles('elevator/numberpad.coffee');
  api.addAssets('elevator/numberpad.script', ['client', 'server']);

  api.addFiles('2ndfloor/steps/steps.coffee');

  api.addFiles('2ndfloor/store/store.coffee');

  api.addFiles('2ndfloor/checkout/checkout.coffee');
  api.addAssets('2ndfloor/checkout/retro.script', ['client', 'server']);

  api.addFiles('2ndfloor/checkout/display/display.coffee');
  api.addFiles('2ndfloor/checkout/display/display.html');
  api.addFiles('2ndfloor/checkout/display/display.styl');

  api.addFiles('2ndfloor/store/shelf/shelf.coffee');
  api.addFiles('2ndfloor/store/shelf/shelf.html');
  api.addFiles('2ndfloor/store/shelf/shelf.styl');
  api.addFiles('2ndfloor/store/shelf/shelf-game.coffee');
  api.addFiles('2ndfloor/store/shelf/shelf-upgrades.coffee');

  api.addFiles('3rdfloor/chillout/chillout.coffee');
  
  api.addFiles('3rdfloor/landsofillusions/landsofillusions.coffee');
  api.addFiles('3rdfloor/landsofillusions/methods-server.coffee', ['server']);
  api.addAssets('3rdfloor/landsofillusions/operator.script', ['client', 'server']);
  
  // Items

  api.addFiles('items/items.coffee');

  api.addFiles('items/wallet/wallet.coffee');
  api.addFiles('items/wallet/wallet.html');
  api.addFiles('items/wallet/wallet.styl');

  api.addFiles('items/tablet/tablet.coffee');
  api.addFiles('items/tablet/tablet.html');
  api.addFiles('items/tablet/tablet.styl');

  api.addFiles('items/tablet/os/os.coffee');
  api.addFiles('items/tablet/os/os.html');
  api.addFiles('items/tablet/os/os.styl');
  
  api.addFiles('items/tablet/os/app.coffee');
  api.addFiles('items/tablet/os/app.styl');

  api.addFiles('items/tablet/apps/apps.coffee');

  api.addFiles('items/tablet/apps/components/components.coffee');

  api.addFiles('items/tablet/apps/components/stripe/stripe.coffee');

  api.addFiles('items/tablet/apps/menu/menu.coffee');
  api.addFiles('items/tablet/apps/menu/menu.html');
  api.addFiles('items/tablet/apps/menu/menu.styl');

  api.addFiles('items/tablet/apps/welcome/welcome.coffee');
  api.addFiles('items/tablet/apps/welcome/welcome.html');
  api.addFiles('items/tablet/apps/welcome/welcome.styl');

  api.addFiles('items/tablet/apps/account/account.coffee');
  api.addFiles('items/tablet/apps/account/account.html');
  api.addFiles('items/tablet/apps/account/account.styl');

  api.addFiles('items/tablet/apps/manual/manual.coffee');
  api.addFiles('items/tablet/apps/manual/manual.html');
  api.addFiles('items/tablet/apps/manual/manual.styl');

  api.addFiles('items/tablet/apps/prospectus/prospectus.coffee');
  api.addFiles('items/tablet/apps/prospectus/prospectus.html');
  api.addFiles('items/tablet/apps/prospectus/prospectus.styl');

  api.addFiles('items/tablet/apps/shoppingcart/shoppingcart.coffee');
  api.addFiles('items/tablet/apps/shoppingcart/shoppingcart.html');
  api.addFiles('items/tablet/apps/shoppingcart/shoppingcart.styl');

  api.addFiles('items/tablet/apps/shoppingcart/receipt/receipt.coffee');
  api.addFiles('items/tablet/apps/shoppingcart/receipt/receipt.html');
  api.addFiles('items/tablet/apps/shoppingcart/receipt/receipt.styl');
*/
});
