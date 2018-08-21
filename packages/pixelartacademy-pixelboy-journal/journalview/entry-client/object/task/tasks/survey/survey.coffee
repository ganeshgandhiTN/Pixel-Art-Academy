AB = Artificial.Babel
AM = Artificial.Mirage
PAA = PixelArtAcademy
Entry = PAA.PixelBoy.Apps.Journal.JournalView.Entry

class Entry.Object.Task.Survey extends Entry.Object.Task.Component
  @id: -> 'PixelArtAcademy.PixelBoy.Apps.Journal.JournalView.Entry.Object.Task.Survey'
  @version: -> '0.1.0'

  @register @id()
  template: -> @constructor.id()
  
  onCreated: ->
    super

    @state = new ComputedField =>
      @parent.value()?.data or {}

  updateQuestion: (key, value) ->
    state = @state()
    state[key] = value

    parentValue = @parent.value()
    parentValue.data = state
    @parent.value parentValue

  confirmationEnabledClass: ->
    'enabled' if @ready() and @active() and @answered() and not @task.completed()

  answered: ->
    # TODO
    true

  questions: ->
    @task.constructor.questions()

  promptTranslation: ->
    question = @currentData()
    AB.translation @task._translationSubscription, "survey.#{question.key}"

  events: ->
    super.concat
      'click .confirm-button': @onClickConfirmButton

  onClickConfirmButton: (event) ->
    PAA.Learning.Task.Entry.insert LOI.characterId(), @task.id()

  class @MultipleChoice extends AM.Component
    @register 'PixelArtAcademy.PixelBoy.Apps.Journal.JournalView.Entry.Object.Task.Survey.MultipleChoice'

    onCreated: ->
      super

      question = @data()
      @survey = @ancestorComponentOfType Entry.Object.Task.Survey

      @state = new ComputedField =>
        @survey.state()[question.key] or {}
        
    updateChoice: (key, value) =>
      question = @data()
      state = @state()
      
      if value?
        state[key] = value
        
      else
        delete state[key]
        
      @survey.updateQuestion question.key, state

    active: ->
      @survey.active()

    answerTranslation: ->
      question = @data()
      choice = @currentData()

      AB.translation @survey.task._translationSubscription, "survey.#{question.key}.#{choice.key}"

    showText: ->
      choice = @currentData()
      return unless choice.text

      # Option needs to be checked to show the input.
      @state()[choice.key]?

    class @Choice extends AM.DataInputComponent
      @register 'PixelArtAcademy.PixelBoy.Apps.Journal.JournalView.Entry.Object.Task.Survey.MultipleChoice.Choice'

      constructor: ->
        super

        @type = AM.DataInputComponent.Types.Checkbox

      onCreated: ->
        super

        @multipleChoice = @ancestorComponentOfType Entry.Object.Task.Survey.MultipleChoice

      load: ->
        choice = @data()
        state = @multipleChoice.state()
        state[choice.key]?

      save: (value) ->
        choice = @data()

        if value
          if choice.text
            value = ''

          else
            value = true

        else
          value = null

        @multipleChoice.updateChoice choice.key, value

    class @Text extends AM.DataInputComponent
      @register 'PixelArtAcademy.PixelBoy.Apps.Journal.JournalView.Entry.Object.Task.Survey.MultipleChoice.Text'

      constructor: ->
        super

        @type = AM.DataInputComponent.Types.Text

      onCreated: ->
        super

        @multipleChoice = @ancestorComponentOfType Entry.Object.Task.Survey.MultipleChoice

      load: ->
        choice = @data()
        state = @multipleChoice.state()
        state[choice.key]

      save: (value) ->
        choice = @data()
        state = @multipleChoice.state()

        state[choice.key] = value

        @multipleChoice.state state
