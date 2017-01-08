AB = Artificial.Babel
AE = Artificial.Everywhere
AM = Artificial.Mirage
LOI = LandsOfIllusions
RA = Retronator.Accounts
RS = Retronator.Store
HQ = Retronator.HQ

class HQ.Items.Tablet.Apps.Components.Stripe extends AM.Component
  onCreated: ->
    super

    @stripeInitialized = new ReactiveField false
    @stripeEnabled = false

    @purchaseError = new ReactiveField null
    @submittingPayment = new ReactiveField false
    @purchaseCompleted = new ReactiveField false

  onRendered: ->
    super

    if Meteor.settings.public.stripe?.publishableKey
      @stripeEnabled = true

      initializeStripeInterval = Meteor.setInterval =>
        # Wait until checkout is ready.
        return unless StripeCheckout?

        Meteor.clearInterval initializeStripeInterval

        @_stripeCheckout = StripeCheckout.configure
          key: Meteor.settings.public.stripe.publishableKey
          token: (token) => @_stripeResponseHandler token
          image: 'https://stripe.com/img/documentation/checkout/marketplace.png'
          name: 'Retronator'
          locale: 'auto'

        @stripeInitialized true
      ,
        100

    else
      console.warn "Set Stripe public and secret key in the settings file if you want to enable Stripe purchases."

  onDestroyed: ->
    super

    # Clean up after stripe checkout.
    @_stripeCheckout?.close()
    $('.stripe_checkout_app').remove()

  submitPaymentButtonAttributes: ->
    disabled: true if @submittingPayment()
    
  tip: ->
    amount: 0
    message: null

  supporterName: -> null

  events: ->
    super.concat
      'click .submit-payment-button': @onClickSubmitPaymentButton

  onClickSubmitPaymentButton: (event) ->
    event.preventDefault()

    # See if we need to process the payment or it's simply a confirmation.
    paymentAmount = @paymentAmount()

    if paymentAmount
      # The user needs to make a payment, so open checkout.
      @_stripeCheckout.open
        amount: paymentAmount * 100

    else
      # The purchase does not need a payment, simply confirm the purchase.
      @_confirmationPurchaseHandler()

  _stripeResponseHandler: (token) ->
    # Clear the error they may have accrued.
    @purchaseError null

    # Get tokenized credit card info.
    creditCardToken = token.id

    # Get the customer details.
    customer =
      email: token.email

    # Create a payment on the server.
    shoppingCart = @_createShoppingCartObject()

    Meteor.call RS.Transactions.Transaction.insertStripePurchase, customer, creditCardToken, @paymentAmount(), shoppingCart, (error, data) =>
      @submittingPayment false

      if error
        @_displayError error
        return

      # Purchase is successfully completed.
      @_completePurchase()

  _createShoppingCartObject: ->
    items: @purchaseItems()
    supporterName: @supporterName()
    tip: @tip()

  _completePurchase: ->
    @purchaseCompleted true

  _confirmationPurchaseHandler: ->
    # Create a transaction on the server.
    @submittingPayment true

    shoppingCart = @_createShoppingCartObject()

    Meteor.call 'Retronator.Store.Transactions.Transaction.insertConfirmationPurchase', shoppingCart, (error, data) =>
      @submittingPayment false

      if error
        @_displayError error
        return

      # Purchase is successfully completed.
      @_completePurchase()

  _displayError: (error) ->
    errorText = "Error: #{error.reason}"
    errorText = "#{errorText} #{error.details}" if error.details
    @purchaseError errorText
    console.error error