RA = Retronator.Accounts

# Always send current user's display and public name.
Meteor.publish null, ->
  RA.User.documents.find
    _id: @userId
  ,
    fields:
      displayName: true
      publicName: true

# Current user's login services.
RA.User.servicesForCurrentUser.publish ->
  RA.User.documents.find
    _id: @userId
  ,
    fields:
      loginServices: true
      otherServices: true

RA.User.twitterScreenNameForCurrentUser.publish ->
  RA.User.documents.find
    _id: @userId
  ,
    fields:
      'services.twitter.screenName': true

# Current user's contact email.
Meteor.publish RA.User.contactEmailForCurrentUser, ->
  RA.User.documents.find
    _id: @userId
  ,
    fields:
      contactEmail: true

# Current user's registered emails.
Meteor.publish RA.User.registeredEmailsForCurrentUser, ->
  RA.User.documents.find
    _id: @userId
  ,
    fields:
      registered_emails: true
